import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaze/components/custom_button.dart';
import 'package:firebaze/components/text_field.dart';
import 'package:firebaze/notes/note_view.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String collectionId;

  const AddNote({Key? key, required this.collectionId}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  bool isLoading = false;
  addNote() async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.collectionId)
        .collection("note");

    if (formState.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        // ignore: unused_local_variable
        DocumentReference response = await categories.add({
          "note": note.text,
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(
                  categoryId: widget.collectionId,
                )));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // ignore: avoid_print
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add note"),
      ),
      body:isLoading ? const Center(child: CircularProgressIndicator()) : Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: CustomTextField(
                  controller: note,
                  label: "label",
                  icon: Icons.note_add,
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
                  addNote();
                },
                color1: Colors.orange,
                color2: const Color.fromARGB(255, 30, 27, 23))
          ],
        ),
      ),
    );
  }
}
