import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../controllers/authController.dart';

class SocketController extends GetxController {
  late IO.Socket socket;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  void _initializeSocket() {
    if (Get.isRegistered<IO.Socket>()) {
      socket = Get.find<IO.Socket>();
    } else {
      socket = IO.io(
        'http://localhost:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect() // No conectar automáticamente
            .setExtraHeaders({'auth-token': authController.getToken}) // Añade el token en las cabeceras
            .build(),
      );
      Get.put(socket);
    }
  }

  void connectSocket(String userId) {
    if (!socket.connected) {
      socket.connect();
    }

    socket.onConnect((_) {
      print('Conectado al servidor WebSocket');
      if (userId.isNotEmpty) {
        socket.emit('user-connected', {
          'userId': userId,
          'auth-token': authController.getToken, // Enviar token al conectar
        });
      }
    });

    socket.on('update-user-status', (data) {
      print('Actualización del estado de usuarios: $data');
    });

    socket.onDisconnect((_) {
      print('Desconectado del servidor WebSocket');
    });

    socket.onError((error) {
      print('Error en el socket: $error');
    });
  }

  void disconnectUser(String userId) {
    if (userId.isNotEmpty) {
      socket.emit('user-disconnected', {
        'userId': userId,
        'auth-token': authController.getToken, // Enviar token al desconectar
      });
      clearListeners('update-user-status');
      socket.disconnect();
      print('Usuario desconectado manualmente.');
    }
  }

  void joinChat(String senderId, String receiverId) {
    socket.emit('join-chat', {
      'senderId': senderId,
      'receiverId': receiverId,
      'auth-token': authController.getToken, // Enviar token en el chat
    });
  }

  void sendMessage(String senderId, String receiverId, String messageContent, String senderName) {
    socket.emit('private-message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageContent': messageContent,
      'senderName': senderName, // Añadir el nombre del usuario
      'timestamp': DateTime.now().toIso8601String(),
      'auth-token': authController.getToken, // Enviar token al enviar mensajes
    });
  }

  void clearListeners(String eventName) {
    socket.off(eventName);
  }
}
