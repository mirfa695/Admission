import 'package:admission/screens/home_page.dart';
import 'package:admission/screens/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Main());
}
class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main>{
  bool isLoggedIn = false;
  // var auth=FirebaseAuth.instance;
  // var isLogin=false;
  // checkIfLogin()async{
  //   auth.authStateChanges().listen((User? user) {
  //     if(user!=null&&mounted){
  //       setState(() {
  //         isLogin=true;
  //       });
  //     }
  //   });
  // }

   @override

  void initState() {
    // TODO: implement initState
    checkIfLogin();
    super.initState();

  }
   Future<void> checkIfLogin() async {
     final prefs = await SharedPreferences.getInstance();
     final bool isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;

     setState(() {
       isLoggedIn = isUserLoggedIn;
     });
   }
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner:false,
        home: SplashScreen(isLogggedIn: isLoggedIn,),);
  }
}
