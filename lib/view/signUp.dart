import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task4/util/strings.dart';
import 'package:email_validator/email_validator.dart';
import '../common/snackBar.dart';
import 'home.dart';
import 'logIn.dart';

class SigUp extends StatefulWidget {
  const SigUp({super.key});
  @override
  State<SigUp> createState() => _SigUpState();
}

class _SigUpState extends State<SigUp> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool _passwordVisible = true;
  final  nameController  = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
 
 
 
   signUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      // ignore: unused_local_variable
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, "Error - Please try agine later");
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/pic1.jpg",
                height: 300,
              ),
              const Text(
                UiStrings.signUpNow,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                UiStrings.pleaseFillTheDetails,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: UiStrings.fullName,
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? "Enter a valid email"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: UiStrings.email)),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  validator: (value) {
                    return value!.length < 8
                        ? "Enter at least 8 characters"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: UiStrings.password,
                      suffixIcon: IconButton(
                          icon: Icon(
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
                height: 60,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await signUp();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LogIn()));                                 
                  } else {
                    showSnackBar(context, "Error");
                  }
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
                        UiStrings.signUp,
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
                    UiStrings.alreadyHaveAnAccount,
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogIn()));
                      },
                      child: const Text(UiStrings.logIn))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
