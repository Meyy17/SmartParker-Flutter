import 'package:flutter/material.dart';
import 'package:smart_parker/main/users/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parker/main/users/usernav_screen.dart';
import 'package:smart_parker/theme.dart';

void main() {
  runApp(const SmartParker());
}

class SmartParker extends StatelessWidget {
  const SmartParker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartParker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: Color(0xff2D4356),
        // primarySwatch: GetTheme().themeColor
      ),
      home: const UserNav(),
    );
  }
}
