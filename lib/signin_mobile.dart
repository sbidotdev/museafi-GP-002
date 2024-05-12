import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musefi/home_mobile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musefi/patient_reg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin_mobile extends StatefulWidget {
  const Signin_mobile({super.key});

  @override
  State<Signin_mobile> createState() => _Signin_mobileState();
}

class _Signin_mobileState extends State<Signin_mobile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Username = TextEditingController();
  final Password = TextEditingController();

  Future<void> _saveInfo() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("email", Username.text);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return snapshot.hasData == false
            ? Scaffold(
                body: Container(
                  height: MediaQuery.sizeOf(context).height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red.shade300,
                        Colors.redAccent,
                      ],
                    ),
                  ),
                  child: ListView(
                    children: [
                      Container(
                        height: 60,
                        width: 100,
                        margin:
                            const EdgeInsets.only(top: 80, left: 80, right: 80),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "تطبيق مسعفي",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 80),
                        alignment: Alignment.center,
                        child: Text(
                          "تسجيل دخول المريض",
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text(
                          "الرجاء قم بإدخال اسم المستخدم وكلمة المرور لتسجيل الدخول",
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.rtl,
                              children: [
                                Container(
                                  height: 80,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      controller: Username,
                                      validator: (value) => EmailValidator
                                              .validate(value!)
                                          ? null
                                          : "الرجاء التحقق من البريد الإلكتروني",
                                      textDirection: TextDirection.rtl,
                                      decoration: InputDecoration(
                                        hintText: 'البريد الإلكتروني',
                                        border: InputBorder.none,
                                        hintTextDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      controller: Password,
                                      textDirection: TextDirection.rtl,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'كلمة مرور',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      if (Username.text == "" ||
                                          Password.text == "") {
                                        Fluttertoast.showToast(
                                          msg: "الرجاء عدم ترك الحقول فارغة !",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                      } else {
                                        //Signin User
                                        final credential = await FirebaseAuth
                                            .instance
                                            .signInWithEmailAndPassword(
                                          email: Username.text,
                                          password: Password.text,
                                        );

                                        //Shared preferance reg
                                        _saveInfo();

                                        //print info test
                                        print(credential.user?.displayName);
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        Fluttertoast.showToast(
                                          msg: "لايوجد اسم بهذا المستخدم !",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                      } else if (e.code == 'wrong-password') {
                                        Fluttertoast.showToast(
                                          msg:
                                              "خطا في اسم المستخدم او كلمة المرور !",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    "تسجيل دخول",
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PatientReg(),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 50),
                                    child: Text(
                                      "تسجيل مريض جديد",
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : HomeMobile();
      },
    );
  }
}
