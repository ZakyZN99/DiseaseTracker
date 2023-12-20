import 'package:covidreport/Screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey globalFormKey = new GlobalKey();
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;
  TextEditingController emailctrl = new TextEditingController();
  TextEditingController nikctrl = new TextEditingController();
  //TextEditingController no_tlpctrl = new TextEditingController();
  TextEditingController newpassctrl = new TextEditingController();
  TextEditingController repeatnewpassctrl = new TextEditingController();

  Future _doReqForgotPassword() async {
    var url = Uri.parse("https://apps.diseasetracker.asia/forgotpassword.php");
    String email = emailctrl.text;
    String nik = nikctrl.text;
    String repeatnewpass = repeatnewpassctrl.text;
    String newPass = newpassctrl.text;

    if (email.isNotEmpty &&
        nik.isNotEmpty &&
        repeatnewpass.isNotEmpty &&
        newPass.isNotEmpty) {
      var response = await http.post(url, body: {
        'email': email,
        'nik': nik,
        'password': newPass,
        'repeatpass': repeatnewpass,
      });
      print(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['message'] ==
            'Password Baru Harus Sama Dengan Ulangi Password Baru') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Kata Sandi Harus Sama",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            backgroundColor: Colors.red,
          ));
        } else if (jsonDecode(response.body)['message'] ==
            'Request Kata Sandi Berhasil!') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Permintaan Kata Sandi Berhasil!!",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            backgroundColor: Colors.green,
          ));
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove('val');
          pref.remove('valRole');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Permintaan Gagal, Silahkan Coba Lagi!",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
      } else if (jsonDecode(response.body)['message'] ==
          'Data Tidak Ditemukan') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Data Tidak Ditemukan",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Permintaan Reset Kata Sandi Gagal!, Silahkan Coba Lagi!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Silahkan isi data",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black87)),
        backgroundColor: Colors.red,
      ));
    }
  }

  void initState() {
    _passwordVisible = false;
    _passwordVisible1 = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: HexColor('#445BD8'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Lupa Kata Sandi",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ),
      body: ListView(
        key: globalFormKey,
        children: [
          new Padding(
            padding: EdgeInsets.only(top: 20, right: 10, left: 10),
            child: TextFormField(
              controller: emailctrl,
              decoration: new InputDecoration(
                filled: true,
                fillColor: HexColor('#848EE7'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Example@Gmail.com',
                hintStyle: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                labelText: 'Email',
                labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: TextFormField(
                controller: nikctrl,
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: HexColor('#848EE7'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'NIK',
                  hintStyle: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  labelText: 'NIK',
                  labelStyle: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: TextFormField(
              controller: newpassctrl,
              obscureText: !_passwordVisible,
              decoration: new InputDecoration(
                filled: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    )),
                fillColor: HexColor('#848EE7'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Kata Sandi Baru',
                hintStyle: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                labelText: 'Kata Sandi Baru',
                labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: TextFormField(
              controller: repeatnewpassctrl,
              obscureText: !_passwordVisible1,
              decoration: new InputDecoration(
                filled: true,
                fillColor: HexColor('#848EE7'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible1 = !_passwordVisible1;
                      });
                    },
                    icon: Icon(
                      _passwordVisible1
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    )),
                hintText: 'Ulangi Kata Sandi Baru',
                hintStyle: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                labelText: 'Ulangi Kata Sandi Baru',
                labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 40, right: 10, left: 10),
            child: ElevatedButton(
              onPressed: () {
                _doReqForgotPassword();
              },
              child: Text(
                "Permintaan Reset Kata Sandi",
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
