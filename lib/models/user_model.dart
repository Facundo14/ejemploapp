// To parse this JSON data, do
//
//     final platoModel = platoModelFromJson(jsonString);

import 'dart:convert';

UserModel platoModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String platoModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
  });

  int? id;
  String nombre;
  String email;
  String password;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["Id"],
        nombre: json["Nombre"],
        email: json["Email"],
        password: json["Password"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Nombre": nombre,
        "Email": email,
        "Password": password,
      };
}
