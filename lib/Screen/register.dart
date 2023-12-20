import 'dart:io';
import 'package:covidreport/Screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:path/path.dart' as path;

class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey globalFormKey = new GlobalKey();
  var selectedValue;
  bool isLoading = false;
  bool _passwordVisible = false;
  @override
  TextEditingController dateTimeController = new TextEditingController();
  TextEditingController dateTimectrl = new TextEditingController();
  TextEditingController namactrl = new TextEditingController();
  TextEditingController nikctrl = new TextEditingController();
  TextEditingController alamatctrl = new TextEditingController();
  TextEditingController nomorteleponController = new TextEditingController();
  TextEditingController emailctrl = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  void _selDatePicker() {
    final f = new DateFormat('yyyy-MM-dd');
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1964),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      dateTimeController.text = DateFormat.yMd().format(pickedDate);
      setState(() {
        dateTimectrl.text = f.format(pickedDate);
        print(dateTimectrl.text);
      });
    });
  }

  void _actionSheet() {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('Pilih Gambar'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Buka Kamera'),
            onPressed: (context) async {
              await _getImageFromCamera();
              Navigator.of(context).pop();
            }),
        BottomSheetAction(
            title: const Text('Pilih File'),
            onPressed: (context) async {
              await _getImageFromGallery();
              Navigator.of(context).pop();
            }),
      ],
      cancelAction: CancelAction(
          title: const Text(
              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  File? image;

  Future _getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    image = File(imagePicked!.path);
    setState(() {
      image = File(imagePicked!.path);
      print(image);
    });
  }

  Future _getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    image = File(imagePicked!.path);
    setState(() {
      image = File(imagePicked!.path);
      print(image);
    });
  }

  Future _doRegis() async {
    String nama = namactrl.text;
    String nik = nikctrl.text;
    String datetime = dateTimectrl.text;
    String alamat = alamatctrl.text;
    String nomorTelepon = nomorteleponController.text;
    String email = emailctrl.text;
    String password = passwordController.text;
    if (nama.isNotEmpty &&
        nik.isNotEmpty &&
        datetime.isNotEmpty &&
        alamat.isNotEmpty &&
        nomorTelepon.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        image!.path != null) {
      try {
        var stream = http.ByteStream(DelegatingStream.typed(image!.openRead()));
        var uri =
            Uri.parse("https://apps.diseasetracker.asia/registration.php");
        var request = http.MultipartRequest("POST", uri);
        var length = await image!.length();
        request.fields['nama_user'] = nama;
        request.fields['nik'] = nik;
        request.fields['jns_kelamin'] = selectedValue;
        request.fields['tgl_lahir'] = datetime;
        request.fields['alamat'] = alamat;
        request.fields['no_tlp'] = nomorTelepon;
        request.fields['email'] = email;
        request.fields['password'] = password;
        request.files.add(http.MultipartFile('image', stream, length,
            filename: path.basename(image!.path)));
        var response = await request.send();
        var response1 = await http.Response.fromStream(response);
        if (response.statusCode > 2 &&
            jsonDecode(response1.body)['message'] == 'Berhasil didaftarkan') {
          print('success');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Berhasil Melakukan Registrasi!",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else if (response.statusCode > 2 &&
            jsonDecode(response1.body)['message'] ==
                'nik dan email telah digunakan') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Email atau NIK Telah Digunakan, Silahkan Coba Lagi!",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87)),
            backgroundColor: Colors.redAccent,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Gagal Registrasi, Silahkan Coba Lagi!",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87)),
            backgroundColor: Colors.redAccent,
          ));
          print("failed");
        }
      } catch (e) {
        debugPrint("Error $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Silahkan Lengkapi Form!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black87)),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: HexColor('#445BD8'),
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Buat Akun Baru",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
              child: TextFormField(
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                controller: namactrl,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Nama",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
              child: TextFormField(
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  controller: nikctrl,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(12),
                      hintText: "NIK",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Jenis Kelamin",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                dropdownColor: HexColor('#848EE7'),
                value: selectedValue,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                      child: Text("Laki-laki",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black))),
                      value: '1'),
                  DropdownMenuItem(
                      child: Text("Perempuan",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black))),
                      value: '2'),
                ],
                onChanged: (newvalue) => setState(() {
                  selectedValue = newvalue ?? "";
                  print(selectedValue);
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: TextField(
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Pilih Tanggal Lahir",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onTap: _selDatePicker,
                controller: dateTimeController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: TextFormField(
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                controller: alamatctrl,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Alamat",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: TextFormField(
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  controller: nomorteleponController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Nomor Telepon",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: TextFormField(
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                controller: emailctrl,
                validator: (val) => val!.isEmpty || !val.contains("@")
                    ? "enter a valid eamil"
                    : null,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Email",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: TextFormField(
                style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                controller: passwordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(12),
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
                    hintText: "Kata Sandi",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                obscureText: !_passwordVisible,
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("Foto KTP:",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )),
                  Form(
                      child: Column(
                    children: [
                      image != null
                          ? Container(
                              height: 480,
                              width: 640,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Image.file(
                                image!,
                                fit: BoxFit.fill,
                              ))
                          : Container(),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            _actionSheet();
                          },
                          child: Text(
                            'Ambil Gambar',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 12),
                              textStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "Kembali",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16)),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 55, vertical: 12),
                            textStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _doRegis();
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16)),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 55, vertical: 12),
                            textStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
