

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';


class Account extends StatefulWidget{
   const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send verification email
      await userCredential.user!.sendEmailVerification();

      // Navigate to a different screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const homepage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Registration failed")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title:const Text("Account") ,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: <Widget>[
            Container(
              padding:  const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(255, 0, 255,.2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10)
                    )
                  ]
              ),
              child: Column(
                children: [
                  Container(padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        border: Border(bottom:BorderSide(color:Colors.grey))
                    ),
                    child: TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "User name",
                          hintStyle: TextStyle(color: Colors.grey[400])

                      ),
                    ),
                  ),
                  Container(padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        border: Border(bottom:BorderSide(color:Colors.grey))
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Your email",
                          hintStyle: TextStyle(color: Colors.grey[400])
                      ),
                    ),
                  ),
                  Container(padding:const EdgeInsets.all(8.0) ,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,


                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Create your password",
                          hintStyle: TextStyle(color: Colors.grey[400])
                      ),
                    ),
                  )
                ],
              ),
            ),


            const SizedBox(height: 30,),
            Container(
              height:40 ,
              width: 1500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white

              ),
              child: MaterialButton(
                color: Colors.purple,
                onPressed: (){
                  _register();
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                      fontSize:20),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("I have an account?"),
                TextButton(onPressed: (){
                  Navigator.pop(context );
                },
                    child:const Text(
                      "Login now",
                      style: TextStyle(color: Colors.purpleAccent,fontSize: 15,),
                    )
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}