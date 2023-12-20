import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:covidreport/Model/profileModel.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/users/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool circular = true;
  String? data = "";
  ProfileModel profileModel = ProfileModel();
  var selectedValue;
  List<DropdownModel> _list = [];

  TextEditingController? namactrl;
  TextEditingController? nikctrl;
  TextEditingController? jeniskelaminctrl;
  TextEditingController? tgllahirctrl;
  TextEditingController? alamatctrl;
  TextEditingController? no_tlpctrl;
  TextEditingController? email;
  TextEditingController dateTimeController = new TextEditingController();

  void initState() {
    super.initState();
    this.getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _list.add(DropdownModel(id: '1', name: 'Laki-laki'));
      _list.add(DropdownModel(id: '2', name: 'Perempuan'));
    });
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
      namactrl = TextEditingController(text: profileModel.nama_user);
      nikctrl = TextEditingController(text: profileModel.nik);
      jeniskelaminctrl = TextEditingController(text: profileModel.jns_kelamin);
      tgllahirctrl = TextEditingController(text: profileModel.tgl_lahir);
      alamatctrl = TextEditingController(text: profileModel.alamat);
      no_tlpctrl = TextEditingController(text: profileModel.no_tlp);
      email = TextEditingController(text: profileModel.email);
      circular = false;
    });
  }

  void _selDatePicker() {
    final f = new DateFormat('yyyy-MM-dd');
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      dateTimeController.text = DateFormat.yMd().format(pickedDate);
      setState(() {
        tgllahirctrl!.text = f.format(pickedDate);
        print(tgllahirctrl!.text);
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
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.camera);
    image = File(imagePicked!.path);
    setState(() {
      image = File(imagePicked!.path);
      print(image);
    });
  }

  Future _getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.gallery);
    image = File(imagePicked!.path);
    setState(() {
      image = File(imagePicked!.path);
      print(image);
    });
  }

  Future _doEditData() async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(image!.openRead()));
      var uri =
          Uri.parse("https://apps.diseasetracker.asia/users/editProfile.php");
      var request = http.MultipartRequest("POST", uri);
      var length = await image!.length();
      request.fields['nama_user'] = namactrl!.text;
      request.fields['nik'] = nikctrl!.text;
      request.fields['jns_kelamin'] = selectedValue;
      request.fields['tgl_lahir'] = tgllahirctrl!.text;
      request.fields['alamat'] = alamatctrl!.text;
      request.fields['no_tlp'] = no_tlpctrl!.text;
      request.fields['email'] = email!.text;
      request.files.add(http.MultipartFile('image', stream, length,
          filename: path.basename(image!.path)));
      var response = await request.send();
      print(response);
      if (response.statusCode > 2) {
        print('success');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Berhasil Mengubah Data!",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Profile()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal Merubah Data!",
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
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Mengubah Data Profil"),
      content: Text('Apakah Anda yakin ingin mengubah data Anda?'),
      actions: [
        CupertinoDialogAction(
          child: Text("Ya"),
          onPressed: () {
            _doEditData();
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Ubah Data Diri",
            style: GoogleFonts.poppins(
                textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Profile()));
          },
        ),
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                new Padding(
                  padding:
                      EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 0),
                  child: CircleAvatar(
                    backgroundColor: HexColor('#848EE7'),
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      color: Colors.black87,
                      size: 80,
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                      TextField(
                          controller: namactrl,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.black87,
                              ),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: "Nama",
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          controller: nikctrl,
                          enabled: false,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: Colors.black87,
                              ),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: "NIK",
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_pin,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: HexColor('#848EE7'),
                            contentPadding: EdgeInsets.all(10),
                            hintText: profileModel.jns_kelamin.toString(),
                            helperStyle: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        dropdownColor: HexColor('#848EE7'),
                        value: selectedValue,
                        isExpanded: true,
                        items: _list.map((DropdownModel e) {
                          return DropdownMenuItem(
                              value: e.id.toString(),
                              child: Text(e.name,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black))));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value.toString();
                            print(selectedValue);
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month,
                                color: Colors.black87),
                            filled: true,
                            fillColor: HexColor('#848EE7'),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onTap: _selDatePicker,
                        controller: tgllahirctrl,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          controller: alamatctrl,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.home_filled,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: "Alamat",
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          controller: no_tlpctrl,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.call, color: Colors.black87),
                            filled: true,
                            fillColor: HexColor('#848EE7'),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            hintText: "No. Telp.",
                            hintStyle: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                          enabled: false,
                          controller: email,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Colors.black87),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileModel.email,
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextField(
                                    enabled: false,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(Icons.credit_card,
                                            color: Colors.black87),
                                        filled: true,
                                        fillColor: HexColor('#848EE7'),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                        hintText:
                                            profileModel.fotoktp.toString(),
                                        hintStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)),
                                        border: new OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)))),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _actionSheet();
                                  },
                                  child: Text(
                                    "Upload",
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
                                          horizontal: 40, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 25, left: 30, right: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                  child: Text(
                                    "Simpan",
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
                                          horizontal: 50, vertical: 15),
                                      textStyle: TextStyle(
                                          fontSize: 20,
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

class DropdownModel {
  String id;
  String name;

  DropdownModel({required this.id, required this.name});
}
