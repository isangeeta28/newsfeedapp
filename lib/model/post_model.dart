import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final Timestamp timestamp;
  int likes;
  List<String> likedBy; // List of user IDs who liked the post

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.likedBy = const [],
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []), // Fetch likedBy from Firestore
    );
  }
}
