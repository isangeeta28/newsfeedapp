import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/post_controller.dart';
import '../controller/theme_controll.dart';

class CreatePostView extends StatelessWidget {
  final PostController _postController = Get.find();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share Your Thoughts',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  filled: true,
                  fillColor: themeController.isDarkMode.value ? Colors.grey[850] : Colors.teal[50],
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: TextStyle(color: Colors.teal),
                ),
                style: TextStyle(fontSize: 18, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: "Content",
                  filled: true,
                  fillColor: themeController.isDarkMode.value ? Colors.grey[850] : Colors.teal[50],
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: TextStyle(color: Colors.teal),
                ),
                maxLines: 4,
                style: TextStyle(fontSize: 16, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _postController.createPost(_titleController.text, _contentController.text);
                  Get.back(); // Go back after creating post
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send),
                    SizedBox(width: 10),
                    Text(
                      "Post",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
    );
  }
}

