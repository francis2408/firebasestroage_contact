import 'package:flutter/material.dart';
// Firebase
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
// Screens
import 'package:firebase_login/screens/add_contact.dart';
import 'package:firebase_login/screens/view_contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddContact(),
      ),
    );
  }

  navigateToViewScreen(id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewContact(id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact App'),
      ),
      body: FirebaseAnimatedList(
        query: _databaseReference,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int indax) {
          return GestureDetector(
            onTap: () {
              navigateToViewScreen(snapshot.key);
            },
            child: Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: snapshot.value['photoUrl'] == "empty"
                              ? const AssetImage('assets/images/logo.png')
                                  as ImageProvider
                              : NetworkImage(
                                  snapshot.value['photoUrl'],
                                  scale: 1.0,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(
                              Icons.person,
                              color: Colors.purple,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text(
                              "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ]),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.purple,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text("${snapshot.value['phone']}"),
                          ]),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(children: [
                            const Icon(
                              Icons.email,
                              color: Colors.purple,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text("${snapshot.value['email']}"),
                          ]),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.purple,
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Text("${snapshot.value['address']}"),
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
