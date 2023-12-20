import 'dart:convert';
import 'dart:developer';
import 'package:covidreport/Model/listhistoryAdmin.dart';
import 'package:covidreport/Screen/admin/detailListDataAdmin.dart';
import 'package:covidreport/Screen/admin/menuAdmin.dart';
import 'package:covidreport/Screen/menu.dart';
import 'package:covidreport/Screen/users/detailshistory.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListDataAdmin extends StatefulWidget {
  @override
  _ListDataAdminState createState() => _ListDataAdminState();
}

class _ListDataAdminState extends State<ListDataAdmin> {
  @override
  List<ListHistory> listHistory = [];
  String? data = "";
  bool circular = true;

  void initState() {
    super.initState();
  }

  Future<List<ListHistory>> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    data = pref.getString('valMit');
    print(data);
    var url = Uri.http('apps.diseasetracker.asia', 'admin/historyDataAdmin.php',
        {'id_mitra': '${data}'});
    var response = await http.get(url);
    var data1 = jsonDecode(response.body)['data'];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data1) {
        listHistory.add(ListHistory.fromJson(index));
      }
      return listHistory;
    } else {
      return listHistory;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#364BBD'),
      appBar: AppBar(
        backgroundColor: HexColor('#364BBD'),
        title: Text("Histori Laporan",
            style: GoogleFonts.poppins(
                textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MenuAdmin()));
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: listHistory.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 120,
                    color: HexColor('#848EE7'),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor Laporan: ${listHistory[index].id_kasus}",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13)),
                            ),
                            Text(
                              "Nama Pelapor: ${listHistory[index].nama_pelapor}",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13)),
                            ),
                            Text(
                              "Nama Pelapor: ${listHistory[index].updated_at}",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailHistoryDataAdmin(
                                            listHistory: listHistory[index])));
                          },
                          child: Text(
                            "Detail",
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
                                  horizontal: 10, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  );
                  // return ListTile(
                  //   title: Text(historyModel[index].id_kasus),
                  // );
                },
              );
            } else if (snapshot.hasError) {
              return Text(
                "Data Tidak Ditemukan!",
                style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                textAlign: TextAlign.center,
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
