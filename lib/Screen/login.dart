import 'dart:convert';
import 'package:covidreport/Model/profileModel.dart';
import 'package:covidreport/Screen/admin/menuAdmin.dart';
import 'package:covidreport/Screen/forgotPassword.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailctrl = new TextEditingController();
  TextEditingController passwordctrl = new TextEditingController();
  ProfileModel profileModel = ProfileModel();
  bool _passwordVisible = false;

  void initState() {
    setState(() {
      _passwordVisible = false;
      super.initState();
      this.getData();
      this.profileModel;
      this.checkLogin();
    });
  }

  Future<void> checkLogin() async {
    this.getData();
    SharedPreferences pref = await SharedPreferences.getInstance();
    final val = await pref.getString("val");
    final valRole = await pref.getString("valRole");
    print(valRole);
    if (val != null) {
      if (valRole == '2') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MenuAdmin(),
            ));
      } else if (valRole == '3') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Menu(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      }
    } else {}
  }

  void getData() async {
    String email = emailctrl.text;
    var url = Uri.https(
        'apps.diseasetracker.asia', 'users/profile.php', {'email': '${email}'});
    //var url = Uri.https('192.168.1.2','apiCoviDReport/users/profile.php',{'email': '${email}'});
    var res = await http.get(url);
    var r = json.decode(res.body);
    setState(() {
      profileModel = ProfileModel.fromJson(r['data']);
      print(profileModel);
    });
  }

  Future<void> SignIn() async {
    //var url = Uri.parse("http://192.168.1.2/apiCoviDReport/login.php");
    var url = Uri.parse("https://apps.diseasetracker.asia/login.php");

    String email = emailctrl.text;
    String pw = passwordctrl.text;
    this.getData();
    //String role = profileModel.role.toString();
    if (email.isNotEmpty && pw.isNotEmpty) {
      final response = await http.post(url, body: {
        "email": email,
        "password": pw,
      });

      print(profileModel.role);
      print(profileModel);

      if (profileModel.role == '2') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("val", email);
        await pref.setString("valRole", profileModel.role.toString());
        if (jsonDecode(response.body)['message'] == 'Login Berhasil') {
          print("admin");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MenuAdmin()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Gagal Login Silahkan Coba Lagi",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            backgroundColor: Colors.red,
          ));
        }
      } else if (profileModel.role == '3') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("val", email);
        await pref.setString("valRole", profileModel.role.toString());
        if (jsonDecode(response.body)['message'] == 'Login Berhasil') {
          print("user");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Menu()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Gagal Login Silahkan Coba Lagi",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("val", email);
        await pref.setString("valRole", profileModel.role.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal Login Silahkan Coba Lagi",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
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

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HexColor('#364BBD'),
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              padding: EdgeInsets.only(top: 150),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text("Selamat Datang!",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w600))),
                  Text("Silahkan Melakukan Sign In untuk melanjutkan!",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal))),
                  Form(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 200, left: 10, right: 10),
                        child: TextFormField(
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          controller: emailctrl,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: EdgeInsets.all(18),
                              hintText: 'Email',
                              labelStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: TextFormField(
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          controller: passwordctrl,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
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
                            filled: true,
                            fillColor: HexColor('#848EE7'),
                            contentPadding: EdgeInsets.all(18),
                            hintText: 'Kata Sandi',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: Text("Lupa Kata Sandi?"),
                                style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13)))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            SignIn();
                          },
                          child: Text("Sign In"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //"Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));"
                          children: [
                            Text(
                              "Anda tidak memiliki akun?",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Text("Sign Up"),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            )));
  }
}
