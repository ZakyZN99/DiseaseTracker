// To parse this JSON data, do
//
//     final listHistory = listHistoryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ListHistory> listHistoryFromJson(String str) => List<ListHistory>.from(json.decode(str).map((x) => ListHistory.fromJson(x)));

String listHistoryToJson(List<ListHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListHistory {
  ListHistory({
    required this.id_kasus,
    required this.nama_pelapor,
    required this.foto_ktp_confirm,
    required this.no_tlp,
    required this.nama_pas,
    required this.gejala_pas,
    required this.alamat_pas,
    required this.lat,
    required this.long,
    required this.id_mitra,
    required this.id_status_kasus,
    required this.status_name,
    required this.nama,
    required this.alamat,
    required this.telp_mitra,
    required this.updated_at,
  });

  String id_kasus;
  String nama_pelapor;
  String foto_ktp_confirm;
  String no_tlp;
  String nama_pas;
  String gejala_pas;
  String alamat_pas;
  String lat;
  String long;
  String id_mitra;
  String id_status_kasus;
  String status_name;
  String nama;
  String alamat;
  String telp_mitra;
  String updated_at;

  factory ListHistory.fromJson(Map<String, dynamic> json) => ListHistory(
    id_kasus: json["id_kasus"],
    nama_pelapor: json["nama_pelapor"],
    foto_ktp_confirm: json["foto_ktp_confirm"],
    no_tlp: json["no_tlp"],
    nama_pas: json["nama_pas"],
    gejala_pas: json["gejala_pas"],
    alamat_pas: json["alamat_pas"],
    lat: json["lat"],
    long: json["long"],
    id_mitra: json["id_mitra"],
    nama: json["nama"],
    id_status_kasus: json["id_status_kasus"],
    status_name: json['status_name'],
    alamat: json["alamat"],
    telp_mitra: json["telp_mitra"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id_kasus": id_kasus,
    "nama_pelapor": nama_pelapor,
    "foto_ktp_confirm" : foto_ktp_confirm,
    "no_tlp": no_tlp,
    "nama_pas": nama_pas,
    "gejala_pas": gejala_pas,
    "alamat_pas": alamat_pas,
    "lat": lat,
    "long": long,
    "id_mitra": id_mitra,
    "id_status_kasus": id_status_kasus,
    "status_name": status_name,
    "nama": nama,
    "alamat": alamat,
    "telp_mitra": telp_mitra,
    "updated_at": updated_at,
  };
}
