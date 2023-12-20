// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id_users: json['id_users'] as String?,
      nama_user: json['nama_user'] as String?,
      id_mitra: json['id_mitra'] as String?,
      nik: json['nik'] as String?,
      jns_kelamin: json['jns_kelamin'] as String?,
      tgl_lahir: json['tgl_lahir'] as String?,
      alamat: json['alamat'] as String?,
      no_tlp: json['no_tlp'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      fotoktp: json['fotoktp'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id_users': instance.id_users,
      'nama_user': instance.nama_user,
      'nik': instance.nik,
      'id_mitra' : instance.id_mitra,
      'jns_kelamin': instance.jns_kelamin,
      'tgl_lahir': instance.tgl_lahir,
      'alamat': instance.alamat,
      'no_tlp': instance.no_tlp,
      'email': instance.email,
      'password': instance.password,
      'fotoktp': instance.fotoktp,
      'role': instance.role,
      'status': instance.status,
          // 'email_verified_at': instance.email_verified_at?.toIso8601String(),
          // 'remember_token': instance.remember_token,
          // 'created_at': instance.created_at?.toIso8601String(),
          // 'updated_at': instance.updated_at?.toIso8601String(),
    };
