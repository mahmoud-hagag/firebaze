import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: StreamBuilder(
          stream: usersStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(data[index].id);

                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documentReference);
                      if (snapshot.exists) {
                        var snapshotData = snapshot.data();
                        if (snapshotData is Map<String, dynamic>) {
                          int money = snapshotData['money'];
                          transaction.update(
                              documentReference, {'money': money + 100});
                        }
                      }
                    });
                  },
                  child: Card(
                    child: ListTile(
                      trailing: Text(
                        '\$${data[index]['money'].toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red),
                      ),
                      title: Text(
                        data[index]['username'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text("age   : ${data[index]['age']}"),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
