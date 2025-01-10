import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html; // Importación para interacción web
import '../controllers/userListController.dart';
import '../controllers/authController.dart';
import '../controllers/connectedUsersController.dart';
import '../controllers/socketController.dart';
import '../controllers/theme_controller.dart';
import '../helpers/image_picker_helper.dart';
import '../services/cloudinary_service.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final SocketController socketController = Get.find<SocketController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final userController = Get.find<UserListController>();
  final authController = Get.find<AuthController>();
  final connectedUsersController = Get.find<ConnectedUsersController>();
  final ImagePickerHelper _imagePicker = ImagePickerHelper();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImageUrl();
  }

  Future<void> _loadProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImageUrl = prefs.getString('profileImageUrl');
    });
  }

  Future<void> _saveProfileImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImageUrl', url);
  }

  Future<void> _selectAndUploadProfileImage() async {
    final imageBase64 = await _imagePicker.pickImage();
    if (imageBase64 != null) {
      String? imageUrl = await _cloudinaryService.uploadImage(imageBase64);
      if (imageUrl != null) {
        setState(() {
          _profileImageUrl = imageUrl;
        });
        _saveProfileImageUrl(imageUrl);
      } else {
        Get.snackbar('Error', 'No se pudo subir la imagen.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _selectAndUploadProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: theme.iconTheme.color,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _selectAndUploadProfileImage,
                  child: const Text('Cambiar Foto de Perfil'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Usuarios',
                labelStyle: theme.textTheme.bodyLarge,
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              ),
              style: theme.textTheme.bodyLarge,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  userController.searchUsers(value, authController.getToken);
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (userController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userController.searchResults.isEmpty) {
                return Center(
                  child: Text(
                    'No se encontraron usuarios.',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: userController.searchResults.length,
                itemBuilder: (context, index) {
                  final user = userController.searchResults[index];
                  final isConnected = connectedUsersController.connectedUsers.contains(user.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isConnected ? Colors.green : Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user.mail,
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Icon(
                        Icons.chat,
                        color: theme.colorScheme.secondary, // Color dinámico según el tema
                      ),
                      onTap: () {
                        Get.to(() => ChatPage(
                              receiverId: user.id,
                              receiverName: user.name,
                            ));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
