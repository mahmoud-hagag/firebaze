import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaze/components/custom_button.dart';
import 'package:firebaze/components/logo.dart';
import 'package:firebaze/components/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController password1 = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            
          ):
       Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(width: double.infinity, child: Logo()),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'User Name',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  validator: (p0) {
                    if (p0 == "") {
                      return "can't to be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: username,
                  label: 'Enter your User Name',
                  icon: Icons.person_rounded,
                  keyType: TextInputType.name,
                ),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  validator: (p0) {
                    if (p0 == "") {
                      return "can't to be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: email,
                  label: 'Enter your Email address',
                  icon: Icons.email_rounded,
                  keyType: TextInputType.emailAddress,
                ),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  validator: (p0) {
                    if (p0 == "") {
                      return "can't to be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: password,
                  obscureText: true,
                  label: 'Enter your password',
                  icon: CupertinoIcons.eye_slash_fill,
                  keyType: TextInputType.visiblePassword,
                ),
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  validator: (p0) {
                    if (p0 == "") {
                      return "can't to be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: password1,
                  obscureText: true,
                  label: 'Confirm password',
                  icon: CupertinoIcons.eye_slash_fill,
                  keyType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      text: 'Sign Up',
                      color1: const Color.fromARGB(255, 35, 223, 18),
                      color2: const Color.fromARGB(255, 18, 81, 10),
                      onTab: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            // ignore: use_build_context_synchronously
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Success 👀',
                                desc: 'you are login successfuly now',
                                btnOk: Center(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 38, 173, 42))),
                                    child: const Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/homepage', (route) => false);
                                    },
                                  ),
                                )).show();
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (e.code == 'weak-password') {
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Password ☠️',
                                desc: 'The password provided is too weak.',
                              ).show();
                            } else if (e.code == 'email-already-in-use') {
                              setState(() {
                                isLoading = false;
                              });
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Email 👀',
                                desc:
                                    'The account already exists for that email.',
                              ).show();
                            }
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            autoHide: const Duration(seconds: 4),
                            title: 'Form Error!',
                            desc:
                                'Please make sure all fields are filled out correctly.\n\nUsername must be between 3 and 16 characters long.\n\nPasswords must match each other and contain at least one uppercase letter, one lowercase letter, one number, and one special characterPasswords must match each other and have at least 8 characters.\n\nBoth username and email need to be valid.',
                          ).show();
                        }
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  highlightColor: Colors.white,
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Do you have an account?  "),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
