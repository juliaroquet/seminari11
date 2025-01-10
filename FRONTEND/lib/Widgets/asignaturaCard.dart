import 'package:flutter/material.dart';
import '../models/asignaturaModel.dart';

class AsignaturaCard extends StatelessWidget {
  final AsignaturaModel asignatura;

  const AsignaturaCard({Key? key, required this.asignatura}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              asignatura.nombre,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(asignatura.descripcion),
          ],
        ),
      ),
    );
  }
}
