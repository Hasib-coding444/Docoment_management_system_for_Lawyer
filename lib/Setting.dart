import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:gap/gap.dart';

class S extends StatelessWidget {
  const S({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("1.Update user details"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("2.Manage contacts"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("3.Rate us"),
                ),
                const Gap(10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: const Text("3.Logout"),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )));
  }
}
