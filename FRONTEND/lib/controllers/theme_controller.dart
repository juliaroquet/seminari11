import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Control reactivo para el estado del tema
  var themeMode = ThemeMode.light.obs; // Iniciar con tema claro

  // Alternar entre los modos de tema
void toggleTheme() {
  themeMode.value = themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  print('Tema cambiado a: ${themeMode.value}');
}

  // Establecer el modo del tema según la configuración del sistema
  void setSystemTheme() {
    themeMode.value = ThemeMode.system;
  }
}
