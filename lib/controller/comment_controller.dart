import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/comment_model.dart';
import 'auth_controller.dart';

class CommentController extends GetxController {
  var comments = <Comment>[].obs;

  void fetchComments(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      comments.value = snapshot.docs.map((doc) {
        return Comment.fromDocument(doc);
      }).toList();
    });
  }

  void addComment(String postId, String content) {
    if (content.isEmpty) return;

    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'authorId': Get.find<AuthController>().auth.currentUser?.email, // Assuming you have the current user ID
    });
  }
}
