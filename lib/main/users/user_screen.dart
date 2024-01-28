import 'package:flutter/material.dart';
import 'package:smart_parker/main/users/profile/profile_screen.dart';
import 'package:smart_parker/main/users/bill/bill_screen.dart';
import 'package:smart_parker/main/users/favorite/favorite_screen.dart';
import 'package:smart_parker/main/users/home/home_screen.dart';
import 'package:smart_parker/main/users/order/order_screen.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int screenindex = 0;
  final screen = [
    const HomeScreenUsers(),
    const BillUserScreen(
      initialIndex: 0,
    ),
    const OrderUserScreen(
      initialIndex: 0,
    ),
    const FavoriteScreenUser(),
    const ProfileUserScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const RequestScreen(),
      //         ));
      //   },
      //   child: Container(
      //     padding: const EdgeInsets.all(15),
      //     decoration: BoxDecoration(
      //         color: GetTheme().primaryColor(context),
      //         borderRadius: BorderRadius.circular(10)),
      //     child: const Icon(
      //       Icons.local_parking,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: screen[screenindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: GetTheme().backgroundGrey(context),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "Beranda",
              backgroundColor: GetTheme().backgroundGrey(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.receipt),
              label: "Tagihan",
              backgroundColor: GetTheme().backgroundGrey(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: "Order",
              backgroundColor: GetTheme().backgroundGrey(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.save_rounded),
              label: "Saved",
              backgroundColor: GetTheme().backgroundGrey(context)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: "Profile",
              backgroundColor: GetTheme().backgroundGrey(context)),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: GetTheme().fontColor(context),
        elevation: 0,
        showUnselectedLabels: true,
        unselectedLabelStyle: fontStyleParagraftBoldDefaultColor(context),
        selectedLabelStyle: fontStyleParagraftBoldDefaultColor(context),
        currentIndex: screenindex,
        onTap: (value) {
          setState(() {
            screenindex = value;
          });
        },
      ),
    );
  }
}
