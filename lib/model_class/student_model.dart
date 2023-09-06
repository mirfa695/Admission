import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  StudentModel({
    required this.dob,
    required this.name,
    required this.id,
    required this.blood,
    required this.phno,
    required this.email,
  });
  late final String dob;
  late final String name;
  late final String id;
  late final String blood;
  late final int phno;
  late final String email;

  StudentModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>>  doc){
    dob = doc.data()['dob'];
    name = doc.data()['name'];
    id = doc.data()['id'];
    blood = doc.data()['blood'];
    phno = doc.data()['phno'];
    email = doc.data()['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dob'] = dob;
    _data['name'] = name;
    _data['id'] = id;
    _data['blood'] = blood;
    _data['phno'] = phno;
    _data['email'] = email;
    return _data;
  }
}