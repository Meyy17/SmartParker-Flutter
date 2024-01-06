import 'package:flutter/material.dart';
import 'package:smart_parker/widget/appbar_widget.dart';

class BillUserScreen extends StatefulWidget {
  const BillUserScreen({Key? key}) : super(key: key);

  @override
  State<BillUserScreen> createState() => _BillUserScreenState();
}

class _BillUserScreenState extends State<BillUserScreen> {
  bool isLoggediIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Tagihan pengguna"),
    );
  }
}
