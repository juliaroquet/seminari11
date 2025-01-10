import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../controllers/userListController.dart';
import '../controllers/userModelController.dart';
import '../controllers/theme_controller.dart'; // Asegúrate de tener el controlador del tema

class MapPage extends StatelessWidget {
  final UserListController userListController = Get.put(UserListController());
  final UserModelController userModelController = Get.find<UserModelController>();
  final ThemeController themeController = Get.find<ThemeController>(); // Controlador del tema

  @override
  Widget build(BuildContext context) {
    // Llamar a la función para obtener las coordenadas de los usuarios
    userListController.fetchUserCoordinates();

    // Determinar el tema actual
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Usuarios'),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue, // Color de fondo según el tema
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeController.toggleTheme(); // Alternar tema
            },
          ),
        ],
      ),
      body: Obx(() {
        if (userListController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userListController.userList.isEmpty) {
          return const Center(child: Text('No hay usuarios con coordenadas disponibles.'));
        }

        // Obtener las coordenadas del usuario logueado
        final userLoggedInLat = userModelController.user.value.lat;
        final userLoggedInLng = userModelController.user.value.lng;

        // Validar que el usuario logueado tiene coordenadas válidas
        if (userLoggedInLat == 0.0 || userLoggedInLng == 0.0) {
          return const Center(
            child: Text(
              'No se puede centrar el mapa porque las coordenadas del usuario no están disponibles.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        print("Centro del mapa: Lat: $userLoggedInLat, Lng: $userLoggedInLng");

        // Crear los marcadores para cada usuario
        final markers = userListController.userList.map((user) {
          final coordinates = user.lat != 0.0 && user.lng != 0.0
              ? LatLng(user.lat, user.lng)
              : null;

          if (coordinates != null) {
            print("Creando marcador para ${user.name} en (${user.lat}, ${user.lng})");
            return Marker(
              width: 100.0,
              height: 100.0,
              point: coordinates,
              builder: (ctx) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: isDarkMode ? Colors.blue : Colors.red, // Cambia el color del marcador según el tema
                    size: 40.0,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black, // Texto de los nombres según el tema
                    ),
                  ),
                ],
              ),
            );
          }
          return null;
        }).where((marker) => marker != null).toList();

        return FlutterMap(
          options: MapOptions(
            center: LatLng(userLoggedInLat, userLoggedInLng), // Centro dinámico
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              // Se pueden ajustar los colores de las capas según el tema, si fuera necesario
            ),
            MarkerLayer(markers: markers.cast<Marker>()),
          ],
        );
      }),
    );
  }
}
