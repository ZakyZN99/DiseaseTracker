// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileAdminModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileAdminModel _$ProfileAdminModelFromJson(Map<String, dynamic> json) =>
    ProfileAdminModel(
      id_users: json['id_users'] as String,
      nama_user: json['nama_user'] as String,
      id_mitra: json['id_mitra'] as String,
      jns_kelamin: json['jns_kelamin'] as String,
      tgl_lahir: json['tgl_lahir'] as String,
      alamat: json['alamat'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      status: json['status'] as String,
      role: json['role'] as String,
      nama: json['nama'] as String,
      telp_mitra: json['telp_mitra'] as String,
    );

Map<String, dynamic> _$ProfileAdminModelToJson(ProfileAdminModel instance) =>
    <String, dynamic>{
      'id_users': instance.id_users,
      'nama_user': instance.nama_user,
      'id_mitra': instance.id_mitra,
      'jns_jelamin': instance.jns_kelamin,
      'tgl_lahir': instance.tgl_lahir,
      'alamat': instance.alamat,
      'email': instance.email,
      'password': instance.password,
      'status': instance.status,
      'role': instance.role,
      'nama': instance.nama,
      'telp_mitra': instance.telp_mitra,
    };
