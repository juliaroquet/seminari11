import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/user.dart';
import '../controllers/authController.dart';
import '../controllers/userModelController.dart';
import 'package:geolocator/geolocator.dart';

class UserController extends GetxController {
  final UserService userService = Get.put(UserService());
  final UserModelController userModelController = Get.find<UserModelController>();

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

    Future<void> logIn() async {
    if (mailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son obligatorios',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!GetUtils.isEmail(mailController.text)) {
      Get.snackbar('Error', 'Correo electrónico no válido',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permisos de ubicación denegados.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Permisos de ubicación denegados permanentemente. Habilítelos en la configuración.');
      }

      // Obtener las coordenadas del dispositivo con mayor precisión
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 10), // Aumenta el tiempo de espera
      );

      print("Coordenadas obtenidas: (${position.latitude}, ${position.longitude})");
      print("Precisión: ${position.accuracy} metros");

      final response = await userService.logIn({
        'email': mailController.text,
        'password': passwordController.text,
        'lat': position.latitude.toString(), // Coordenada de latitud
        'lng': position.longitude.toString(), // Coordenada de longitud
      });

      if (response.statusCode == 200) {
        final userId = response.data['usuario']['id'];
        final token = response.data['token'];

        // Almacenar userId y token en el AuthController
        final authController = Get.find<AuthController>();
        authController.setUserId(userId);
        authController.setToken(token);

        // Llamar a `setUser` en `UserModelController` con argumentos nombrados
        userModelController.setUser(
          id: response.data['usuario']['id'] ?? '0', // Asegurar que 'id' tenga un valor por defecto
          name: response.data['usuario']['nombre'] ?? 'Desconocido',
          mail: response.data['usuario']['email'] ?? 'No especificado',
          password: '', // No enviar la contraseña
          age: response.data['usuario']['edad'] ?? 0, // Valor predeterminado
          isProfesor: response.data['usuario']['isProfesor'] ?? false,
          isAlumno: response.data['usuario']['isAlumno'] ?? false,
          isAdmin: response.data['usuario']['isAdmin'] ?? false,
          conectado: true, // Establecer 'conectado' como 'true'
          lat: position.latitude, // Agregar coordenada de latitud
          lng: position.longitude, // Agregar coordenada de longitud
        );

        // Navegar al Home
        Get.offNamed('/home', arguments: {'userId': userId});
      } else {
        errorMessage.value =
            response.data['message'] ?? 'Credenciales incorrectas';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      errorMessage.value = 'Error al conectar con el servidor: $e';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
