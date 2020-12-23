import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weighit/models/user_info.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create UserInfo object based on FirebaseUser
  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    // the func above is same as .map((User user) => _userFromFirebaseUser(user))
  }

  // sign in anonymously (this service is not applied currently)
  Future signInAnonymous() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      var user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with google account
  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;
      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      var userCredential = await _auth.signInWithCredential(credential);
      var user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String generateNonce([int length = 32]){
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce
    );
    final oauthCredential = OAuthProvider("apple,com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  // sign in with email & password
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var user = userCredential.user;

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailandPassword(String email, String password) async {
    try {
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var user = userCredential.user;

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.code;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
