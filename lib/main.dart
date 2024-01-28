import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/parker/parker_screen.dart';
import 'package:smart_parker/main/users/user_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //For Setup Firebase
  await Firebase.initializeApp();

  SessionResponse session = await Middleware().checkSession();

  //For Push Notification
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // NotificationController.initialize();

  runApp(SmartParker(
    session: session,
  ));
}

class SmartParker extends StatelessWidget {
  const SmartParker({super.key, required this.session});
  final SessionResponse session;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartParker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: const Color(0xff2D4356),
        // primarySwatch: GetTheme().themeColor
      ),
      home: session.isLog == true
          ? session.asUser == false
              ? const ParkerScreen()
              : const UserScreen()
          : const UserScreen(),
    );
  }
}
