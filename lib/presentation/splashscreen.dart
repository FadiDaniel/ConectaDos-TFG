import 'package:conectados/common/singleton.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/screens/signup_login/signUpType.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
      () {
        if (mounted) {
          if (SG.auth.currentUser != null) {
            if (SG.auth.currentUser!.emailVerified) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    if (SG.student != null) {
                      return HomepageStudent();
                    }
                    if (SG.tutor != null) {
                      return HomepageTutor();
                    }
                    if (SG.company != null) {
                      return HomePageCompany();
                    }
                    return Signuptype();
                  },
                ),
              );
            }
          } else {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return Login();
            }));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).width * 0.7,
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        bottomNavigationBar:
            SafeArea(child: Image.asset("assets/images/banner.jpg")),
      ),
    );
  }
}
