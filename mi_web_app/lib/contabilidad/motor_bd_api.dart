// lib/contabilidad/motor_bd_api.dart
import 'motor_bd_cores.dart';

class MotorBDAPI {
  // 🔹 Inserta un registro en una tabla
  static Future<void> insert(String tabla, Map<String, dynamic> datos) async {
    final campos = datos.keys.join(',');
    final placeholders = List.filled(datos.length, '?').join(',');
    final sql = 'INSERT INTO $tabla ($campos) VALUES ($placeholders)';
    await MotorBDCore.ejecutarSQL(sql, datos.values.toList());
  }

  // 🔹 Actualiza registros
  static Future<void> update(String tabla, Map<String, dynamic> datos, String filtro) async {
    final set = datos.keys.map((k) => "$k = ?").join(',');
    final sql = 'UPDATE $tabla SET $set WHERE $filtro';
    await MotorBDCore.ejecutarSQL(sql, datos.values.toList());
  }

  // 🔹 Elimina registros
  static Future<void> delete(String tabla, String filtro) async {
    final sql = 'DELETE FROM $tabla WHERE $filtro';
    await MotorBDCore.ejecutarSQL(sql);
  }

  // 🔹 Consulta registros
  static Future<List<Map<String, dynamic>>> query(
    String tabla, {
    String? filtro,
  }) async {
    final sql =
        filtro == null ? 'SELECT * FROM $tabla' : 'SELECT * FROM $tabla WHERE $filtro';
    return await MotorBDCore.ejecutarSQL(sql);
  }
}
