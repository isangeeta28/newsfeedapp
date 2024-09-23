import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../views/news_feed_page.dart';
import '../views/login_page.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => LoginPage());
      } else {
        Get.offAll(() => NewsFeedView());
      }
    });
  }

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Login Error", "Please enter both email and password");
      return;
    }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Invalid password. Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        default:
          errorMessage = "An unknown error occurred.";
      }
      Get.snackbar("Login Error", errorMessage);
    } catch (e) {
      Get.snackbar("Login Error", "An error occurred. Please try again.");
    }
  }

  void signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Signup Error", "Please enter both email and password");
      return;
    }

    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case 'email-already-in-use':
          errorMessage = "The account already exists for this email.";
          break;
        case 'invalid-email':
          errorMessage = "The email format is invalid.";
          break;
        default:
          errorMessage = "An unknown error occurred.";
      }
      Get.snackbar("Signup Error", errorMessage);
    } catch (e) {
      Get.snackbar("Signup Error", "An error occurred. Please try again.");
    }
  }


  void logout() async {
    await auth.signOut();
  }
}
