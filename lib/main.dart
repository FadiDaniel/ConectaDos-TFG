import 'package:conectados/common/singleton.dart';
import 'package:conectados/presentation/splashscreen.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (SG.auth.currentUser != null) {
    if (SG.auth.currentUser!.emailVerified) {
      await SG.initializeUser();
    }
  }
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: CStyles.backgroundPC,
              selectionHandleColor: CStyles.backgroundPC,
              cursorColor: CStyles.primaryColor,
            ),
            fontFamily: "Arial",
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarThemes.principal),
        home: Splashscreen());
  }
}
