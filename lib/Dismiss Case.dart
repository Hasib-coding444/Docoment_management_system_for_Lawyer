import 'package:flutter/material.dart';

class DismissCase extends StatelessWidget{
  const DismissCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Cases",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
    );
  }

}