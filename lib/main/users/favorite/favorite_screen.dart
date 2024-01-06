import 'package:flutter/material.dart';
import 'package:smart_parker/widget/appbar_widget.dart';

class FavoriteScreenUser extends StatefulWidget {
  const FavoriteScreenUser({Key? key}) : super(key: key);

  @override
  State<FavoriteScreenUser> createState() => _FavoriteScreenUserState();
}

class _FavoriteScreenUserState extends State<FavoriteScreenUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Parkir Favorite"),
    );
  }
}
