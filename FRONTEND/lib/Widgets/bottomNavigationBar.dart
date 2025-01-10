import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authController.dart'; // Importa el controlador

class BottomNavScaffold extends StatelessWidget {
  final Widget child;
  static final RxInt selectedIndex = 0.obs; // Variable estática para mantener el estado

  const BottomNavScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex.value,
          onTap: (index) {
            // Cambiar solo si el índice es diferente
            if (selectedIndex.value != index) {
              selectedIndex.value = index;

              switch (index) {
                case 0:
                  Get.offNamed('/home'); // Navega al Home
                  break;
                case 1:
                  Get.offNamed(
                    '/usuarios',
                    arguments: {'userId': authController.userId.value}, // Usa el userId
                  );
                  break;
              }
            }
          },
          selectedItemColor: const Color.fromARGB(255, 92, 14, 105),
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Usuarios',
            ),
          ],
        ),
      );
    });
  }
}
