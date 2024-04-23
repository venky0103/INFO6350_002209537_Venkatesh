import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'main.dart';

class Post_Detail_Screen extends StatefulWidget {
  final Post post;

  const Post_Detail_Screen({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<Post_Detail_Screen> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _currentPageNotifier = ValueNotifier<int>(0);
    _pageController = PageController();
    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page!.round();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: _buildImageSlider(
                  widget.post.imageUrl1,
                  widget.post.imageUrl2,
                  widget.post.imageUrl3,
                  widget.post.imageUrl4,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50], // Light yellow background color
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title: ${widget.post.title}',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontFamily: 'YourFontFamily', // Set your desired font family
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Description: ${widget.post.description}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'YourFontFamily', // Set your desired font family
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(23.0),
                      child: Text(
                        '\$${widget.post.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider(String imageUrl1, String imageUrl2, String imageUrl3, String imageUrl4) {
    List<String> imageUrls = [imageUrl1, imageUrl2, imageUrl3, imageUrl4];

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return _buildImageWidget(imageUrls[index]);
            },
          ),
        ),
        SizedBox(height: 10.0),
        _buildDots(imageUrls.length),
      ],
    );
  }

  Widget _buildDots(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          width: 10.0,
          height: 5.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPageNotifier.value == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return imageUrl.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    )
        : Container();
  }
}
