import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/feature/authentication/repository/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/helpers/hive_helper.dart';
import '../../home/main_screen.dart';
import '../model/user_model.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> _saveUserLocally(String id, UserModel user) async {
    HiveHelper.setId(id);
    HiveHelper.setUser(user);
  }

  Future<String?> _addUserCloud({required UserModel user}) async {
    try {
      await _fireStore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .set({
        'name': user.name,
        'email': user.email,
        "image": user.image,
        "favorite": [],
        "garden": [],
      });
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  @override
  Future<Either<String,Failure>> authenticateWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
        clientId: Platform.isIOS ? 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com' : null,
        serverClientId: '77229799225-fvl3m117bv8qnq58qal2n3tsptetqsqg.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return const Right(ServerFailure('Sign-in cancelled by user'));
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        return const Right(ServerFailure('No ID token received from Google'));
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return const Right(ServerFailure('authentication failed'));
      }

      if (!userCredential.additionalUserInfo!.isNewUser) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          return const Right(ServerFailure('User document not found'));
        }

        final userData = doc.data();
        if (userData == null) {
          return const Right(ServerFailure('User data is null'));
        }

        final userModel = UserModel.fromJson(userData);
        await _saveUserLocally(user.uid, userModel);

        final garden = userData["garden"] as List<dynamic>?;
        if (garden != null && garden.isNotEmpty) {
           _getNotificationData(garden);
        }
      } else {
        final newUser = UserModel(
          email: googleUser.email,
          name: googleUser.displayName ?? 'User',
          image: googleUser.photoUrl,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());

        await _saveUserLocally(user.uid, newUser);
      }

      Get.offAll(() => const MainScreen());
      return Left(user.displayName??"");
    } catch (e) {
      return Right(ServerFailure('Authentication error: ${e.toString()}'));
    }
  }


  @override
  Future<Failure?> logInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final response =
          (await _fireStore.collection('users').doc(credential.user?.uid).get())
              .data();
      UserModel user = UserModel.fromJson(response!);
      await _saveUserLocally(credential.user!.uid, user);
      List<dynamic> garden = response["garden"];
      if (garden.isNotEmpty) {
        _getNotificationData(garden);
      }
    } catch (e) {
      return ServerFailure(e.toString());
    }
    return null;
  }

  void _getNotificationData(List<dynamic> garden) async {
    for (int id in garden) {
      final response =
          (await _fireStore.collection('plant').doc(id.toString()).get())
              .data()?["notification"];
      HiveHelper.addNotificationData(response);
    }
  }

  @override
  Future<Failure?> signUpWithEmailAndPassword(
      {required String password, required UserModel user, File? image}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
      if (image != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await Supabase.instance.client.storage
          .from('greener')
          .upload(fileName, image);
      user.image = Supabase.instance.client.storage
          .from('greener')
          .getPublicUrl(fileName);
      }
      await _fireStore.collection('users').doc(userCredential.user?.uid).set(user.toJson());
      await _addUserCloud(user: user);
      await _saveUserLocally(userCredential.user!.uid,
          user);
    } catch (e) {
      return ServerFailure(e.toString());
    }
    return null;
  }
}
