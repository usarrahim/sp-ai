import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sp_ai/home_screen.dart';
import 'package:sp_ai/auth/register_or_login_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trylogin();
  }

  _trylogin() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User? user = await firebaseAuth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterOrLoginScreen(),
            ));
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Oturum açılamadı"),
          );
        },
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterOrLoginScreen(),
          ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0XFF86D9F7),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.1,
          height: MediaQuery.sizeOf(context).height * 0.1,
          child: CircularProgressIndicator(
            color: Color(0xFFF2CC6E),
          ),
        ),
      ),
    );
  }
}
