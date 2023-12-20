// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<HistoryModel> historyModelFromJson(String str) => List<HistoryModel>.from(json.decode(str).map((x) => HistoryModel.fromJson(x)));

String historyModelToJson(List<HistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryModel {
  HistoryModel({
    required this.id_kasus,
    required this.nama_pelapor,
    required this.no_tlp,
    required this.foto_ktp_confirm,
    required this.nama_pas,
    required this.gejala_pas,
    required this.alamat_pas,
    required this.lat,
    required this.long,
    required this.id_mitra,
    required this.status,
    required this.created_at,
  });

  String id_kasus;
  String nama_pelapor;
  String no_tlp;
  String foto_ktp_confirm;
  String nama_pas;
  String gejala_pas;
  String alamat_pas;
  String lat;
  String long;
  String id_mitra;
  String status;
  DateTime created_at;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    id_kasus: json["id_kasus"],
    nama_pelapor: json["nama_pelapor"],
    no_tlp: json["no_tlp"],
    foto_ktp_confirm: json["foto_ktp_confirm"],
    nama_pas: json["nama_pas"],
    gejala_pas: json["gejala_pas"],
    alamat_pas: json["alamat_pas"],
    lat: json["lat"],
    long: json["long"],
    id_mitra: json["id_mitra"],
    status: json["status"],
    created_at: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_kasus": id_kasus,
    "nama_pelapor": nama_pelapor,
    "no_tlp": no_tlp,
    "foto_ktp_confirm": foto_ktp_confirm,
    "nama_pas": nama_pas,
    "gejala_pas": gejala_pas,
    "alamat_pas": alamat_pas,
    "lat": lat,
    "long": long,
    "id_mitra": id_mitra,
    "status": status,
    "created_at": created_at.toIso8601String(),
  };
}
