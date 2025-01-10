import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String id;
  String name;
  String mail;
  String password;
  int age;
  bool isProfesor;
  bool isAlumno;
  bool isAdmin;
  bool conectado;
  double lat; // Nueva propiedad
  double lng; // Nueva propiedad

  UserModel({
    required this.id,
    required this.name,
    required this.mail,
    required this.password,
    required this.age,
    this.isProfesor = false,
    this.isAlumno = false,
    this.isAdmin = true,
    this.conectado = false,
    this.lat = 0.0, // Valor predeterminado
    this.lng = 0.0, // Valor predeterminado
  });

  // Método para actualizar el modelo con nuevos datos
  void setUser({
    required String id,
    required String name,
    required String mail,
    required String password,
    required int age,
    required bool isProfesor,
    required bool isAlumno,
    required bool isAdmin,
    required bool conectado,
    double? lat,
    double? lng,
  }) {
    this.id = id;
    this.name = name;
    this.mail = mail;
    this.password = password;
    this.age = age;
    this.isProfesor = isProfesor;
    this.isAlumno = isAlumno;
    this.isAdmin = isAdmin;
    this.conectado = conectado;
    if (lat != null) this.lat = lat;
    if (lng != null) this.lng = lng;
    notifyListeners();
  }

  // Método para crear una instancia desde un Map (JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['nombre'] ?? '',
      mail: json['email'] ?? '',
      password: json['password'] ?? '',
      age: json['edad'] ?? 0,
      isProfesor: json['isProfesor'] ?? false,
      isAlumno: json['isAlumno'] ?? false,
      isAdmin: json['isAdmin'] ?? true,
      conectado: json['conectado'] ?? false,
      lat: (json['location']?['coordinates'] != null && json['location']['coordinates'].isNotEmpty)
          ? json['location']['coordinates'][1] // Confirmar que [1] es latitud
          : 0.0,
      lng: (json['location']?['coordinates'] != null && json['location']['coordinates'].isNotEmpty)
          ? json['location']['coordinates'][0] // Confirmar que [0] es longitud
          : 0.0,
    );
  }


  // Método para convertir una instancia en un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': name,
      'email': mail,
      'password': password,
      'edad': age,
      'isProfesor': isProfesor,
      'isAlumno': isAlumno,
      'isAdmin': isAdmin,
      'conectado': conectado,
      'lat': lat,
      'lng': lng,
    };
  }
}
