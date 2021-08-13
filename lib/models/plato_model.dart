// To parse this JSON data, do
//
//     final platoModel = platoModelFromJson(jsonString);

import 'dart:convert';

PlatoModel platoModelFromJson(String str) =>
    PlatoModel.fromJson(json.decode(str));

String platoModelToJson(PlatoModel data) => json.encode(data.toJson());

class PlatoModel {
  PlatoModel({
    required this.codigo,
    required this.descripcion,
    required this.precio,
  });

  String codigo;
  String descripcion;
  double precio;

  factory PlatoModel.fromJson(Map<String, dynamic> json) => PlatoModel(
        codigo: json["Codigo"],
        descripcion: json["Descripcion"],
        precio: json["Precio"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Descripcion": descripcion,
        "Precio": precio,
      };
}
