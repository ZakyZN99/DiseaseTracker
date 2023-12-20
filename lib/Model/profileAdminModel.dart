import 'package:json_annotation/json_annotation.dart';
part 'profileAdminModel.g.dart';

// Data dataFromJson(String str) => Data.fromJson(json.decode(str));
//
// String dataToJson(Data data) => json.encode(data.toJson());

@JsonSerializable()
class ProfileAdminModel {
  String? id_users;
  String? nama_user;
  String? id_mitra;
  String? jns_kelamin;
  String? tgl_lahir;
  String? alamat;
  String? email;
  String? password;
  String? status;
  String? role;
  String? nama;
  String? telp_mitra;
  ProfileAdminModel({
    this.id_users,
    this.nama_user,
    this.id_mitra,
    this.jns_kelamin,
    this.tgl_lahir,
    this.alamat,
    this.email,
    this.password,
    this.status,
    this.role,
    this.nama,
    this.telp_mitra,
  });
  factory ProfileAdminModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileAdminModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileAdminModelToJson(this);
}
