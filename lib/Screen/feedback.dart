import 'dart:convert';
import 'package:covidreport/Model/profileModel.dart';
import 'package:covidreport/Screen/login.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/users/editProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool circular = true;
  String? data = "";
  ProfileModel profileModel = ProfileModel();
  TextEditingController feedbackctrl = TextEditingController();

  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      data = pref.getString('val');
    });
    var url = Uri.https(
        'apps.diseasetracker.asia', 'users/profile.php', {'email': '${data}'});
    var res = await http.get(url);
    var r = json.decode(res.body);
    setState(() {
      print(r);
      profileModel = ProfileModel.fromJson(r['data']);
      circular = false;
    });
  }

  Future _Feedback() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      data = pref.getString('val');
    });
    var url = Uri.parse("https://apps.diseasetracker.asia/feedback.php");
    String feedback = feedbackctrl.text;
    if (feedback.isNotEmpty) {
      var response = await http.post(url, body: {
        'email': data,
        'id_pengguna': profileModel.id_users,
        'feedback': feedback,
      });
      print(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Feedback berhasil disimpan!",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Menu()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal menyimpan feedback!",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
          backgroundColor: Colors.red,
        ));
        print(response.body);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data form tidak boleh kosong!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("KRITIK & SARAN",
            style: GoogleFonts.poppins(
                textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Menu()));
          },
        ),
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                new Padding(
                  padding:
                      EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 10),
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
                        profileModel.nama_user.toString(),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                      ),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      TextField(
                          controller: feedbackctrl,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.multiline,
                          maxLines: 18,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          decoration: new InputDecoration(
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: "Kirik dan Saran",
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 30, right: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _Feedback();
                                  },
                                  child: Text(
                                    "Kirim",
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                  ),
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
