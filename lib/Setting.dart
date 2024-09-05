
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class S extends StatelessWidget{
  const S({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(padding: EdgeInsets.all(18),
      child:Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextButton(onPressed: (){},child: const Text("1.Update user details"),),
        SizedBox(height: 10,),
        TextButton(onPressed: (){},child: const Text("2.Manage contacts"),),
        SizedBox(height: 10,),
        TextButton(onPressed: (){},child: const Text("3.Rate us"),),
        SizedBox(height: 10,),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        },child: const Text("3.Logout"),),
        SizedBox(height: 10,),
      ],
      )
      )

    );
  }

}