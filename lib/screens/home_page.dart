import 'package:admission/firebase/firebase_firestore.dart';
import 'package:admission/model_class/student_model.dart';
import 'package:admission/utilities/const_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_widget/CustomTextField.dart';
import 'login_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final nameTextEditingController = TextEditingController();

  final emailTextEditingController = TextEditingController();

  final phNoTextEditingController = TextEditingController();

  final dobTextEditingController = TextEditingController();
  final bloodTextEditingController = TextEditingController();
  final nameTextUpdatingController = TextEditingController();
  final emailTextUpdatingController = TextEditingController();
  final phnoTextUpdatingController = TextEditingController();
  final dobTextUpdatingController = TextEditingController();
  final bloodTextUpdatingController = TextEditingController();
  FirestoreServices fireStore = FirestoreServices();
  bool isLoading1 = false;
  final formKey = GlobalKey<FormState>();
  var auth=FirebaseAuth.instance;
  //Textfield clearing function
  void clearText() {
    nameTextEditingController.clear();
    emailTextEditingController.clear();
    phNoTextEditingController.clear();
    dobTextEditingController.clear();
    bloodTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', false);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Login(),
            ));
          }, child: const Text('Sign out')),
        ],
      ),),
      appBar: AppBar(title: Text('Student details',style: CText.tstyle,),centerTitle: true,backgroundColor: Colors.indigo[900],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //For adding entries
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('update data'),
                  content: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              val: (value) {
                                if (value == null) {
                                  return 'must enter a name';
                                }
                                return null;
                              },
                              color1: Colors.black,
                              text: 'Name',
                              con: nameTextEditingController,
                              choice: false,
                              no: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              val: (value1) {
                                if (value1 == null ||
                                    !value1.contains('@') ||
                                    !value1.endsWith('.com')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                              color1: Colors.black,
                              text: 'email',
                              con: emailTextEditingController,
                              choice: false,
                              no: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              val: (value2) {
                                if (value2 == null || value2.length < 10) {
                                  return 'Invalid phone number';
                                }
                                return null;
                              },
                              color1: Colors.black,
                              text: 'ph no',
                              con: phNoTextEditingController,
                              choice: false,
                              no: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              val: (value3) {
                                if (value3 == null || !value3.contains('/')) {
                                  return 'Invalid format(dd/mm/yyyy)';
                                }
                                return null;
                              },
                              color1: Colors.black,
                              text: 'D/O/B',
                              con: dobTextEditingController,
                              choice: false,
                              no: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              val: (value4) {
                                if (value4 == null || !value4.endsWith('ve')) {
                                  return 'Invalid value';
                                }
                                return null;
                              },
                              color1: Colors.black,
                              text: 'Blood',
                              con: bloodTextEditingController,
                              choice: false,
                              no: 5,
                            )
                          ],
                        )),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          //For adding entries to Database
                          setState(() {
                            isLoading1 = true;
                          });
                          if (formKey.currentState!.validate()) {
                            String name = nameTextEditingController.text;
                            String email = emailTextEditingController.text;
                            int phno =
                                int.parse(phNoTextEditingController.text);
                            String dob = dobTextEditingController.text;
                            String blood = bloodTextEditingController.text;
                            StudentModel data=StudentModel(dob: dob, name: name, id: '', blood: blood, phno: phno, email: email);
                            await fireStore.firestoreData(
                                data);
                            setState(() {
                              Navigator.pop(context);
                              clearText();
                              isLoading1 = false;
                            });
                          }
                        },
                        child: isLoading1
                            ? Transform.scale(
                                scale: .5,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ))
                            : const Text('Add')),
                    ElevatedButton(
                        onPressed: () {
                          //close

                          Navigator.of(context).pop();
                        },
                        child: const Text('close'))
                  ],
                );
              });
        },
        backgroundColor: Colors.blue[300],
        child: const Icon(Icons.add),
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/img4.png'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder<List<StudentModel>>(
                    //For getting data
                    future: fireStore.getData(),
                    builder: (context, data) {
                    print(data);
                      if (data.hasData) {
                        final List<StudentModel> documents =
                            data.data!;
                        print(documents);
                        return ListView.builder(itemCount: documents.length,
                            itemBuilder:(BuildContext context,int index){
                        return  Card(
                            child: ListTile(title: Text('Name:  ${documents[index].name}'),
                            subtitle: Column(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(alignment:Alignment.topLeft,
                                    child: Text('Email:  ${documents[index].email}')),
                                Align(alignment:Alignment.topLeft,
                                    child: Text('Phno:  ${documents[index].phno.toString()}',textAlign: TextAlign.left,)),
                                Align(alignment:Alignment.topLeft,
                                    child: Text('D/O/B:  ${documents[index].dob}')),
                                Align(alignment:Alignment.topLeft,
                                    child: Text('Blood:  ${documents[index].blood}'))
                              ],
                            ),
                              trailing: Wrap(children: [
                                IconButton(
                                    onPressed: () async {
                                      //Deleting data
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext
                                          context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Confirm'),
                                              content:  const Text(
                                                  'Are you sure?'),
                                              actions: [
                                                TextButton(
                                                    onPressed:
                                                        () async {
                                                      setState(
                                                              () {
                                                            isLoading1 =
                                                            true;
                                                          });
                                                      await fireStore
                                                          .deleteData(
                                                          documents[index].id);
                                                      setState(
                                                              () {
                                                            isLoading1 =
                                                            false;
                                                          });
                                                      setState(
                                                              () {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                    },
                                                    child:
                                                     const Text(
                                                        'Yes')),
                                                TextButton(
                                                    onPressed:
                                                        () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                    child:  const Text(
                                                        'Cancel'))
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      //Updating Data
                                      nameTextUpdatingController
                                          .text = documents[index].name;
                                      emailTextUpdatingController
                                          .text = documents[index].email;
                                      phnoTextUpdatingController
                                          .text =
                                          documents[index].phno.toString();
                                      dobTextUpdatingController
                                          .text =documents[index].dob;
                                      bloodTextUpdatingController
                                          .text = documents[index].blood;
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext
                                          context) {
                                            return AlertDialog(
                                              title:  const Text(
                                                  'update data'),
                                              content:
                                              SingleChildScrollView(
                                                child: Form(
                                                    child: Column(
                                                      children: [
                                                        CustomTextField(
                                                          text:
                                                          'Name',
                                                          con:
                                                          nameTextUpdatingController,
                                                          choice:
                                                          false,
                                                          no: 0,
                                                          color1: Colors
                                                              .black,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        CustomTextField(
                                                          text:
                                                          'email',
                                                          con:
                                                          emailTextUpdatingController,
                                                          choice:
                                                          false,
                                                          no: 0,
                                                          color1: Colors
                                                              .black,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        CustomTextField(
                                                          text:
                                                          'ph no',
                                                          con:
                                                          phnoTextUpdatingController,
                                                          choice:
                                                          false,
                                                          no: 0,
                                                          color1: Colors
                                                              .black,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        CustomTextField(
                                                          text:
                                                          'D/O/B',
                                                          con:
                                                          dobTextUpdatingController,
                                                          choice:
                                                          false,
                                                          no: 0,
                                                          color1: Colors
                                                              .black,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        CustomTextField(
                                                          text:
                                                          'Blood',
                                                          con:
                                                          bloodTextUpdatingController,
                                                          choice:
                                                          false,
                                                          no: 5,
                                                          color1: Colors
                                                              .black,
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed:
                                                        () async {
                                                      await fireStore.updateData(
                                                          StudentModel(dob: dobTextUpdatingController.text,
                                                              name: nameTextUpdatingController.text, id:documents[index].id, blood: bloodTextUpdatingController.text,
                                                              phno: int.parse(phnoTextUpdatingController.text), email: emailTextUpdatingController.text));
                                                      setState(
                                                              () {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                    },
                                                    child:  const Text(
                                                        'Update')),
                                                ElevatedButton(
                                                    onPressed:
                                                        () {
                                                      Navigator.of(
                                                          context)
                                                          .pop();
                                                    },
                                                    child:  const Text(
                                                        'close'))
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.update,
                                      color: Colors.black,
                                    )),
                              ]),

                            ),
                          );
                        });







                      } else if (data.hasError) {
                        return const Text("has error");
                      }

                      return const Text('error');
                    }),
              ),

              //
            ],
          )),
    );
  }
}
