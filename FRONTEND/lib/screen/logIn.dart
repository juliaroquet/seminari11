import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';
import '../controllers/authController.dart';
import '../controllers/theme_controller.dart';
import '../controllers/localeController.dart';  // Agregar controlador de idioma
import '../l10n.dart';  // Asegúrate de tener esta clase que contiene las traducciones

class LogInPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final LocaleController localeController = Get.find<LocaleController>(); // Controlador de idioma

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('login') ?? 'Iniciar Sesión'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeController.themeMode.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: themeController.toggleTheme,
          ),
          // Botón para cambiar de idioma
          IconButton(
            icon: Icon(Icons.language, color: theme.textTheme.bodyLarge?.color),
            onPressed: () {
              // Cambia el idioma entre inglés y español
              if (localeController.currentLocale.value.languageCode == 'es') {
                localeController.changeLanguage('en');
              } else {
                localeController.changeLanguage('es');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: themeController.themeMode.value == ThemeMode.dark
                        ? [const Color(0xFF6366F1), const Color(0xFF3B82F6)]
                        : [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.lock,
                  size: 50,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Correo electrónico
            _buildTextField(
              controller: userController.mailController,
              label: AppLocalizations.of(context)?.translate('email') ?? 'Correo Electrónico',
              icon: Icons.email,
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Contraseña
            _buildTextField(
              controller: userController.passwordController,
              label: AppLocalizations.of(context)?.translate('password') ?? 'Contraseña',
              icon: Icons.lock,
              obscureText: true,
              theme: theme,
            ),
            const SizedBox(height: 24),

            // Botón de inicio de sesión
            Obx(() {
              if (userController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ElevatedButton(
                  onPressed: userController.logIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.translate('loginButton') ?? 'Iniciar Sesión',
                    style: theme.textTheme.labelLarge,
                  ),
                );
              }
            }),
            const SizedBox(height: 16),

            // Mensaje de error
            Obx(() {
              if (userController.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    userController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            const SizedBox(height: 16),

            // Botón para registrarse
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: Text(
                  AppLocalizations.of(context)?.translate('noAccount') ?? '¿No tienes cuenta? Regístrate',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeController.themeMode.value == ThemeMode.dark
                        ? Colors.lightBlueAccent
                        : theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.iconTheme.color),
        labelStyle: theme.textTheme.bodyMedium,
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
      ),
    );
  }
}
