import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/calculator.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: SafeArea(
        child: CalculatorWidget(),
      ),
    );
  }
}