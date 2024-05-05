import 'package:artwork_app/common/colors.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget{
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
            "The Bear is here!",
            style:TextStyle(
            fontSize: 20,
            color: titleColor,
          ),
          ),
          ),
        ],
      ),
    );
  }
  }