import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/post_controller.dart';
import '../controller/theme_controll.dart';
import 'add_post_screen.dart';
import 'edit_post_view.dart';

class NewsFeedView extends StatelessWidget {
  final PostController _postController = Get.put(PostController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Feed'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Get.find<ThemeController>().isDarkMode.value
                ? Icons.wb_sunny
                : Icons.nights_stay),
            onPressed: () {
              Get.find<ThemeController>().toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_postController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_postController.posts.isEmpty) {
          return Center(
            child: Text(
              'No posts to show.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _postController.posts.length,
          itemBuilder: (context, index) {
            final post = _postController.posts[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            post.content,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Posted on: ${post.timestamp.toDate().toLocal().toString().split(' ')[0]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  Text('${post.likes}', style: TextStyle(color: Colors.red)),
                                  IconButton(
                                    icon: Icon(
                                      post.likedBy.contains(FirebaseAuth.instance.currentUser!.uid)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    color: post.likedBy.contains(FirebaseAuth.instance.currentUser!.uid)
                                        ? Colors.red
                                        : Colors.grey,
                                    onPressed: () {
                                      _postController.likePost(post.id);
                                    },
                                  ),
                                  // Edit and Delete options
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Get.to(EditPostView(post: post)); // Navigate to edit screen
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _postController.deletePost(post.id); // Delete post
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(CreatePostView());
        },
      ),
    );
  }
}
