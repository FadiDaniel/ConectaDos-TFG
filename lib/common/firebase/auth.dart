import 'package:conectados/common/firebase/firestore.dart';
import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/screens/editProfile/changePassword.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<bool> logIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await SG.initializeUser();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    sendEmail();
  }

  Future<void> signOut() async {
    SG.student = null;
    SG.tutor = null;
    SG.company = null;
    SG.positionsStudent = null;
    SG.positionsStudent = null;
    await firebaseAuth.signOut();
  }

  Future<void> sendEmail() async {
    await currentUser!.sendEmailVerification();
  }

  Future<Either> changeEmail(String email) async {
    try {
      await currentUser!.verifyBeforeUpdateEmail(email);
      return Right(true);
    } on Exception catch (e) {
      if (e.toString().contains("requires-recent-login")) {
        return Left(Ss.loginAgainEmail);
      }
      return Left(Ss.unknownError);
    }
  }

  Future<Either> changePassword(String newPassword) async {
    try {
      await currentUser!.updatePassword(newPassword);
      return Right(true);
    } on Exception catch (e) {
      if (e.toString().contains("requires-recent-login")) {
        return Left(Ss.loginAgainPassword);
      }
      return Left(Ss.unknownError);
    }
  }

  Future<Either> deleteAccount() async {
    try {
      await currentUser!.delete();
      return Right(true);
    } on Exception catch (e) {
      if (e.toString().contains("requires-recent-login")) {
        return Left(
            "Error. Esta operación es sensible y necesita logearse de nuevo para realizarla");
      } else {
        return Left("Error desconocido");
      }
    }
  }
}
