import 'package:admission/custom_widget/CustomTextField.dart';
import 'package:admission/screens/home_page.dart';
import 'package:admission/screens/signup_page.dart';
import 'package:admission/utilities/const_text.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_servises.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final textEditor1 = TextEditingController();

  final textEditor2 = TextEditingController();

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
              const Image(image: AssetImage('assets/images/img1.png')),
              const SizedBox(
                height: 40,
              ),
              Text(
                'LOGIN',
                style: CText.tstyle,
              ),
              const SizedBox(
                height: 40,
              ),
              CustomTextField(text: 'email', con: textEditor1,val: (value){
                if(value==null||!value.contains('@')||!value.endsWith('.com')){
                  return'Please enter a valid email';
                }
                return null;
              }, choice: false, no: 20,),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(text: 'password', con: textEditor2,val: (value){
                if(value==null||value.length<8){
                  return'password must be more than 8';
                }
                return null;

                }, choice: true, no: 20,),
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

                          final auth = await FirebaseService().signInUsingEmailPassword(
                          textEditor1.text, textEditor2.text);
                             if (auth != null) {
                               SharedPreferences spref=await SharedPreferences.getInstance();
                               spref.setBool('isLoggedIn', true);
                               Navigator.pushReplacement(
                            context,
                          MaterialPageRoute(builder: (context) => Home()),
                                      );

                              setState(() {
                                isLoading = false;
                              });
                                              }
                                            } else {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account doesn't exist")));
                 }
                        },

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        shadowColor: Colors.grey,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child:isLoading?Transform.scale(scale:.5,child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)): const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't you have an account?  ",
                    style: TextStyle(color: Colors.white.withOpacity(.7)),
                  ),
                  InkWell(onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ),
                    );
                  },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.cyanAccent),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
