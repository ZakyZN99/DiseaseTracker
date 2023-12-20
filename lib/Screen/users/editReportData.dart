import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:covidreport/Model/historyModel.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/users/detailshistory.dart';
import 'package:covidreport/Screen/users/userReportHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditReportData extends StatefulWidget {
  const EditReportData({super.key, required this.historyModel});
  final HistoryModel historyModel;
  @override
  State<EditReportData> createState() => EditReportDataState();
}

class EditReportDataState extends State<EditReportData> {
  static const _InitialCameraPosition = CameraPosition(
    target: LatLng(-8.51032255, 115.0414431),
    zoom: 12,
  );
  GoogleMapController? _googleMapController;
  Marker? _location;
  File? image;
  TextEditingController? id_kasus;
  TextEditingController? namactrl;
  TextEditingController? noTlpCtrl;
  TextEditingController? namaPasien;
  TextEditingController? gejalaPasctrl;
  TextEditingController? alamatPasctrl;
  TextEditingController? latctrl;
  TextEditingController? lngctrl;

  Future getData() async {
    _location = Marker(
      markerId: const MarkerId('Lokasi Pelaporan'),
      infoWindow:
          InfoWindow(title: "Id Pelaporan: ${widget.historyModel.id_kasus}"),
      position: new LatLng(double.parse(widget.historyModel.lat),
          double.parse(widget.historyModel.long)),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    id_kasus = TextEditingController(text: widget.historyModel.id_kasus);
    namactrl = TextEditingController(text: widget.historyModel.nama_pelapor);
    noTlpCtrl = TextEditingController(text: widget.historyModel.no_tlp);
    namaPasien = TextEditingController(text: widget.historyModel.nama_pas);
    gejalaPasctrl = TextEditingController(text: widget.historyModel.gejala_pas);
    alamatPasctrl = TextEditingController(text: widget.historyModel.alamat_pas);
    latctrl = TextEditingController(text: widget.historyModel.lat);
    lngctrl = TextEditingController(text: widget.historyModel.long);
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

  Future _saveData() async {
    try {
      var uri =
          Uri.parse("https://apps.diseasetracker.asia/users/editHistory.php");

      if (id_kasus!.text.isNotEmpty &&
          namaPasien!.text.isNotEmpty &&
          gejalaPasctrl!.text.isNotEmpty &&
          alamatPasctrl!.text.isNotEmpty &&
          latctrl!.text.isNotEmpty &&
          lngctrl!.text.isNotEmpty) {
        var response = await http.post(uri, body: {
          'id_kasus': id_kasus!.text,
          'namaPasien': namaPasien!.text,
          'gejalaPasien': gejalaPasctrl!.text,
          'alamatPasien': alamatPasctrl!.text,
          'lat': latctrl!.text,
          'long': lngctrl!.text,
        });
        if (response.statusCode > 2) {
          print('success');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Berhasil Diubah!",
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
            content: Text("Gagal Mengubah Laporan!",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87)),
            backgroundColor: Colors.redAccent,
          ));
          print("failed");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Silahkan Lengkapi Data!",
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87)),
          backgroundColor: Colors.redAccent,
        ));
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  void initState() {
    super.initState();
    this.getData();
  }

  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Mengubah Data Laporan"),
      content: Text('Apakah Anda yakin ingin mengubah laporan Anda?'),
      actions: [
        CupertinoDialogAction(
          child: Text("Ya"),
          onPressed: () {
            _saveData();
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
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsUserHistory(
                          historyModel: widget.historyModel)));
            },
          ),
          backgroundColor: HexColor('#364BBD'),
          title: Text(
            "Ubah Report Data",
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
                  controller: id_kasus,
                  enabled: false,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      //hintText: "${widget.historyModel.nama_pelapor}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
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
                  controller: namactrl,
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(10),
                      // hintText: "${widget.historyModel.no_tlp}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
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
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "${widget.historyModel.no_tlp}",
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
                    Container(
                      child: Image.network(
                          "https://apps.diseasetracker.asia/fotoktp/${widget.historyModel.foto_ktp_confirm}"),
                    ),
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
                      controller: namaPasien,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal)),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          // hintText: "${widget.historyModel.nama_pas}",
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
                      controller: gejalaPasctrl,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal)),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          // hintText: "${widget.historyModel.gejala_pas}",
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
                          // hintText: "${widget.historyModel.alamat_pas}",
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
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
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
                                fontWeight: FontWeight.normal, fontSize: 16)),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      width: 690,
                      child: GoogleMap(
                        zoomControlsEnabled: true,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        initialCameraPosition: _InitialCameraPosition,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer())
                        },
                        mapType: MapType.satellite,
                        onLongPress: _addMarker,
                        //  markers:  {if(_location != null) _location ,_location1 }, //lebih dari 1 marker
                        markers: {if (_location != null) _location!},
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
                    showAlertDialog(context);
                  },
                  child: Text(
                    "SIMPAN",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15)),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
