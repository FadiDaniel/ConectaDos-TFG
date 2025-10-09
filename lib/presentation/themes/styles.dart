import 'package:flutter/material.dart';

class TStyles {
  static TextStyle appBarTitle =
      TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle subtitle =
      TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle normalBlack = TextStyle(color: Colors.black, fontSize: 18);
  static TextStyle red = TextStyle(color: Colors.red, fontSize: 18);
  static TextStyle boldBlack =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle boldWhite =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle label = TextStyle(fontSize: 16, color: CStyles.primaryColor);
  static TextStyle smallBlack = TextStyle(fontSize: 14, color: Colors.black);
  //TextStyles
  static TextStyle errorText(bool comprobador) {
    return TextStyle(
      color: comprobador ? Colors.black : Colors.red,
      fontSize: 18,
    );
  }

  static TextStyle selectedText(bool comprobador) {
    return TextStyle(
      fontWeight: comprobador ? FontWeight.bold : FontWeight.normal,
      color: comprobador ? Colors.white : Colors.grey.shade300,
      fontSize: 18,
    );
  }
}

class CStyles {
  static Color primaryColor = Color.fromARGB(252, 0, 55, 118);
  static Color backgroundPC = Color.fromARGB(251, 152, 180, 212);
  static Color softPC = Color.fromARGB(250, 184, 202, 222);
  static Color backgroundGrey = Color.fromARGB(248, 251, 251, 251);
}

class WStyles {
  static InputDecoration textInputCheck(bool comprobador, String label) {
    return InputDecoration(
      label: Text(
        label,
        style: TextStyle(color: comprobador ? Colors.black : Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              width: 2,
              color: comprobador ? CStyles.primaryColor : Colors.red.shade200)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: comprobador ? Colors.black54 : Colors.red.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  static InputDecoration textInputBig(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: TStyles.label,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: CStyles.primaryColor)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  static InputDecoration textInput(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: TStyles.label,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: CStyles.primaryColor)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  //Elevated Buttons
  static final elevatedButtonPC = ElevatedButton.styleFrom(
      fixedSize: Size(double.infinity, 50),
      backgroundColor: CStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  static final softEB = ElevatedButton.styleFrom(
      elevation: 1,
      fixedSize: Size(double.infinity, double.infinity),
      backgroundColor: CStyles.backgroundPC,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  static final whiteEB = ElevatedButton.styleFrom(
      elevation: 1,
      fixedSize: Size(double.infinity, double.infinity),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  static final deleteEB = ElevatedButton.styleFrom(
      elevation: 1,
      fixedSize: Size(double.infinity, double.infinity),
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  static ButtonStyle elevatedButtonED(bool check) {
    return ElevatedButton.styleFrom(
        fixedSize: Size(double.infinity, 50),
        backgroundColor: check ? CStyles.primaryColor : Colors.grey.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  static final addEB = ElevatedButton.styleFrom(
      fixedSize: Size(double.infinity, 30),
      backgroundColor: CStyles.backgroundPC,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  static final removeEB = ElevatedButton.styleFrom(
      fixedSize: Size(double.infinity, 30),
      backgroundColor: Colors.red.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  //Checkbox
  static BorderSide checkboxSide = BorderSide(width: 1, color: Colors.black54);
  static OutlinedBorder checkboxShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
}

class AppBarThemes {
  static AppBarTheme principal = AppBarTheme(
      shadowColor: Colors.black,
      elevation: 3,
      scrolledUnderElevation: 3,
      toolbarHeight: 90,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TStyles.appBarTitle);
}
