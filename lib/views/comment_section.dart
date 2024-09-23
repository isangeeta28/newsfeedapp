import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/comment_controller.dart';

class CommentSection extends StatelessWidget {
  final String postId;
  final CommentController _commentController = Get.put(CommentController());

  CommentSection({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the list of comments
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _commentController.comments.length,
            itemBuilder: (context, index) {
              final comment = _commentController.comments[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${comment.authorId}: ${comment.content}'),
              );
            },
          ),
          // Display the comment input field
          TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _commentController.addComment(postId, value);
            },
          ),
        ],
      );
    });
  }
}
