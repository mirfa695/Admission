import 'package:admission/custom_widget/CustomTextField.dart';
import 'package:admission/screens/home_page.dart';
import 'package:admission/utilities/const_text.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_servises.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailTextEditingController = TextEditingController();

  final passwordTextEditorController = TextEditingController();

  final confirmPasswordTextEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/img.png'), fit: BoxFit.cover)),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Image(image: AssetImage('assets/images/img3.png')),
              const SizedBox(
                height: 20,
              ),
              Text(
                'SIGN UP',
                style: CText.tstyle,
              ),
              const SizedBox(
                height: 40,
              ),
              CustomTextField(
                text: 'email',
                con: emailTextEditingController,
                val: (val) {
                  if (val == null ||
                      !val.contains('@') ||
                      !val.endsWith('.com')) {
                    return 'please enter valid email';
                  }
                  return null;
                },
                choice: false, no: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                text: 'password',
                con: passwordTextEditorController,
                val: (value) {
                  if (value == null || value!.length < 8) {
                    return 'Password must be greater than 8';
                  }
                  return null;
                },
                choice: true, no: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                text: 'confirm password',
                con: passwordTextEditorController,
                val: (value2) {
                  if (value2 != passwordTextEditorController.text) {
                    return 'password must be same';
                  }
                  return null;
                },
                choice: true, no: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (formKey.currentState!.validate()) {
                        final auth = await FirebaseService()
                            .registerWithEmailAndPassword(
                                emailTextEditingController.text,
                                passwordTextEditorController.text);
                        if (auth != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        print('Registration failed');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        shadowColor: Colors.grey,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: isLoading
                        ? Transform.scale(
                            scale: .5,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: .5,
                            ))
                        : const Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
