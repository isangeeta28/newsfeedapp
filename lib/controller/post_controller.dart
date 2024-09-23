import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/comment_model.dart';
import '../model/post_model.dart';

class PostController extends GetxController {
  var isLoading = true.obs;
  var posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  // Fetch posts from Firestore
  void fetchPosts() {
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      posts.value = snapshot.docs.map((doc) {
        return Post.fromDocument(doc);
      }).toList();
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to load posts: ${error.toString()}");
    });
  }

  // Get comments for a specific post
  Stream<List<Comment>> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Comment.fromDocument(doc))
        .toList());
  }

  // Add a comment to a specific post
  void addComment(String postId, String content) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'content': content,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }


  // Add new post
  void createPost(String title, String content) {
    FirebaseFirestore.instance.collection('posts').add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'author': FirebaseAuth.instance.currentUser!.email,
    });
  }

  // Edit existing post
  void editPost(String postId, String title, String content) {
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'title': title,
      'content': content,
    });
  }

  // Delete a post
  void deletePost(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  // Like/Unlike Post (already implemented)
  void likePost(String postId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final postIndex = posts.indexWhere((post) => post.id == postId);

    if (postIndex != -1) {
      final post = posts[postIndex];

      if (post.likedBy.contains(userId)) {
        post.likes--;
        post.likedBy.remove(userId);
      } else {
        post.likes++;
        post.likedBy.add(userId);
      }

      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': post.likes,
        'likedBy': post.likedBy,
      });

      posts[postIndex] = post;
    }
  }

}
