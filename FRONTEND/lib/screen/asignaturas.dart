import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/asignaturaController.dart';
import '../Widgets/asignaturaCard.dart';
import '../controllers/theme_controller.dart'; // Importa el controlador del tema

class AsignaturasPage extends StatelessWidget {
  final AsignaturaController asignaturaController = Get.put(AsignaturaController());

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find(); // Encuentra el controlador del tema
    final String userId = Get.parameters['userId'] ?? ''; // Se espera pasar el `userId` como parámetro

    asignaturaController.fetchAsignaturas(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Asignaturas del Usuario'),
        actions: [
          IconButton(
            icon: Icon(
              themeController.themeMode.value == ThemeMode.dark
                  ? Icons.light_mode // Si el tema es oscuro, cambiar a claro
                  : Icons.dark_mode,  // Si el tema es claro, cambiar a oscuro
            ),
            onPressed: () {
              themeController.toggleTheme(); // Alternar entre temas
            },
          ),
        ],
      ),
      body: Obx(() {
        if (asignaturaController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (asignaturaController.errorMessage.isNotEmpty) {
          return Center(child: Text(asignaturaController.errorMessage.value));
        } else if (asignaturaController.asignaturas.isEmpty) {
          return Center(child: Text('No hay asignaturas disponibles.'));
        } else {
          return ListView.builder(
            itemCount: asignaturaController.asignaturas.length,
            itemBuilder: (context, index) {
              return AsignaturaCard(asignatura: asignaturaController.asignaturas[index]);
            },
          );
        }
      }),
    );
  }
}
