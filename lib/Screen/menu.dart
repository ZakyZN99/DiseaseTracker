import 'package:covidreport/Model/profileModel.dart';
import 'package:covidreport/Screen/feedback.dart';
import 'package:covidreport/Screen/login.dart';
import 'package:covidreport/Screen/users/profile.dart';
import 'package:covidreport/Screen/users/reportAround.dart';
import 'package:covidreport/Screen/users/userReportHistory.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProfileModel profileModel = ProfileModel();
  String? data = "";
  Timer? timer;
  bool circular = true;

  Future getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      data = pref.getString('val');
    });
    var url = Uri.https(
        'apps.diseasetracker.asia', 'users/profile.php', {'email': '${data}'});
    var res = await http.get(url);
    var r = json.decode(res.body);

    if (mounted)
      setState(() {
        Uri.https('apps.diseasetracker.asia', 'users/profile.php',
            {'email': '${data}'});
        print(r);
        profileModel = ProfileModel.fromJson(r['data']);
        circular = false;
      });
  }

  void initState() {
    super.initState();
    this.getData();
    //   this.getDataAlat();
    //  timer = Timer.periodic(Duration(seconds: 5), (Timer t) => this.getData());
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Keluar Akun"),
      content: Text('Apakah Anda yakin keluar dari Akun?'),
      actions: [
        CupertinoDialogAction(
            child: Text("Ya"),
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove('val');
              pref.remove('valRole');
              Navigator.pop(context, true);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }),
        CupertinoDialogAction(
          child: Text("Tidak"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
    return;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#445BD8'),
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: circular
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 80),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Halo ",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                          Text(
                            profileModel.nama_user.toString(),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          )
                        ]),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Card(
                              color: HexColor('#848EE7'),
                              child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.people_alt_outlined,
                                        size: 50,
                                      ),
                                      Text(
                                        "Profil",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black),
                                      )
                                    ],
                                  ))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Card(
                              color: HexColor('#848EE7'),
                              child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportAround()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_present,
                                        size: 50,
                                      ),
                                      Text(
                                        "Lapor",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black),
                                      )
                                    ],
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Card(
                              color: HexColor('#848EE7'),
                              child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserReportHistory()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.list_alt_rounded,
                                        size: 50,
                                      ),
                                      Text(
                                        "Histori",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black),
                                      )
                                    ],
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Card(
                              color: HexColor('#848EE7'),
                              child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FeedbackScreen()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.comment_outlined,
                                        size: 50,
                                      ),
                                      Text(
                                        "Feedback",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black),
                                      )
                                    ],
                                  ))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Card(
                              color: HexColor('#848EE7'),
                              child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    showAlertDialog(context);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.exit_to_app_outlined,
                                        size: 50,
                                      ),
                                      Text(
                                        "Keluar",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black),
                                      )
                                    ],
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
