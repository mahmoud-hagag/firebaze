import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaze/categories/edit.dart';
import 'package:firebaze/notes/note_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = false;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("/addcategory");
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home'),
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
      body: !isLoading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 170),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                NoteView(categoryId: data[i].id)));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'editing',
                          desc: 'what you do for " ${data[i]['name']} "...',
                          btnCancelText: "delete",
                          btnOkText: 'edit',
                          btnCancelOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(data[i].id)
                                .delete();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context)
                                .pushReplacementNamed('/homepage');
                          },
                          btnOkOnPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCategory(
                                  docId: data[i].id, oldName: data[i]['name']),
                            ));
                          },
                        ).show();
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              height: 130,
                              child: Image.asset("assets/images.png"),
                            ),
                            Text("${data[i]['name']}"),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
