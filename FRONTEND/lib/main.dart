import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/bottomNavigationBar.dart';
import '../screen/logIn.dart';
import '../screen/register.dart';
import '../screen/user.dart';
import '../screen/home.dart';
import '../controllers/authController.dart';
import '../screen/perfil.dart';
import '../controllers/userListController.dart';
import '../controllers/userModelController.dart';
import '../controllers/connectedUsersController.dart';
import '../screen/chat.dart';
import '../controllers/socketController.dart';
import '../controllers/theme_controller.dart';
import '../controllers/localeController.dart'; // Asegúrate de tener el LocaleController
import '../screen/mapPage.dart';
import 'l10n.dart'; // Asegúrate de tener esta clase generada
import 'package:flutter_localizations/flutter_localizations.dart'; // Importa las localizaciones globales
import '../screen/upload_image_screen.dart'; // Asegúrate de importar la pantalla de subida

void main() {
  // Inicializa los controladores
  Get.put(AuthController());
  Get.put<UserListController>(UserListController());
  Get.put<UserModelController>(UserModelController());
  Get.put(ConnectedUsersController());
  Get.put(SocketController());
  Get.put(ThemeController()); // Registrar el controlador del tema
  Get.put(LocaleController()); // Registrar el controlador de locales

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find(); // Obtiene el controlador del tema
    final LocaleController localeController = Get.find(); // Obtiene el controlador de locales

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login', // Página de inicio
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ), // Tema claro
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1C1C1E),
          scaffoldBackgroundColor: const Color(0xFF1C1C1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2C2C2E),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ), // Tema oscuro
        themeMode: themeController.themeMode.value, // Controlador del tema reactivo
        getPages: [
          GetPage(
            name: '/login',
            page: () => LogInPage(),
          ),
          GetPage(
            name: '/register',
            page: () => RegisterPage(),
          ),
          GetPage(
            name: '/home',
            page: () => HomeScreen(),
          ),
          GetPage(
            name: '/usuarios',
            page: () => BottomNavScaffold(
              child: UserPage(),
            ),
          ),
          GetPage(
            name: '/perfil',
            page: () => PerfilPage(),
          ),
          GetPage(
            name: '/chat',
            page: () => ChatPage(
              receiverId: Get.arguments['receiverId'],
              receiverName: Get.arguments['receiverName'],
            ),
          ),
          GetPage(
            name: '/map',
            page: () => MapPage(),
          ),
          // Nueva ruta para la pantalla de subida de imágenes
          GetPage(
            name: '/uploadImage',
            page: () => UploadImageScreen(),
          ),
        ],

        localizationsDelegates: [
          AppLocalizations.delegate, // Delegado de traducciones generado por Flutter
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // Inglés
          const Locale('es', ''), // Español
        ],
        locale: localeController.currentLocale.value, // Controlador para el idioma actual
      );
    });
  }
}
