import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaze/components/logo.dart';
import 'package:firebaze/components/text_field.dart';
import 'package:firebaze/components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    // ignore: use_build_context_synchronously
    AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success 👀',
        desc: 'you are login successfuly now',
        autoDismiss: false,
        onDismissCallback: (type) {},
        btnOk: Center(
          child: TextButton(
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 38, 173, 42))),
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/homepage', (route) => false);
            },
          ),
        )).show();

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                        height: 20,
                      ),
                      const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Login To Continue Using The App',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: email,
                        label: 'Enter your Email address',
                        icon: Icons.email_rounded,
                        keyType: TextInputType.emailAddress,
                        validator: (p0) {
                          if (p0 == "") {
                            return "can't to be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: password,
                        obscureText: true,
                        label: 'Enter your password',
                        icon: CupertinoIcons.eye_slash_fill,
                        keyType: TextInputType.visiblePassword,
                        validator: (p0) {
                          if (p0 == "") {
                            return "can't to be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: const ButtonStyle(),
                            onPressed: () async {
                              if (email.text == '') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  title: 'Email not right 👀',
                                  desc:
                                      '\nplease make sure the field of email is right !!!',
                                ).show();
                                return;
                              }
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success 👀',
                                    desc:
                                        'Check your inbox for a link to reset your password. If it doesnnot appear within a few minutes, check your spam folder.',
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
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )).show();
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error 👀',
                                  desc: e.message,
                                ).show();
                              }
                            },
                            child: RichText(
                              textAlign: TextAlign.end,
                              text: const TextSpan(
                                text: "Forgot password? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 2.5,
                            ),
                          ),
                          Text(
                            '      Or with      ',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 16),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 2.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Login',
                          color1: const Color.fromARGB(255, 142, 61, 248),
                          color2: const Color.fromARGB(255, 65, 15, 116),
                          onTab: () async {
                            setState(() {});
                            if (formState.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text);
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
                                                  '/homepage',
                                                  (route) => false);
                                        },
                                      ),
                                    )).show();
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (e.code.toString() == 'user-not-found') {
                                  // ignore: use_build_context_synchronously
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Email 👀',
                                    desc: 'No user found for that email.',
                                  ).show();
                                } else if (e.code == 'wrong-password') {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // ignore: use_build_context_synchronously
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Password ☠️',
                                    desc:
                                        'Wrong password provided for that user.',
                                  ).show();
                                }
                              }
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                autoHide: const Duration(seconds: 4),
                                title: 'Oops! ☠️☠️',
                                desc:
                                    'Please make sure all fields are filled out correctly.',
                              ).show();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          color1: const Color.fromARGB(255, 211, 13, 221),
                          color2: const Color.fromARGB(255, 72, 3, 16),
                          text: 'Login with google 👀❤️‍',
                          onTab: () {
                            signInWithGoogle();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                        highlightColor: Colors.white,
                        child: const Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Don't have an account?  "),
                                TextSpan(
                                  text: 'Sign Up',
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
