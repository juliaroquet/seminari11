import 'package:get/get.dart';
import '../models/asignaturaModel.dart';
import '../services/asignaturaService.dart';

class AsignaturaController extends GetxController {
  final AsignaturaService asignaturaService = AsignaturaService();
  var asignaturas = <AsignaturaModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Método para cargar asignaturas de un usuario
    Future<void> fetchAsignaturas(String userId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
        print('Fetching asignaturas for userId: $userId'); // Depuración
        final asignaturasData = await asignaturaService.getAsignaturasByUsuario(userId);
        print('Asignaturas obtenidas: $asignaturasData'); // Verificar datos
        asignaturas.assignAll(asignaturasData);
    } catch (e) {
        print('Error al cargar asignaturas: $e'); // Mostrar el error
        errorMessage.value = 'Error al cargar las asignaturas: $e';
    } finally {
        isLoading.value = false;
    }
   }
}
