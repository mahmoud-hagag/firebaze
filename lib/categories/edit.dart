import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaze/components/custom_button.dart';
import 'package:firebaze/components/text_field.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  final String oldName;
  const EditCategory({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        await categories.doc(widget.docId).update({'name': name.text});
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
  void initState() {
    name.text = widget.oldName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("edit category"),
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
                text: "save",
                onTab: () {
                  editCategory();
                },
                color1: Colors.orange,
                color2: const Color.fromARGB(255, 30, 27, 23))
          ],
        ),
      ),
    );
  }
}
