import 'package:covidreport/Model/historyModel.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/users/editReportData.dart';
import 'package:covidreport/Screen/users/userReportHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class DetailsUserHistory extends StatefulWidget {
  const DetailsUserHistory({super.key, required this.historyModel});
  final HistoryModel historyModel;
  @override
  State<DetailsUserHistory> createState() => _DetailsUserHistoryState();
}

class _DetailsUserHistoryState extends State<DetailsUserHistory> {
  static const _InitialCameraPosition = CameraPosition(
    target: LatLng(-8.51032255, 115.0414431),
    zoom: 10,
  );
  GoogleMapController? _googleMapController;
  Marker? _location;
  TextEditingController? id_kasus;

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
  }

  void initState() {
    super.initState();
    this.getData();
  }

  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  Future hapusData() async {
    var uri =
        Uri.parse("https://apps.diseasetracker.asia/users/hapusDataReport.php");
    var response = await http.post(uri, body: {
      'id_kasus': id_kasus!.text,
    });
    if (response.statusCode > 2) {
      print('success');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Berhasil hapus!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white)),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserReportHistory()));
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
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Menghapus Data Pelaporan"),
      content: Text('Apakah Anda yakin menghapus laporan?'),
      actions: [
        CupertinoDialogAction(
          child: Text("Ya"),
          onPressed: () {
            hapusData();
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserReportHistory()));
            },
          ),
          backgroundColor: HexColor('#364BBD'),
          title: Text(
            "Detail Laporan",
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
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      hintText:
                          "Nomor Laporan: ${widget.historyModel.id_kasus}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextFormField(
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      hintText: "Nama: ${widget.historyModel.nama_pelapor}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
                  //controller: noTlpCtrl,
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(10),
                      hintText: "No. Telp: ${widget.historyModel.no_tlp}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
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
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal)),
                      enabled: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "${widget.historyModel.nama_pas}",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
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
                      enabled: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "${widget.historyModel.gejala_pas}",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
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
                      enabled: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "${widget.historyModel.alamat_pas}",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10)),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      width: 690,
                      child: GoogleMap(
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        initialCameraPosition: _InitialCameraPosition,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer())
                        },
                        mapType: MapType.satellite,
                        //  markers:  {if(_location != null) _location ,_location1 }, //lebih dari 1 marker
                        markers: {if (_location != null) _location!},
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditReportData(
                                        historyModel: widget.historyModel)));
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
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            showAlertDialog(context);
                          },
                          child: Text(
                            "Hapus Data",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16)),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
