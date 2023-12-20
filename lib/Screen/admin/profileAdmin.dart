import 'dart:convert';
import 'dart:ui';
import 'package:covidreport/Model/profileAdminModel.dart';
import 'package:covidreport/Screen/admin/editPasswordAdmin.dart';
import 'package:covidreport/Screen/admin/editProfileAdmin.dart';
import 'package:covidreport/Screen/admin/menuAdmin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileAdmin extends StatefulWidget {
  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  bool circular = true;
  String? data = "";
  ProfileAdminModel profileAdmin = ProfileAdminModel();
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      data = pref.getString('val');
    });
    var url = Uri.https('apps.diseasetracker.asia', 'admin/profileAdmin.php',
        {'email': '${data}'});
    var res = await http.get(url);
    var r = json.decode(res.body);
    setState(() {
      print(r['data']);
      profileAdmin = ProfileAdminModel.fromJson(r['data']);
      circular = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Data Diri",
            style: GoogleFonts.poppins(
                textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MenuAdmin()));
          },
        ),
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                new Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  child: CircleAvatar(
                    backgroundColor: HexColor('#848EE7'),
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        profileAdmin.nama_user.toString(),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      TextField(
                          enabled: false,
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.house_outlined,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileAdmin.nama.toString(),
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          enabled: false,
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.account_circle,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileAdmin.jns_kelamin.toString(),
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          enabled: false,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileAdmin.tgl_lahir.toString(),
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          enabled: false,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.home_filled,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              hintText: profileAdmin.alamat.toString(),
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          enabled: false,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          decoration: new InputDecoration(
                              prefixIcon:
                                  Icon(Icons.call, color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileAdmin.telp_mitra,
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          enabled: false,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileAdmin.email,
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPasswordAdmin()));
                                  },
                                  child: Text(
                                    "Ubah Kata Sandi",
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 13),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(20)),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileAdmin()));
                                  },
                                  child: Text(
                                    "Ubah Data",
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 13),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
