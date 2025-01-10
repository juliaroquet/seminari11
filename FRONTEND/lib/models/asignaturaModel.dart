import 'package:flutter/material.dart';

class AsignaturaModel with ChangeNotifier {
  final String id;
  final String nombre;
  final String descripcion;

  // Constructor
  AsignaturaModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  // Método fromJson para crear una instancia desde un Map
  factory AsignaturaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaModel(
      id: json['_id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  // Método toJson para convertir una instancia en un Map (por si lo necesitas para futuras funciones)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
