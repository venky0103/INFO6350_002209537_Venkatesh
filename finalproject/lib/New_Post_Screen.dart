// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class New_Post_Screen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<New_Post_Screen> {
  late FirebaseStorage storage;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      storage = FirebaseStorage.instanceFor(bucket: 'neu-fall-2024.appspot.com');
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String title = '';
  double price = 0.0;
  String description = '';

  var imageChoose = [false, false, false, false];

  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  File? imageFile4;

  _openCamera(BuildContext context, var id) async {
    final XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picture != null) {
      setState(() {
        _setImageFile(id, picture);
      });
    }
    imageChoose[id] = true;
    print('${picture?.path}');
    Navigator.of(context).pop();
  }

  void _setImageFile(int id, XFile picture) {
    switch (id) {
      case 0:
        imageFile1 = File(picture.path);
        break;
      case 1:
        imageFile2 = File(picture.path);
        break;
      case 2:
        imageFile3 = File(picture.path);
        break;
      case 3:
        imageFile4 = File(picture.path);
        break;
    }
  }

  _openGallery(BuildContext context, var id) async {
    final XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture != null) {
      setState(() {
        _setImageFile(id, picture);
      });
    }
    imageChoose[id] = true;
    print('${picture?.path}');
    Navigator.of(context).pop();
  }

  Future uploadFile() async {
    try {
      String? url1 = await _uploadImage(imageFile1!, 'file1');
      String? url2 = await _uploadImage(imageFile2!, 'file2');
      String? url3 = await _uploadImage(imageFile3!, 'file3');
      String? url4 = await _uploadImage(imageFile4!, 'file4');

      print('URL 1: $url1');
      print('URL 2: $url2');
      print('URL 3: $url3');
      print('URL 4: $url4');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<String?> _uploadImage(File imageFile, String fileName) async {
    String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final destination = 'files/$uniqueFileName';
    // final storagePath = 'gs://neu-fall-2024.appspot.com/$destination';

    try {
      final ref = FirebaseStorage.instanceFor(bucket: 'neu-fall-2024.appspot.com').ref(destination);
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      await ref.putFile(imageFile, metadata);
      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Widget _buildImage(int index) {
    if (imageChoose[index]) {
      File? selectedImage;
      switch (index) {
        case 0:
          selectedImage = imageFile1;
          break;
        case 1:
          selectedImage = imageFile2;
          break;
        case 2:
          selectedImage = imageFile3;
          break;
        case 3:
          selectedImage = imageFile4;
          break;
      }
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Icon(
          Icons.add,
        ),
      );
    }
  }

  void _postButtonPressed(BuildContext context) async {
    try {
      String title = this.title;
      double price = this.price;
      String description = this.description;

      if (title.isEmpty || price == 0.0 || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all the required fields.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      String? url1 = imageFile1 != null ? await _uploadImage(imageFile1!, 'file1') : null;
      String? url2 = imageFile2 != null ? await _uploadImage(imageFile2!, 'file2') : null;
      String? url3 = imageFile3 != null ? await _uploadImage(imageFile3!, 'file3') : null;
      String? url4 = imageFile4 != null ? await _uploadImage(imageFile4!, 'file4') : null;

      Map<String, dynamic> postData = {
        'title': title,
        'price': price,
        'description': description,
        'image1': url1,
        'image2': url2,
        'image3': url3,
        'image4': url4,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New post added successfully.'),
          duration: Duration(seconds: 3),
        ),
      );

      await FirebaseFirestore.instance.collection('shital').add(postData);

      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        title = '';
        price = 0.0;
        description = '';
        imageChoose = [false, false, false, false];
        imageFile1 = null;
        imageFile2 = null;
        imageFile3 = null;
        imageFile4 = null;
      });
    } catch (error) {
      print('Error adding post: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding post. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New Post Screen'),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () => _postButtonPressed(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  onChanged: (value) {
                    setState(() {
                      price = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    for (int i = 0; i < 4; i++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text('Take a photo'),
                                        onTap: () {
                                          _openCamera(context, i);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo),
                                        title: Text('Choose from gallery'),
                                        onTap: () {
                                          _openGallery(context, i);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: _buildImage(i),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _postButtonPressed(context),
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
