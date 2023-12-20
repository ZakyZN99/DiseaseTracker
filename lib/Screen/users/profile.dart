import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:covidreport/Model/profileModel.dart';
import 'package:covidreport/Screen/login.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/users/editPasswordUser.dart';
import 'package:covidreport/Screen/users/editProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool circular = true;
  String? data = "";
  ProfileModel profileModel = ProfileModel();
  ReceivePort _port = ReceivePort();

  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) print('Download Complete');
      setState(() {});
    });

    FlutterDownloader.registerCallback(DownloadCallback);
    super.initState();
    this.getData();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void DownloadCallback(id, status, progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
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

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        saveInPublicStorage: true,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: "/storage/emulated/0/Download",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification: true,
      );
    }
    var status1 = await Permission.manageExternalStorage.request();
    if (status1.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        saveInPublicStorage: true,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: "/storage/emulated/0/Download",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification: true,
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Data Diri",
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
                        profileModel.nama_user.toString(),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      TextField(
                          enabled: false,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal)),
                          decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: Colors.black87,
                              ),
                              filled: true,
                              fillColor: HexColor('#848EE7'),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: profileModel.nik.toString(),
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
                              hintText: profileModel.jns_kelamin.toString(),
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
                              hintText: profileModel.tgl_lahir.toString(),
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
                                  vertical: 10, horizontal: 10),
                              hintText: profileModel.alamat.toString(),
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
                              hintText: profileModel.no_tlp,
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
                              hintText: profileModel.email,
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
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
                                            fontWeight: FontWeight.normal)),
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
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black)),
                                        border: new OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)))),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () => download(
                                      'https://apps.diseasetracker.asia/fotoktp/${profileModel.fotoktp}'),
                                  child: Text(
                                    "Unduh",
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
                                          horizontal: 15, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPasswordUser()));
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
                                                EditProfile()));
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
