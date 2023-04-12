import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delibuddy/views/order_request/order_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delibuddy/constants.dart';
import 'package:delibuddy/views/auth/email_verification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home/home_screen.dart';

class AuthService {
  Future<void> signUpUser(
      {required BuildContext context,
      required String name,
      required String email,
      required String password,
      bool isReferral = false,
      String referralProvided = ''}) async {
    String? errorMessage;
    final auth = FirebaseAuth.instance;
    try {
      List<String> referralList = [];
      //checking validity of referralCode
      if (isReferral) {
        final QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance.collection('users').get();
        bool isFound = false;
        for (var doc in querySnapshot.docs) {
          if (doc.data()['referralCode'] == referralProvided) {
            final mp = doc.data();
            if (mp['referralCount'] >= 3) {
              break;
            }
            mp['referralCount'] += 1;
            String docId = mp['email'];

            //A refers B, so A also gets a coupon code
            Random random = Random();
            String alphabet = 'abcdefghijklmnopqrstuvwxyz';
            List<dynamic> existingUserList = mp['referralList'];
            String referralCoupon = '';
            for (int i = 0; i < 6; i++) {
              int index = random.nextInt(26);
              referralCoupon += alphabet[index];
            }
            existingUserList.add(referralCoupon);
            mp['referralList'] = existingUserList;

            final DocumentReference documentRef =
                FirebaseFirestore.instance.collection('users').doc(docId);
            await documentRef.update(mp);

            //if A refers B, B gets a referral coupon to redeem later
            referralList.add(referralProvided.toUpperCase());
            isFound = true;
            break;
          }
        }

        if (!isFound) {
          Fluttertoast.showToast(
              msg: "Invalid Referral Code", backgroundColor: color1);
          return;
        }
      }

      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        throw e;
      });
      final docUser = FirebaseFirestore.instance.collection('users').doc(email);
      Random random = Random();
      String alphabet = 'abcdefghijklmnopqrstuvwxyz';
      String referralCode = '';
      String deliBuddyCoupon = '';
      for (int i = 0; i < 6; i++) {
        int index1 = random.nextInt(26);
        referralCode += alphabet[index1];
        int index2 = random.nextInt(26);
        deliBuddyCoupon += alphabet[index2];
      }
      referralList.add(deliBuddyCoupon.toUpperCase()); //Delibuddy's coupon to every new user

      final emailData = {
        'email': email,
        'name': name,
        'referralCode': referralCode.toUpperCase(),// X gets a referral code, that he can give to others to redeem
        'referralList': referralList,
        'referralCount': 0
      };
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

      name = snapshot.data()!['name'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setBool('isLoggedIn', true);
      Fluttertoast.showToast(msg: "Login Successful", backgroundColor: color1);

      final DocumentSnapshot<Map<String, dynamic>> deliverySnapshot =
          await FirebaseFirestore.instance
              .collection('delivery')
              .doc('delivery')
              .get();

      List<String> deliveryEmail =
          List<String>.from(deliverySnapshot.data()!['email']);

      if (deliveryEmail.contains(email)) {
        prefs.setString('type', "delivery");
        Navigator.pushNamedAndRemoveUntil(
            context, OrderRequest.routeName, (route) => false);
      } else {
        prefs.setString('type', "client");
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
      }
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
