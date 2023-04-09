import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/auth/email_verification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home/home_screen.dart';

class AuthService {
  Future<void> signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    String? errorMessage;
    final auth = FirebaseAuth.instance;
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        throw e;
      });
      final docUser = FirebaseFirestore.instance.collection('users').doc(email);
      final emailData = {'email': email, 'name': name};
      await docUser.set(emailData);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmailVerification()));
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color1);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color1);
    }
  }

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final auth = FirebaseAuth.instance;
    String? errorMessage;
    try {
      final user = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        throw e;
      });
      String name;
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      // Retrieve the name field from the document data
      name = snapshot.data()!['name'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setBool('isLoggedIn', true);
      Fluttertoast.showToast(msg: "Login Successful", backgroundColor: color1);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color1);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: color1);
    }
  }
}
