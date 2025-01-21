import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDashboardPage extends StatefulWidget{
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPage();
}

class _MainDashboardPage extends State<MainDashboardPage>{
  @override
  Widget build(BuildContext context) {
      return Row(
        children: [
          Container(
            width: 100,
            color: const Color.fromRGBO(36, 46, 66, 1),
          ),
          Expanded(
              child: Container(
                  color: const Color.fromRGBO(249, 251, 252, 1),
              )
          )
        ],
      );
  }
}