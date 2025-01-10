import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  // Controlador para mantener el idioma actual
  var currentLocale = Locale('es').obs; // El idioma inicial será español (es)

  // Método para cambiar el idioma
  void changeLanguage(String languageCode) {
    var locale = Locale(languageCode); // Crea un objeto Locale con el código de idioma
    currentLocale.value = locale; // Actualiza el idioma
    Get.updateLocale(locale); // Aplica el cambio de idioma globalmente
  }
}
