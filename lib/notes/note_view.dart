import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaze/notes/note_add.dart';
import 'package:firebaze/notes/note_edit.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final String categoryId;
  const NoteView({super.key, required this.categoryId});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = false;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    isLoading = true;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddNote(collectionId: widget.categoryId);
          }));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: WillPopScope(
          child: !isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 170),
                      itemBuilder: (context, i) {
                        return InkWell(
                          onLongPress: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: 'editing',
                              desc: 'what you do for " ${data[i]['note']} "...',
                              btnCancelText: "delete",
                              btnOkText: 'edit',
                              btnCancelOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection("categories")
                                    .doc(widget.categoryId)
                                    .collection("note")
                                    .doc(data[i].id)
                                    .delete();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteView(
                                      categoryId: widget.categoryId,
                                    ),
                                  ),
                                );
                              },
                              btnOkOnPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditNote(
                                      categoryId: widget.categoryId,
                                      collectionId: data[i].id,
                                      oldName: data[i]['note']),
                                ));
                              },
                            ).show();
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                ),
                                Text("${data[i]['note']}"),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/homepage', (route) => false);
            return Future.value(false);
          }),
    );
  }
}
