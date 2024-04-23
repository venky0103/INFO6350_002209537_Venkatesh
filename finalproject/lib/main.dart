// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:practicef/SignInScreen.dart';
import 'New_Post_Screen.dart';
import 'Post_Detail_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Post {
  final String title;
  final double price;
  final String description;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String imageUrl4;

  Post({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.imageUrl3,
    required this.imageUrl4,
  });

}

Future<String> getDownloadUrl(String imagePath) async {
  Reference storageRef = FirebaseStorage.instance.ref().child(imagePath);
  return await storageRef.getDownloadURL();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyARkanM-oXIscJdqzV8axNlMUmMutrQGRU',
      appId: '1:891054462025:android:d5230c5a2fd52d8b311b98',
      messagingSenderId: '891054462025',
      projectId: 'neu-fall-2024',
    ),
  );

  runApp(MaterialApp(
    home: SignInScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Browse Posts'),
          backgroundColor: Colors.blue, // Set AppBar background color
        ),
        body: _buildPostList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('FAB Pressed');
            _navigateToNextScreen(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildPostList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('shital').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Post> postList = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return Post(
            title: data['title'] as String? ?? '',
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            description: data['description'] as String? ?? '',
            imageUrl1: data['image1'] as String? ?? '',
            imageUrl2: data['image2'] as String? ?? '',
            imageUrl3: data['image3'] as String? ?? '',
            imageUrl4: data['image4'] as String? ?? '',
          );
        }).toList();

        if (postList.isEmpty) {
          return Center(child: Text('No posts available.'));
        }

        return ListView.builder(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.teal[50],
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                onTap: () {
                  _navigateToPostDetailScreen(context, postList[index]);
                },
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  width: 80,
                  height: 80,
                  child: postList[index].imageUrl1.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: postList[index].imageUrl1,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.image),
                    fit: BoxFit.cover,
                  )
                      : Container(),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ${postList[index].title}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Price: \$${postList[index].price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height: 4),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToPostDetailScreen(BuildContext context, Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Post_Detail_Screen(post: post)),
    );
  }
}

void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => New_Post_Screen()));
}
