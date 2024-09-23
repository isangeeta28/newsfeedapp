import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to upload post
  Future<String> uploadPost({
    required String description,
    required File file,
    required String uid,
    required String username,
    required String photoUrl,
  }) async {
    String res = "Some error occurred";
    try {
      // Generate a unique ID for the post
      String postId = const Uuid().v1();

      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage('posts/$postId', file);

      // Create post data
      Map<String, dynamic> postData = {
        "description": description,
        "uid": uid,
        "username": username,
        "photoUrl": photoUrl,
        "imageUrl": imageUrl, // Image URL from Firebase Storage
        "postId": postId,
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Save post data to Firestore
      await _firestore.collection('posts').doc(postId).set(postData);

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Helper method to upload the image to Firebase Storage
  Future<String> _uploadImageToStorage(String path, File file) async {
    try {
      Reference storageRef = _storage.ref().child(path);
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (err) {
      throw err.toString();
    }
  }
}


showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}