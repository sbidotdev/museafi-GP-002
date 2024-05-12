import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musefi/signin_mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeState();
}

class _HomeState extends State<HomeMobile> {
  int _selectedIndex = 0; //New
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
            .collection("Users")
            .where("email", isEqualTo: _useremail)
            .snapshots(),
        builder: (context, usersnapshot) {
          if (usersnapshot.hasData) {
            //vars
            var rateheart = usersnapshot.data!.docs[0]["heartRPM"]; // 80 - 120
            var bloodpurusreup =
                usersnapshot.data!.docs[0]["BloodPressure"]["UP"]; //110 - 130
            var bloodpurusredown =
                usersnapshot.data!.docs[0]["BloodPressure"]["DOWN"]; // 90 - 100
            var sugerblood =
                usersnapshot.data!.docs[0]["BloodSugar"]; // 90 - 140
            var oxygen = usersnapshot.data!.docs[0]["Oxygen"]; // 85 - 99
            var weight = usersnapshot.data!.docs[0]["Weight"];
            var steps = usersnapshot.data!.docs[0]["Steps"];
            var SOS = usersnapshot.data!.docs[0]["SOS_Status"];
            var name = usersnapshot.data!.docs[0]["name"];

            //sum of 4 factors (Heart Rate + Blood Purusre UP + DOWN + Suger Blood + Oxygen)
            // NORMAL IS 525 RATE 99%
            var Total = rateheart +
                bloodpurusreup +
                bloodpurusredown +
                sugerblood +
                oxygen;

            print(Total);

            //ACTIVE SOS in case less than  total
            if (Total <= 380) {
              DocumentReference useref = FirebaseFirestore.instance
                  .collection("Users")
                  .doc(usersnapshot.data!.docs[0].id);
              useref.update({"SOS_Status": true});
            }

            //build
            return Scaffold(
              body: Builder(
                builder: (context) {
                  if (_selectedIndex == 0) {
                    return SafeArea(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 40,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SOS == true
                                    ? InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Container(
                                                  height: 100,
                                                  width: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.warning,
                                                        size: 32,
                                                        color: Colors.red,
                                                      ),
                                                      Text(
                                                        "تحذير التوجه لإحدى مستشفيات !!",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Icon(
                                        Icons.notifications,
                                        color: Colors.grey,
                                      ),
                                Container(
                                  height: 70,
                                  width: 230,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        textDirection: TextDirection.rtl,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: GoogleFonts.cairo(
                                              textStyle:
                                                  TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            usersnapshot
                                                .data!.docs[0]["country"]
                                                .toString(),
                                            style: GoogleFonts.cairo(
                                              textStyle:
                                                  TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        margin: const EdgeInsets.only(left: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.user,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // حالة جيدة
                          Total >= 450
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 100,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.green.shade300,
                                          Colors.green,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text(
                                          "حالة المريض",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          (Total / 525 * 100)
                                                  .toStringAsFixed(0) +
                                              "%",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.monitor_heart_outlined,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "جيدة",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          // حالة متوسطة
                          Total <= 449 && Total >= 381
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 100,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.orange.shade300,
                                          Colors.orange,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text(
                                          "حالة المريض",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          (Total / 525 * 100)
                                                  .toStringAsFixed(0) +
                                              "%",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.monitor_heart_outlined,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "متوسطة",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          // حالة سيئة
                          Total <= 380 && Total >= 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 100,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.red.shade300,
                                          Colors.red,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text(
                                          "حالة المريض",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          (Total / 525 * 100)
                                                  .toStringAsFixed(0) +
                                              "%",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.monitor_heart_outlined,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "سيئة",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.heartCircleBolt,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "معدل نبض القلب",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        rateheart.toString() + " RPM",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        rateheart <= 90 && rateheart >= 60
                                            ? Colors.blue.shade300
                                            : Colors.red.shade300,
                                        rateheart <= 90 && rateheart >= 60
                                            ? Colors.blue
                                            : Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.droplet,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "معدل ضغط الدم",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        bloodpurusreup.toString() +
                                            " / " +
                                            bloodpurusredown.toString(),
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        bloodpurusreup <= 130 &&
                                                bloodpurusredown >= 90
                                            ? Colors.blue.shade300
                                            : Colors.red.shade300,
                                        bloodpurusreup <= 130 &&
                                                bloodpurusredown >= 90
                                            ? Colors.blue
                                            : Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.water,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "معدل سكر الدم",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        sugerblood.toString() + " mg",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        sugerblood <= 140 && sugerblood >= 80
                                            ? Colors.blue.shade300
                                            : Colors.red.shade300,
                                        sugerblood <= 140 && sugerblood >= 80
                                            ? Colors.blue
                                            : Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.o,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "نسبة الاكسجين",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        oxygen.toString(),
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        oxygen >= 80
                                            ? Colors.blue.shade300
                                            : Colors.red.shade300,
                                        oxygen >= 80 ? Colors.blue : Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.weightHanging,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "الوزن الحالي",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        weight.toString() + " KG",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        weight <= 90
                                            ? Colors.blue.shade300
                                            : Colors.red.shade300,
                                        weight <= 90 ? Colors.blue : Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.personWalking,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "الخطوات",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        steps.toString(),
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        steps <= 3000
                                            ? Colors.blue.shade300
                                            : Colors.red.shade300,
                                        steps <= 3000
                                            ? Colors.blue
                                            : Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (_selectedIndex == 1) {
                    return SafeArea(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "قائمة المستشفيات",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  " الرجاء قم باختيار مستشفى للطوارئ ",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Hospitals")
                                  .snapshots(),
                              builder: (context, hossnapshot) {
                                if (hossnapshot.hasData) {
                                  return Expanded(
                                    child: ListView.builder(
                                      itemCount: hossnapshot.data!.size,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 100,
                                          height: 60,
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.only(
                                              right: 15, left: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Text(hossnapshot
                                                  .data!.docs[index]["name"]
                                                  .toString()),
                                              IconButton(
                                                onPressed: () async {
                                                  //Add patient to hospital
                                                  DocumentReference hosref =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "Hospitals")
                                                          .doc(hossnapshot.data!
                                                              .docs[index].id);

                                                  final data = {
                                                    "age": usersnapshot
                                                        .data!.docs[0]["age"],
                                                    "agree": false,
                                                    "country": usersnapshot
                                                        .data!
                                                        .docs[0]["country"],
                                                    "dist": usersnapshot
                                                        .data!.docs[0]["dist"],
                                                    "email": usersnapshot
                                                        .data!.docs[0]["email"],
                                                    "phone": usersnapshot
                                                        .data!.docs[0]["phone"],
                                                    "phonebro": usersnapshot
                                                        .data!
                                                        .docs[0]["phonebro"],
                                                    "name": usersnapshot
                                                        .data!.docs[0]["name"],
                                                    "regdate": Timestamp.now(),
                                                    "status": "متوسطة",
                                                  };

                                                  print("ADDED TO >>> " +
                                                      hosref.id);

                                                  DocumentSnapshot olddatadoc =
                                                      await hosref.get();

                                                  Map<String, dynamic> olddata =
                                                      olddatadoc.data() as Map<
                                                          String, dynamic>;

                                                  List patients =
                                                      olddata["patients"];

                                                  patients.add();

                                                  hosref.set(olddata);

                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "تم تفعيل الإشعار للمستشفى",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.notification_add,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ],
                      ),
                    );
                  } else if (_selectedIndex == 2) {
                    return SafeArea(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "الملف الشخصي",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  " معلومات المريض الشخصية ",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 15, right: 15, top: 15, bottom: 15),
                                //   child: Container(
                                //     height: 60,
                                //     width: 100,
                                //     padding: const EdgeInsets.only(
                                //         left: 10, right: 10),
                                //     decoration: BoxDecoration(
                                //       color: Colors.grey.shade200,
                                //       borderRadius: BorderRadius.circular(20),
                                //     ),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceAround,
                                //       textDirection: TextDirection.rtl,
                                //       children: [
                                //         Icon(FontAwesomeIcons.idBadge),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Text(
                                //           "رقم المريض",
                                //           style: GoogleFonts.cairo(
                                //             textStyle: TextStyle(
                                //               fontSize: 12,
                                //               color: Colors.black,
                                //             ),
                                //           ),
                                //         ),
                                //         Expanded(
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(
                                //               left: 12,
                                //               right: 12,
                                //             ),
                                //             child: TextField(
                                //               textDirection: TextDirection.rtl,
                                //               textAlign: TextAlign.right,
                                //               decoration: InputDecoration(
                                //                 hintText: '229132',
                                //                 border: InputBorder.none,
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(Icons.man),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ":اسم المريض",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["name"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(FontAwesomeIcons.passport),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ": العمر",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["age"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(Icons.map),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ": البلد",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["country"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(Icons.streetview),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ": الحي",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["dist"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(Icons.streetview),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ": رقم الجوال",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["phone"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(Icons.streetview),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ": رقم جوال قريب",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["phonebro"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Icon(FontAwesomeIcons.droplet),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ": فصيلة الدم",
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(usersnapshot
                                                  .data!.docs[0]["Bloodtype"]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: "تم تسجيل الخروج بنجاح !",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            },
                            child: InkWell(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Signin_mobile(),
                                    ),
                                    (route) => true);
                              },
                              child: Container(
                                height: 50,
                                color: Colors.grey.shade200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "تسجيل خروج",
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.hospital),
                    label: 'المستشفيات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.user),
                    label: 'الحساب',
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
