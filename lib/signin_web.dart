import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musefi/home_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin_web extends StatefulWidget {
  const Signin_web({super.key});

  @override
  State<Signin_web> createState() => _Signin_webState();
}

class _Signin_webState extends State<Signin_web> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Username = TextEditingController();
  final Password = TextEditingController();

  Future<void> _saveInfo() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("email", Username.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //signout first from app
    // FirebaseAuth.instance.signOut();
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
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.redAccent.shade400,
                          Colors.redAccent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 150,
                            margin: const EdgeInsets.only(
                                top: 80, left: 80, right: 80),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "تطبيق مسعفي",
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 80),
                            alignment: Alignment.center,
                            child: Text(
                              "تسجيل دخول المستشفى",
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
                            child: Container(
                              margin: const EdgeInsets.only(top: 100),
                              width: 500,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
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
                                          textDirection: TextDirection.rtl,
                                          controller: Username,
                                          validator: (value) => EmailValidator
                                                  .validate(value!)
                                              ? null
                                              : "الرجاء التحقق من البريد الإلكتروني",
                                          decoration: InputDecoration(
                                            hintText: 'البريد الإلكتروني',
                                            border: InputBorder.none,
                                            hintTextDirection:
                                                TextDirection.rtl,
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
                                              msg:
                                                  "الرجاء عدم ترك الحقول فارغة !",
                                              toastLength: Toast.LENGTH_SHORT,
                                            );
                                          } else {
                                            //Signin User
                                            final credential =
                                                await FirebaseAuth.instance
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
                                              msg:
                                                  "لاتوجد مستشفى بهذا المستخدم !",
                                              toastLength: Toast.LENGTH_SHORT,
                                            );
                                          } else if (e.code ==
                                              'wrong-password') {
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : HomeWeb();
        });
  }
}
