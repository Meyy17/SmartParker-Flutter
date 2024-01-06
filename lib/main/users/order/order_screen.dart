import 'package:flutter/material.dart';
import 'package:smart_parker/widget/appbar_widget.dart';

class OrderUserScreen extends StatefulWidget {
  const OrderUserScreen({Key? key}) : super(key: key);

  @override
  State<OrderUserScreen> createState() => _OrderUserScreenState();
}

class _OrderUserScreenState extends State<OrderUserScreen> {
  bool isLoggediIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Riwayat Order"),
    );
  }
}
