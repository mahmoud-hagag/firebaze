import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaze/components/custom_button.dart';
import 'package:firebaze/components/text_field.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        DocumentReference response = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/homepage", (route) => false);
      } catch (e) {
        // ignore: avoid_print
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add category"),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: CustomTextField(
                  controller: name,
                  label: "label",
                  icon: Icons.category,
                  validator: (val) {
                    if (val == "") {
                      return "Can't to be empty";
                    } else {
                      return null;
                    }
                  }),
            ),
            CustomButton(
                text: "Add",
                onTab: () {
                  addCategory();
                },
                color1: Colors.orange,
                color2: const Color.fromARGB(255, 30, 27, 23))
          ],
        ),
      ),
    );
  }
}
