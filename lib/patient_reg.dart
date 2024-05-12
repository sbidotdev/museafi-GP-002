import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientReg extends StatefulWidget {
  const PatientReg({super.key});

  @override
  State<PatientReg> createState() => _PatientRegState();
}

class _PatientRegState extends State<PatientReg> {
  final name = TextEditingController();
  final age = TextEditingController();
  final country = TextEditingController();
  final dist = TextEditingController();
  final blood = TextEditingController();
  final phone = TextEditingController();
  final phonebro = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser() {
    return users
        .add({
          "BloodPressure": {
            "DOWN": 90,
            "UP": 120,
          },
          "BloodSugar": 120,
          "Notification": false,
          "Oxygen": 99,
          "SOS_Status": false,
          "Steps": 0,
          "Weight": 70,
          "age": age.text,
          "Bloodtype": blood.text,
          "country": country.text,
          "heartRPM": 96,
          "image": "",
          "name": name.text,
          "password": password.text,
          "phone": phone.text,
          "phonebro": phonebro.text,
          "email": email.text,
          "dist": dist.text,
        })
        .then((value) => print("USER ADDED !"))
        .catchError((error) => print("Faild to add User: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  child: Text(
                    "تسجيل مريض جديد",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: name,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'إسم المريض',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: age,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'عمر المريض',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: country,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'البلد',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: dist,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'الحي',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: blood,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'فصيلة الدم',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: phone,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'رقم الهاتف / الجوال',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: phonebro,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'رقم احد الاقارب (اخ، اخت، صديق..)',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: email,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'البريد الإلكتروني',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: password,
                      textDirection: TextDirection.rtl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'كلمة المرور',
                        border: InputBorder.none,
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    //check all fields
                    if (name.text == "" ||
                        age.text == "" ||
                        country.text == "" ||
                        blood.text == "" ||
                        phone.text == "" ||
                        email.text == "" ||
                        password.text == "") {
                      Fluttertoast.showToast(
                        msg: "الرجاء عدم ترك الحقول فارغة !",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } else {
                      if (phone.text.length < 10) {
                        Fluttertoast.showToast(
                          msg: "رقم الهاتف يجب ان يحتوي على ١٠ ارقام",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else {
                        // create user in auth process
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );

                        //register user in firestore
                        addUser();

                        //back to home
                        Fluttertoast.showToast(
                          msg: "تم تسجيل مريض جديد بنجاح !",
                          toastLength: Toast.LENGTH_SHORT,
                        );

                        //back to home page
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    "التسجيل",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 16,
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
    );
  }
}
