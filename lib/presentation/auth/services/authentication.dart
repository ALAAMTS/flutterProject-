import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    bool isWorker = false,
    String? city,
    String? dob,
    String? workType,
  }) async {
    String res = "An error occurred.";
    try {
      // Validate email and password fields
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please fill out all required fields.";
      }

      // Worker-specific validation
      if (isWorker && (city == null || dob == null || workType == null)) {
        return "Please complete all fields for Worker sign-up.";
      }

      // Create user in Firebase Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user is created successfully
      User? user = credential.user;
      if (user != null) {
        Map<String, dynamic> userData = {
          "name": name,
          "email": email,
          "uid": user.uid,
          "isWorker": isWorker,
        };

        if (isWorker) {
          userData.addAll({
            "city": city,
            "dob": dob,
            "workType": workType,
          });
        }

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set(userData);
        res = "success";
      } else {
        res = "User creation failed.";
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'weak-password') {
        res = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'An account already exists for this email.';
      } else {
        res = e.message ?? "An unknown error occurred.";
      }
    } catch (e) {
      res = "Error: ${e.toString()}";
      print(e);
    }

    return res;
  }

  Future<String> signInUser({
  required String email,
  required String password,
}) async {
  String res = "An error occurred.";
  try {
    // Validate email and password fields
    if (email.isNotEmpty && password.isNotEmpty) {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Get user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users')
        .doc(userCredential.user!.uid)
        .get();

      // Check if user exists in Firestore
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData['isWorker'] == true) {
          // User is a worker
          res = "worker";
        } else {
          // User is a client
          res = "client";
        }
      } else {
        res = "User data not found.";
      }
    } else {
      res = "Please enter all fields.";
    }
  } on FirebaseAuthException catch (e) {
    res = e.message ?? "An unknown error occurred.";
  } catch (e) {
    res = "Error: ${e.toString()}";
    print(e);
  }
  return res;
}

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}