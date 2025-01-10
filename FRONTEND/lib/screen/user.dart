import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/user.dart';
import '../controllers/userListController.dart';
import '../controllers/asignaturaController.dart';
import '../Widgets/userCard.dart';
import '../Widgets/asignaturaCard.dart';
import '../controllers/theme_controller.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserService _userService = UserService();
  final UserListController userController = Get.put(UserListController());
  final AsignaturaController asignaturaController = Get.put(AsignaturaController());
  final ThemeController themeController = Get.find<ThemeController>();

  late String userId;

  @override
  void initState() {
    super.initState();

    // Obtener el userId desde los argumentos pasados al navegar a esta pantalla
    userId = Get.arguments?['userId'] ?? '';

    if (userId.isNotEmpty) {
      asignaturaController.fetchAsignaturas(userId);
    } else {
      print("Error: No se proporcionó un userId válido");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeController.themeMode.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.iconTheme.color,
            ),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Listado de usuarios (lado izquierdo)
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userController.userList.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay usuarios disponibles",
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                } else {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: userController.userList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: UserCard(user: userController.userList[index]),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
            const SizedBox(width: 20),
            // Lista de asignaturas del usuario logueado (lado derecho)
            Expanded(
              flex: 2,
              child: Obx(() {
                if (asignaturaController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asignaturaController.asignaturas.isEmpty) {
                  return Center(
                    child: Text(
                      "No tienes asignaturas asignadas",
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                } else {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mis Asignaturas',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: asignaturaController.asignaturas.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: AsignaturaCard(
                                    asignatura: asignaturaController.asignaturas[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
