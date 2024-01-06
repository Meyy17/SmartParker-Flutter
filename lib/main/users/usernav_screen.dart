import 'package:flutter/material.dart';
import 'package:smart_parker/main/users/profile/profile_screen.dart';
import 'package:smart_parker/main/users/bill/bill_screen.dart';
import 'package:smart_parker/main/users/favorite/favorite_screen.dart';
import 'package:smart_parker/main/users/home/home_screen.dart';
import 'package:smart_parker/main/users/order/order_screen.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class UserNav extends StatefulWidget {
  const UserNav({super.key});

  @override
  State<UserNav> createState() => _UserNavState();
}

class _UserNavState extends State<UserNav> {
  int screenindex = 0;
  final screen = [
    const HomeScreenUsers(),
    const BillUserScreen(),
    const OrderUserScreen(),
    const FavoriteScreenUser(),
    const ProfileUserScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[screenindex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Tagihan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp), label: "Order"),
          BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart_rounded), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        backgroundColor: GetTheme().cardColorGrey(context),
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
