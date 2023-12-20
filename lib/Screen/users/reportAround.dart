import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:covidreport/Model/profileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReportAround extends StatefulWidget {
  @override
  _ReportAroundState createState() => _ReportAroundState();
}

class _ReportAroundState extends State<ReportAround> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? data = "";
  bool circular = true;
  ProfileModel profileModel = ProfileModel();
  File? image;
  String? imagename;
  String? imagedata;
  TextEditingController? namactrl;
  TextEditingController? noTlpCtrl;
  TextEditingController? namaPasien = TextEditingController();
  TextEditingController? gejalaPasctrl = TextEditingController();
  TextEditingController? alamatPasctrl = TextEditingController();
  TextEditingController? latctrl;
  TextEditingController? lngctrl;

  GoogleMapController? _googleMapController;
  Marker? _location;
  static const _InitialCameraPosition = CameraPosition(
    target: LatLng(-8.4669253, 115.1064329),
    zoom: 12,
  );

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
        profileModel = ProfileModel.fromJson(r['data']);
        namactrl = TextEditingController(text: profileModel.nama_user);
        noTlpCtrl = TextEditingController(text: profileModel.no_tlp);
        circular = false;
      });
  }

  Future getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latctrl = TextEditingController(text: geoposition.latitude.toString());
      lngctrl = TextEditingController(text: geoposition.longitude.toString());
      print('${geoposition.longitude}');
    });
    LatLng latLng = LatLng(geoposition.latitude, geoposition.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 15);
    _googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        speed: 100,
        heading: 12,
        altitude: 12,
        timestamp: DateTime.now(),
        speedAccuracy: 100,
        accuracy: 100,
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    Marker? marker = _location;

    setState(() {
      _location = marker?.copyWith(
          positionParam:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
      latctrl =
          TextEditingController(text: newMarkerPosition.latitude.toString());
      lngctrl =
          TextEditingController(text: newMarkerPosition.longitude.toString());
    });
  }

  void _addMarker(LatLng _position) {
    if (_location == null) {
      setState(() {
        _location = Marker(
          markerId: const MarkerId('My Location'),
          draggable: false,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: _position,
          // onDragEnd:(newMarker){
          //   _position = newMarker;
          // }
        );
      });
    } else {}
    setState(() {
      latctrl = TextEditingController(text: _position.latitude.toString());
      lngctrl = TextEditingController(text: _position.longitude.toString());
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

  Future _getImageFromCamera() async {
    ImagePicker _picker = ImagePicker();
    final XFile? imagePicked = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    image = File(imagePicked!.path);
    imagename = imagePicked.path.split('/').last;
    imagedata = base64Encode(image!.readAsBytesSync());
    setState(() {
      image = File(imagePicked!.path);
      imagename = imagePicked.path.split('/').last;
      imagedata = base64Encode(image!.readAsBytesSync());
    });
  }

  Future _getImageFromGallery() async {
    ImagePicker _picker = ImagePicker();
    var imagePicked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    image = File(imagePicked!.path);
    imagename = imagePicked.path.split('/').last;
    imagedata = base64Encode(image!.readAsBytesSync());
    setState(() {
      image = File(imagePicked!.path);
      imagename = imagePicked.path.split('/').last;
      imagedata = base64Encode(image!.readAsBytesSync());
      print(image);
      print(imagename);
      print(imagedata);
    });
  }

  void initState() {
    super.initState();
    this.getData();
  }

  Future _doReportAround() async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(image!.openRead()));
      var uri =
          Uri.parse("https://apps.diseasetracker.asia/users/reportAround.php");
      var request = http.MultipartRequest("POST", uri);
      var length = await image!.length();
      request.fields['nama_pelapor'] = namactrl!.text;
      request.fields['no_tlp'] = noTlpCtrl!.text;
      request.fields['namaPasien'] = namaPasien!.text;
      request.fields['gejalaPasien'] = gejalaPasctrl!.text;
      request.fields['alamatPasien'] = alamatPasctrl!.text;
      request.fields['lat'] = latctrl!.text;
      request.fields['long'] = lngctrl!.text;
      request.files.add(http.MultipartFile('image', stream, length,
          filename: path.basename(image!.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print('success');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lapor Sekitar Berhasil Dilakukan!",
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
          content: Text("Gagal Mengirim Laporan!",
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Menu()));
            },
          ),
          backgroundColor: HexColor('#364BBD'),
          title: Text(
            "Lapor Sekitar Anda",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: TextFormField(
                  enabled: false,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  controller: namactrl,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  controller: noTlpCtrl,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(10),
                      hintText: "No.Tlp",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text("Verifikasi Foto KTP:",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
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
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              _actionSheet();
                            },
                            child: Text(
                              'Ambil Gambar',
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15)),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 65, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Text(
                        "1. Siapakah nama yang sedang mengalami gejala tersebut?",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500))),
                    TextFormField(
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal)),
                      controller: namaPasien,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Jawaban",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Text("2. Gejala apa saja yang dialami oleh orang tersebut?",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500))),
                    TextFormField(
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal)),
                      controller: gejalaPasctrl,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Jawaban",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Text("3. Dimanakah alamat tempat tinggal orang tersebut?",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500))),
                    TextFormField(
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal)),
                      controller: alamatPasctrl,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Jawaban",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getCurrentLocation();
                      },
                      child: Text(
                        "Lokasi Saya",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15)),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 0, top: 5, right: 0),
                      height: 400,
                      width: 690,
                      child: GoogleMap(
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: _InitialCameraPosition,
                        mapType: MapType.satellite,
                        markers: {if (_location != null) _location!},
                        onLongPress: _addMarker,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer())
                        },
                        onCameraMove: ((_position) =>
                            _updatePosition(_position)),
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _doReportAround();
                  },
                  child: Text(
                    "Kirim",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15)),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
