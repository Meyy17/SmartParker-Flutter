import 'package:flutter/material.dart';
import 'package:smart_parker/widget/appbar_widget.dart';

class KelolaParking extends StatefulWidget {
  const KelolaParking({super.key});

  @override
  State<KelolaParking> createState() => _KelolaParkingState();
}

class _KelolaParkingState extends State<KelolaParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Kelola Parkir"),
    );
  }
}
