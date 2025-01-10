import 'package:get/get.dart';

class ConnectedUsersController extends GetxController {
  var connectedUsers = <String>[].obs;

  void updateConnectedUsers(List<String> users) {
    connectedUsers.assignAll(users);
    print('Usuarios conectados actualizados: $connectedUsers');
  }
}
