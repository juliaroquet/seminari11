import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authController.dart';
import '../controllers/socketController.dart';
import '../controllers/theme_controller.dart'; // Importamos el controlador del tema
import 'package:intl/intl.dart'; // Para formatear la fecha

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatPage({Key? key, required this.receiverId, required this.receiverName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SocketController socketController = Get.find<SocketController>();
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _joinChat();
    _listenForMessages();
  }

  void _joinChat() {
    socketController.joinChat(authController.getUserId, widget.receiverId);
  }

  void _listenForMessages() {
    socketController.clearListeners('receive-message');
    socketController.socket.on('receive-message', (data) {
      if (data['receiverId'] == authController.getUserId ||
          data['senderId'] == authController.getUserId) {
        final isDuplicate = messages.any((msg) =>
            msg['senderId'] == data['senderId'] &&
            msg['messageContent'] == data['messageContent'] &&
            msg['timestamp'] == data['timestamp']);
        if (!isDuplicate) {
          setState(() {
            messages.add({
              'senderId': data['senderId'] ?? '',
              'senderName': data['senderId'] == authController.getUserId
                  ? "Tú"
                  : data['senderName'] ?? 'Anónimo',
              'messageContent': data['messageContent'] ?? '',
              'timestamp': DateTime.parse(data['timestamp']),
            });
          });
          _scrollToBottom();
        }
      }
    });
  }

  void _sendMessage() {
    final messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      final messageData = {
        'senderId': authController.getUserId,
        'senderName': "Tú",
        'messageContent': messageContent,
        'timestamp': DateTime.now(),
      };

      setState(() {
        messages.add(messageData);
      });

      socketController.sendMessage(
        authController.getUserId,
        widget.receiverId,
        messageContent,
        authController.getUserName,
      );

      messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    socketController.socket.emit('leave-chat', {
      'senderId': authController.getUserId,
      'receiverId': widget.receiverId,
    });
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Chat con ${widget.receiverName}'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.iconTheme.color,
            ),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['senderId'] == authController.getUserId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? (isDarkMode ? Colors.blueAccent[700] : Colors.blueAccent)
                          : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${message['senderName']} - ${_formatTimestamp(message['timestamp'])}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: isMe ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message['messageContent'] ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    backgroundColor: theme.primaryColor,
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
