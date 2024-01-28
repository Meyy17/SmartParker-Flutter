import 'package:flutter/material.dart';
import 'package:smart_parker/widget/appbar_widget.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key, required this.idEmployee});
  final int idEmployee;

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: ""),
    );
  }
}
