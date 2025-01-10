import 'dart:html' as html; // Para Web
import 'dart:convert'; // Para codificar en base64
import 'dart:async'; // Para Completer

class ImagePickerHelper {
  // Método para seleccionar una imagen y convertirla a base64
  Future<String?> pickImage() async {
    // Usar FileUploadInputElement para la Web
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    final completer = Completer<String?>();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]); // Leer como base64
        reader.onLoadEnd.listen((event) {
          completer.complete(reader.result as String?); // Devolver base64
        });
      } else {
        completer.complete(null);
      }
    });

    return await completer.future;
  }
}
