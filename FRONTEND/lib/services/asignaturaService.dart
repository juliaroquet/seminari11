import 'package:dio/dio.dart';
import '../models/asignaturaModel.dart';

class AsignaturaService {
  final Dio dio = Dio();
  final String baseUrl = 'http://localhost:3000/api/usuarios';
  //final String baseUrl = 'http://10.0.2.2:3000/api/usuarios';


Future<List<AsignaturaModel>> getAsignaturasByUsuario(String userId) async {
  try {
    final String url = '$baseUrl/$userId/asignaturas';
    print('Realizando petición a: $url'); // Depuración
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final List data = response.data;
      print('Datos recibidos: $data'); // Verificar respuesta
      return data.map((e) => AsignaturaModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener las asignaturas: ${response.statusCode}');
    }
  } catch (e) {
    print('Error en la solicitud: $e'); // Mostrar el error
    throw Exception('Error en la solicitud: $e');
  }
}
}
