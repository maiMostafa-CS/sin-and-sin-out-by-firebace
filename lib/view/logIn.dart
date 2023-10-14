import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task4/util/strings.dart';
import 'package:task4/view/signUp.dart';
import '../common/snackBar.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  bool _passwordVisible = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  logIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // print(credential.toString());
      showSnackBar(context, " Done...");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      } else {
        showSnackBar(context, "Error .......");
      }
    }
    setState(() {
      isLoading = false;
    });
  }
 
 @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/pic.webp",
              height: 300,
            ),
            const Text(
              UiStrings.logInNow,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              UiStrings.pleaseLogIn,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: UiStrings.email,
                  border: OutlineInputBorder(),
                )),
            const SizedBox(
              height: 20,
            ),
            TextField(
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                    hintText: UiStrings.password,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }))),
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
              onPressed: () async {
                await logIn();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(71, 3, 42, 212)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 15)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40))),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      UiStrings.logIn,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  UiStrings.doNotHaveAnAccount,
                  style: TextStyle(fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigUp()));
                    },
                    child: const Text(UiStrings.signUp))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
