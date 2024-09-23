import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String content;
  final Timestamp timestamp; // Timestamp for when the comment was made
  final String authorId; // ID of the user who made the comment

  Comment({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.authorId,
  });

  // Create a Comment instance from Firestore document
  factory Comment.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      authorId: data['authorId'] ?? '',
    );
  }
}
