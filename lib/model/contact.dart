import 'package:firebase_database/firebase_database.dart';

class Contact {
  String? id;
  String firstName;
  String lastName;
  String phone;
  String email;
  String address;
  String photoUrl;

  // constructor for add
  Contact(
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.photoUrl,
  );

  //constructor for edit
  Contact.withId(
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.photoUrl,
  );

  //getters
  String get getId => id!;
  String get getFirstName => firstName;
  String get getLastName => lastName;
  String get getPhone => phone;
  String get getEmail => email;
  String get getAddress => address;
  String get getPhotoUrl => photoUrl;

  //setters
  set setFirstName(String firstName) {
    firstName = firstName;
  }

  set setLastName(String lastName) {
    lastName = lastName;
  }

  set setPhone(String phone) {
    phone = phone;
  }

  set setEmail(String email) {
    email = email;
  }

  set setAddress(String address) {
    address = address;
  }

  set setPhotoUrl(String photoUrl) {
    photoUrl = photoUrl;
  }

  static Contact fromSnapshot(DataSnapshot snap) => Contact.withId(
        snap.key,
        snap.value['firstName'],
        snap.value['lastName'],
        snap.value['phone'],
        snap.value['email'],
        snap.value['address'],
        snap.value['photoUrl'],
      );

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "email": email,
      "address": address,
      "photoUrl": photoUrl,
    };
  }
}
