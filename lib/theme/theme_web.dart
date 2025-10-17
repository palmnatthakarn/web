import 'package:flutter/material.dart';

//const kPrimaryColor = Color(0xFF2261E4);
//const kPrimaryLightColor =  Color(0xFFF6F8FB);

//const requiredField = "This field is required";

class Theme_Web {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF2261E4),
      scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2261E4),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        elevation: 4,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF2261E4)),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFF4C7FFF),
      ),
    );
  }
}

LinearGradient dashboard_gradient_1 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color.fromARGB(255, 252, 222, 65), // เหลือง
    const Color.fromARGB(255, 246, 166, 13), // ส้ม
  ],
);

LinearGradient dashboard_gradient_2 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color.fromARGB(255, 58, 128, 245), // เหลือง
    const Color.fromARGB(255, 38, 100, 235), // ส้ม
  ],
);
LinearGradient dashboard_gradient_3 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color.fromARGB(255, 16, 185, 129), // เหลือง
    const Color.fromARGB(255, 47, 234, 172), // ส้ม
  ],
);

LinearGradient dashboard_gradient_4 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color.fromARGB(255, 102, 99, 241), // เหลือง
    const Color.fromARGB(255, 146, 52, 234), // ส้ม
  ],
);

LinearGradient pin_gradient_1 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.teal, // เหลือง
    Color.fromARGB(255, 3, 233, 210),
  ],
);
LinearGradient pin_gradient_2 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.orange,
    Color.fromARGB(255, 247, 164, 39),
// ส้ม
  ],
);

LinearGradient pin_gradient_3 = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromARGB(255, 1, 130, 147),
     Colors.cyan,

 // ส้ม
  ],
);
