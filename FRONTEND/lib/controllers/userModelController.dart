import 'package:get/get.dart';
import '../models/userModel.dart';

class UserModelController extends GetxController {
  final user = UserModel(
    id: '0', // ID predeterminado
    name: 'Usuario desconocido',
    mail: 'No especificado',
    password: 'Sin contraseña',
    age: 0, // Agregado: valor predeterminado para `age`
    isProfesor: false,
    isAlumno: false,
    isAdmin: false,
  ).obs;

  // Método para actualizar los datos del usuario
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
    double? lat, // Opcional
    double? lng, // Opcional
  }) {
    user.update((val) {
      if (val != null) {
        val.setUser(
          id: id.isNotEmpty ? id : '0', // Asegurar que id nunca sea nulo
          name: name.isNotEmpty ? name : 'Usuario desconocido', // Valor predeterminado
          mail: mail.isNotEmpty ? mail : 'No especificado', // Valor predeterminado
          password: password, // Contraseña vacía está bien
          age: age > 0 ? age : 0, // Si edad no está presente, usar 0
          isProfesor: isProfesor,
          isAlumno: isAlumno,
          isAdmin: isAdmin,
          conectado: conectado,
          lat: lat, // Nuevas coordenadas, si están presentes
          lng: lng, // Nuevas coordenadas, si están presentes
        );
      }
    });
  }
}
