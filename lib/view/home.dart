import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
final myname=FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
          myname??"ِِِAdd name",
            style: TextStyle(fontSize: 50),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(71, 3, 42, 212)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 90, vertical: 15)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
            ),
            child: const Text(
              "Sign out",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    ));
  }
}
