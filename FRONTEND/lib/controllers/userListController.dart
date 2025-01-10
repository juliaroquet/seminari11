import 'package:get/get.dart';
import '../models/userModel.dart';
import '../services/user.dart';

class UserListController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs;
  var searchResults = <UserModel>[].obs; // Propiedad para resultados de búsqueda
  final UserService userService = UserService();

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      var users = await userService.getUsers();
      if (users != null) {
        userList.assignAll(users);
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchUsers(String nombre, String token) async {
    try {
      isLoading(true);
      final users = await userService.searchUsers(nombre, token);
      searchResults.assignAll(users);
    } catch (e) {
      print('Error al buscar usuarios: $e');
      searchResults.clear();
    } finally {
      isLoading(false);
    }
  }

  void handleWebSocketUpdates(List<String> connectedUsers) {
    for (var user in userList) {
      user.conectado = connectedUsers.contains(user.id);
    }
    userList.refresh(); // Asegúrate de refrescar la lista
  }

  Future<void> fetchUserCoordinates() async {
    try {
      isLoading(true);
      final response = await userService.getUserCoordinates();
      print('Datos recibidos desde el backend: $response'); // Debug
      userList.assignAll(response);
    } catch (e) {
      print('Error al obtener coordenadas: $e');
    } finally {
      isLoading(false);
    }
  }
}
