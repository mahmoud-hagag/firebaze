import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaze/components/custom_button.dart';
import 'package:firebaze/components/text_field.dart';
import 'package:firebaze/notes/note_view.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String categoryId;
  final String collectionId;
  final String oldName;

  const EditNote(
      {Key? key,
      required this.categoryId,
      required this.collectionId,
      required this.oldName})
      :super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  @override
  void initState() {
    note.text = widget.oldName;
    super.initState();
  }

  bool isLoading = false;
  editNote() async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("note");

    if (formState.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        // ignore: unused_local_variable
        await categories.doc(widget.collectionId).update({
          "note": note.text,
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(
                  categoryId: widget.categoryId,
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
        title: const Text("edit note"),
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
                text: "save",
                onTab: () {
                  editNote();
                },
                color1: Colors.orange,
                color2: const Color.fromARGB(255, 30, 27, 23))
          ],
        ),
      ),
    );
  }
}
