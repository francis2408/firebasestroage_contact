import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_login/model/contact.dart';
import 'package:firebase_login/screens/edit_contact.dart';

class ViewContact extends StatefulWidget {
  const ViewContact(id, {Key? key}) : super(key: key);

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  String? id;
  Contact? _contact;
  bool isLoading = true;

  getContact(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _contact = Contact.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getContact(id);
  }

  callAction(String number) async {
    String url = 'tel:$number';

    if (await canLaunchUrl(Uri(
      scheme: url,
    ))) {
      await launchUrl(Uri(
        scheme: url,
      ));
    } else {
      throw 'Could not call $number';
    }
  }

  smsAction(String number) async {
    String url = 'sms:$number';
    if (await canLaunchUrl(Uri(
      scheme: url,
    ))) {
      await launchUrl(Uri(
        scheme: url,
      ));
    } else {
      throw 'Could not send sms to $number';
    }
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  navigateToEditScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditContact(id);
    }));
  }

  deleteContact() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text('Delete Contact?'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _databaseReference.child(id!).remove();
                  navigateToLastScreen();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Contact"),
      ),
      body: Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  // header text container
                  SizedBox(
                    height: 200.0,
                    child: Image(
                      //
                      image: _contact!.photoUrl == "empty"
                          ? const AssetImage("assets/images/logo.png")
                              as ImageProvider
                          : NetworkImage(
                              _contact!.photoUrl,
                              scale: 1.0,
                            ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  //name
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.perm_identity),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            "${_contact!.firstName} ${_contact!.lastName}",
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // phone
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.phone),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            _contact!.phone,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // email
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.email),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            _contact!.email,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // address
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.home),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            _contact!.address,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // call and sms
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.phone),
                            color: Colors.red,
                            onPressed: () {
                              callAction(_contact!.phone);
                            },
                          ),
                          IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.message),
                            color: Colors.red,
                            onPressed: () {
                              smsAction(_contact!.phone);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // edit and delete
                  Card(
                    elevation: 2.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.edit),
                            color: Colors.red,
                            onPressed: () {
                              navigateToEditScreen(id);
                            },
                          ),
                          IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteContact();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
