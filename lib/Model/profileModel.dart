import 'package:json_annotation/json_annotation.dart';

part 'profileModel.g.dart';

// Data dataFromJson(String str) => Data.fromJson(json.decode(str));
//
// String dataToJson(Data data) => json.encode(data.toJson());
@JsonSerializable()
class ProfileModel {
  String? id_users;
  String? nama_user;
  String? id_mitra;
  String? nik;
  String? jns_kelamin;
  String? tgl_lahir;
  String? alamat;
  String? no_tlp;
  String? email;
  String? password;
  String? fotoktp;
  String? role;
  String? status;
  ProfileModel({
    this.id_users,
    this.nama_user,
    this.id_mitra,
    this.nik,
    this.jns_kelamin,
    this.tgl_lahir,
    this.alamat,
    this.no_tlp,
    this.email,
    this.password,
    this.fotoktp,
    this.role,
    this.status,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}