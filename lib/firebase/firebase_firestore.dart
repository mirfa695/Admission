import 'package:admission/model_class/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> firestoreData(StudentModel model) async {
    try {
      await firestore.collection('Students').add(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StudentModel>> getData() async {
    try {
     QuerySnapshot<Map<String,dynamic>>snapshot=await firestore.collection('Students').get();
     return snapshot.docs.map((e) => StudentModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // {required String name,
  //     required String email,
  //     required int phno,
  //     required String dob,
  //     required String blood,
  // required BuildContext context}
  //     )

  // async {
  //   try{
  //   await firestore.collection('Students')
  //       .add({
  //     "name":name,
  //     "email":email,
  //     "phno":phno,
  //     "dob":dob,
  //     "blood":blood});}
  //       catch(e){
  //      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
  //       }
  // }
//   Future<QuerySnapshot>getStudentData()async{
//     try{
//
//     QuerySnapshot studentList= await firestore.collection('Students').get();
// return studentList;
//     }catch(e){
//
//       rethrow;
//
//     }
//   }
  Future<void> deleteData(String documentId) async {
    try {
      await firestore.collection('Students').doc(documentId).delete();
    } catch (e) {
      print('error');
    }
  }

  Future<void> updateData(StudentModel model) async {
    try {
      await firestore
          .collection('Students')
          .doc(model.id)
          .update(model.toJson());
    } catch (e) {
      print('error');
    }
  }
}
