import 'dart:convert'; // Para codificar base64
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = 'dviuh1d1h'; // Tu cloud name
  final String uploadPreset = 'teachme'; // Tu upload preset

  /// Subir una imagen desde base64 a Cloudinary
  Future<String?> uploadImage(String imageBase64) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    // Eliminar cualquier prefijo base64: "data:image/jpeg;base64," si se está incluyendo
    // Solo enviamos la cadena base64
    final body = {
      'file': imageBase64, // Solo la cadena base64
      'upload_preset': uploadPreset,
    };

    // Enviar la solicitud POST
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    // Verificar la respuesta
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['secure_url']; // Retornar la URL de la imagen subida
      
    } else {
      print('Error al subir la imagen: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      return null;
    }
  }
}


