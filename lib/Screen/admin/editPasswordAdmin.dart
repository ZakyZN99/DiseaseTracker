import 'package:covidreport/Model/profileAdminModel.dart';
import 'package:covidreport/Screen/admin/profileAdmin.dart';
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

class EditPasswordAdmin extends StatefulWidget {
  @override
  _EditPasswordAdminState createState() => _EditPasswordAdminState();
}

class _EditPasswordAdminState extends State {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey globalFormKey = new GlobalKey();
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  String? data = "";
  ProfileAdminModel profileModel = ProfileAdminModel();
  TextEditingController? email;
  TextEditingController katasandilamactrl = new TextEditingController();
  TextEditingController katasandibaructrl = new TextEditingController();
  TextEditingController ulangisandibaructrl = new TextEditingController();

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      data = pref.getString('val');
    });
    var url = Uri.http('apps.diseasetracker.asia', 'admin/profileAdmin.php',
        {'email': '${data}'});
    var res = await http.get(url);
    var r = json.decode(res.body);
    setState(() {
      print(data);
      profileModel = ProfileAdminModel.fromJson(r['data']);
      email = TextEditingController(text: profileModel.email);
    });
  }

  Future _doReqForgotPassword() async {
    var url = Uri.parse(
        "https://apps.diseasetracker.asia/admin/editPasswordAdmin.php");
    if (katasandilamactrl!.text.isNotEmpty &&
        katasandibaructrl!.text.isNotEmpty &&
        ulangisandibaructrl!.text.isNotEmpty) {
      var response = await http.post(url, body: {
        'email': email!.text,
        'password': katasandilamactrl!.text,
        'newpass': katasandibaructrl!.text,
        'repeatnewpass': ulangisandibaructrl!.text,
      });
      print(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['message'] ==
            'Password Baru Harus Sama Dengan Ulangi Password Baru') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Kata Sandi Baru Harus Sama Dengan Ulangi Kata Sandi Baru",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87)),
            backgroundColor: Colors.red,
          ));
        } else if (jsonDecode(response.body)['message'] ==
            'Berhasil Mengubah Password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Kata Sandi Berhasil Diubah!",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87)),
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
              "Ubah Kata Sandi Gagal, Silahkan Coba Lagi!",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87),
            ),
            backgroundColor: Colors.red,
          ));
        }
      } else if (jsonDecode(response.body)['message'] ==
          'Data Tidak Ditemukan') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Password Lama Tidak Cocok",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black87),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Ubah Kata Sandi Gagal, Silahkan Coba Lagi!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black87),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Silahkan lengkapi form!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black87)),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Mengubah Kata Sandi"),
      content: Text('Apakah Anda yakin mengubah kata sandi Anda?'),
      actions: [
        CupertinoDialogAction(
          child: Text("Ya"),
          onPressed: () {
            _doReqForgotPassword();
          },
        ),
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

  void initState() {
    _passwordVisible = false;
    _passwordVisible1 = false;
    _passwordVisible2 = false;
    super.initState();
    this.getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: HexColor('#445BD8'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Ubah Kata Sandi",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfileAdmin()));
          },
        ),
      ),
      body: ListView(
        key: globalFormKey,
        children: [
          new Padding(
            padding: EdgeInsets.only(top: 40, right: 20, left: 20),
            child: TextFormField(
              controller: katasandilamactrl,
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
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: 'Kata Sandi Lama',
                hintStyle: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                labelText: 'Kata Sandi Lama',
                labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: TextFormField(
              controller: katasandibaructrl,
              obscureText: !_passwordVisible1,
              decoration: new InputDecoration(
                filled: true,
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
                fillColor: HexColor('#848EE7'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: 'Kata Sandi Baru',
                hintStyle: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                labelText: 'Kata Sandi Baru',
                labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: TextFormField(
              controller: ulangisandibaructrl,
              obscureText: !_passwordVisible2,
              decoration: new InputDecoration(
                filled: true,
                fillColor: HexColor('#848EE7'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible2 = !_passwordVisible2;
                      });
                    },
                    icon: Icon(
                      _passwordVisible2
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    )),
                hintText: 'Ulangi Kata Sandi Baru',
                hintStyle: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                labelText: 'Ulangi Kata Sandi Baru',
                labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 50, right: 70, left: 70),
            child: ElevatedButton(
              onPressed: () {
                showAlertDialog(context);
              },
              child: Text(
                "SIMPAN",
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
