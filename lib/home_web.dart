import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musefi/signin_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  int _selectindex = 0;
  String _useremail = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Method to load the shared preference data
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useremail = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Hospitals")
            .where("email", isEqualTo: _useremail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    width: 250,
                    height: MediaQuery.sizeOf(context).height,
                    decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 140,
                          height: 60,
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("مسعفي"),
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(left: 10),
                                child: Image.asset("logo/logo.png"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Text(
                            snapshot.data!.docs[0]["name"],
                            style: TextStyle(fontSize: 14),
                          ),
                          margin: const EdgeInsets.only(bottom: 40),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Expanded(
                              child: ListView(
                            children: [
                              ListTile(
                                leading: _selectindex == 0
                                    ? Icon(
                                        Icons.people_sharp,
                                        color: const Color.fromRGBO(
                                            255, 82, 82, 1),
                                      )
                                    : Icon(
                                        Icons.people_sharp,
                                        color: Colors.grey,
                                      ),
                                title: _selectindex == 0
                                    ? Text(
                                        'قائمة المرضى',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      )
                                    : Text(
                                        'قائمة المرضى',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                onTap: () {
                                  setState(() {
                                    _selectindex = 0;
                                    print(_selectindex);
                                  });
                                },
                              ),
                              ListTile(
                                leading: _selectindex == 1
                                    ? Icon(Icons.warning, color: Colors.red)
                                    : Icon(Icons.warning, color: Colors.grey),
                                title: _selectindex == 1
                                    ? Text(
                                        'الحالات الطارئة',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text(
                                        'الحالات الطارئة',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                onTap: () {
                                  setState(() {
                                    _selectindex = 1;
                                    print(_selectindex);
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('تسجيل الخروج'),
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signin_web(),
                                      ));
                                },
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                  _selectindex == 0
                      ? Container(
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width - 250,
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                color: Colors.grey.shade300,
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("عدد المرضى: " +
                                        snapshot
                                            .data!.docs[0]["patients"].length
                                            .toString()),
                                    Text("التاريخ: " +
                                        DateTime.now().toString()),
                                  ],
                                ),
                              ),
                              snapshot.data?.docs[0]
                                          .data()
                                          .containsKey("patients") ==
                                      false
                                  ? Center(
                                      child: Text("لايوجد مرضى"),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: snapshot
                                            .data!.docs[0]["patients"].length,
                                        itemBuilder: (context, index) {
                                          Timestamp UserTime =
                                              snapshot.data!.docs[0]["patients"]
                                                  [index]["regdate"];

                                          return Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width -
                                                500,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                            ),
                                            child: Row(
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                Text(
                                                  "الإسم: " +
                                                      snapshot
                                                          .data!
                                                          .docs[0]["patients"]
                                                              [index]["name"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Text(" - "),
                                                ),
                                                Text(
                                                  "العمر: " +
                                                      snapshot
                                                          .data!
                                                          .docs[0]["patients"]
                                                              [index]["age"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Text(" - "),
                                                ),
                                                Text(
                                                  "البلد: " +
                                                      snapshot
                                                          .data!
                                                          .docs[0]["patients"]
                                                              [index]["country"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Text(" - "),
                                                ),
                                                Text(
                                                  "الحي: " +
                                                      snapshot
                                                          .data!
                                                          .docs[0]["patients"]
                                                              [index]["dist"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Text(" - "),
                                                ),
                                                // Text("الحالة الصحية: " +
                                                //     snapshot
                                                //         .data!
                                                //         .docs[0]["patients"]
                                                //             [index]["status"]
                                                //         .toString()),
                                                // SizedBox(
                                                //   width: 50,
                                                // ),
                                                Text(
                                                  "رقم الجوال: " +
                                                      snapshot
                                                          .data!
                                                          .docs[0]["patients"]
                                                              [index]["phone"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Text(" - "),
                                                ),
                                                Text(
                                                  "رقم جوال مقرب: " +
                                                      snapshot
                                                          .data!
                                                          .docs[0]["patients"]
                                                              [index]
                                                              ["phonebro"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Text(" - "),
                                                ),
                                                Text(
                                                  "تاريخ التسجيل: " +
                                                      UserTime.toDate()
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                snapshot.data!.docs[0]
                                                                ["patients"]
                                                            [index]["agree"] ==
                                                        true
                                                    ? InkWell(
                                                        onTap: () {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "تم حذف المريض",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                          );

                                                          //delete patient
                                                          DocumentReference
                                                              hospitalref =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Hospitals")
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[0]
                                                                      .id);
                                                          hospitalref.update({
                                                            "patients": [{}]
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () async {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "تم قبول المريض !",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                          );
                                                          //update agree
                                                          DocumentReference
                                                              hospitalref =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Hospitals")
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[0]
                                                                      .id);

                                                          DocumentSnapshot
                                                              olddatadoc =
                                                              await hospitalref
                                                                  .get();

                                                          Map<String, dynamic>
                                                              olddata =
                                                              olddatadoc.data()
                                                                  as Map<String,
                                                                      dynamic>;

                                                          List patients =
                                                              olddata[
                                                                  "patients"];

                                                          patients[index]
                                                              ["agree"] = true;

                                                          hospitalref
                                                              .set(olddata);
                                                        },
                                                        child: Container(
                                                          width: 80,
                                                          height: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "قبول",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Container(
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width - 250,
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                color: Colors.grey.shade300,
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("عدد المرضى: " +
                                        snapshot.data!.docs[0]["warning"].length
                                            .toString()),
                                    Text("التاريخ: " +
                                        DateTime.now().toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      snapshot.data!.docs[0]["warning"].length,
                                  itemBuilder: (context, index) {
                                    Timestamp UserTime = snapshot.data!.docs[0]
                                        ["warning"][index]["date"];

                                    return Container(
                                      width: MediaQuery.sizeOf(context).width -
                                          500,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.only(
                                        right: 20,
                                        left: 20,
                                      ),
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Text("الإسم: " +
                                              snapshot.data!.docs[0]["warning"]
                                                  [index]["name"]),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text("الحالة الصحية: " +
                                              snapshot.data!.docs[0]["warning"]
                                                  [index]["status"]),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text("تاريخ الإشعار: " +
                                              UserTime.toDate().toString()),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Icon(
                                            Icons.warning,
                                            color: Colors.orange,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
