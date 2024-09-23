import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/post_controller.dart';
import '../controller/theme_controll.dart';
import '../model/post_model.dart';

class EditPostView extends StatelessWidget {
  final Post post;
  final PostController _postController = Get.find();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ThemeController themeController = Get.find();

  EditPostView({required this.post}) {
    _titleController.text = post.title;
    _contentController.text = post.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Edit Post',
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
                'Edit Your Post',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                        style: TextStyle(fontSize: 16, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
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
                        maxLines: 5,
                        style: TextStyle(fontSize: 16, color: themeController.isDarkMode.value ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _postController.editPost(post.id, _titleController.text, _contentController.text);
                    Get.back(); // Go back after editing post
                  },
                  style: ElevatedButton.styleFrom(
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
                      Icon(Icons.save, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
