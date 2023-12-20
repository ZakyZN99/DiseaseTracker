import 'package:covidreport/Model/listhistoryAdmin.dart';
import 'package:covidreport/Screen/admin/historyData.dart';
import 'package:covidreport/Screen/admin/menuAdmin.dart';
import 'package:covidreport/Screen/users/userReportHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart';

class DetailHistoryDataAdmin extends StatefulWidget {
  const DetailHistoryDataAdmin({super.key, required this.listHistory});
  final ListHistory listHistory;
  @override
  State<DetailHistoryDataAdmin> createState() => _DetailHistoryDataAdminState();
}

class _DetailHistoryDataAdminState extends State<DetailHistoryDataAdmin> {
  final GlobalKey<FormFieldState> _key_dropdown = GlobalKey<FormFieldState>();
  static const _InitialCameraPosition = CameraPosition(
    target: LatLng(-8.51032255, 115.0414431),
    zoom: 12,
  );
  GoogleMapController? _googleMapController;
  Marker? _location;
  TextEditingController? id_kasus;
  var _selectedValue;
  List<DropdownModel> _list = [];

  Future getData() async {
    _location = Marker(
      markerId: const MarkerId('Lokasi Pelaporan'),
      infoWindow:
          InfoWindow(title: "Id Pelaporan: ${widget.listHistory.id_kasus}"),
      position: new LatLng(double.parse(widget.listHistory.lat),
          double.parse(widget.listHistory.long)),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    id_kasus = TextEditingController(text: widget.listHistory.id_kasus);
  }

  void initState() {
    super.initState();
    setState(() {
      this.getData();
      _selectedValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _list.add(DropdownModel(id: '0', name: 'Baru'));
        _list.add(DropdownModel(id: '1', name: 'Proses Penjemputan'));
        _list.add(DropdownModel(id: '2', name: 'Telah Dijemput'));
        _list.add(DropdownModel(id: '3', name: 'Ditolak'));
      });
    });
  }

  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  Future simpanStatus() async {
    var uri =
        Uri.parse("https://apps.diseasetracker.asia/admin/ubahStatus.php");
    var response = await http.post(uri, body: {
      'id_kasus': id_kasus!.text,
      'status': _selectedValue,
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
          context, MaterialPageRoute(builder: (context) => MenuAdmin()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal Mengubah Laporan!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white)),
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MenuAdmin()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal Menghapus Laporan!",
            style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ));
      print("failed");
    }
  }

  Future routeMap() async {
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(double.parse(widget.listHistory.lat),
          double.parse(widget.listHistory.long)),
      title: "Lokasi Pelaporan",
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ListDataAdmin()));
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
                      hintText: "Nomor Laporan: ${widget.listHistory.id_kasus}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
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
                      hintText:
                          "Nama Pelapor: ${widget.listHistory.nama_pelapor}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
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
                  //controller: noTlpCtrl,
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('#848EE7'),
                      contentPadding: EdgeInsets.all(10),
                      hintText:
                          "No. Telp Pelapor: ${widget.listHistory.no_tlp}",
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text("Verifikasi Foto KTP:",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      child: Image.network(
                          "https://apps.diseasetracker.asia/fotoktp/${widget.listHistory.foto_ktp_confirm}"),
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
                          hintText:
                              "Nama Pasien: ${widget.listHistory.nama_pas}",
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
                          hintText: "Gejala: ${widget.listHistory.gejala_pas}",
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
                      enabled: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor('#848EE7'),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Alamat: ${widget.listHistory.alamat_pas}",
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 14,
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
                        // mapType: MapType.satellite,
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
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor('#848EE7'),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Status Kasus: ${widget.listHistory.status_name}",
                    hintStyle: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: HexColor('#848EE7'),
                  value: _selectedValue,
                  items: [
                    DropdownMenuItem(
                        child: Text("Baru",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black))),
                        value: '0'),
                    DropdownMenuItem(
                        child: Text("Proses Penjemputan",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black))),
                        value: '1'),
                    DropdownMenuItem(
                        child: Text("Telah Dijemput",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black))),
                        value: '2'),
                    DropdownMenuItem(
                        child: Text("Ditolak",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black))),
                        value: '3'),
                    DropdownMenuItem(
                        child: Text("Proses Penjemputan Selesai",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black))),
                        value: '4'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!.toString();
                      print(_selectedValue);
                    });
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(0)),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            simpanStatus();
                          },
                          child: Text(
                            "Simpan Status",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
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
                                    fontSize: 14)),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 25, bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    routeMap();
                  },
                  child: Text(
                    "ROUTE",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14)),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownModel {
  String id;
  String name;

  DropdownModel({required this.id, required this.name});
}
