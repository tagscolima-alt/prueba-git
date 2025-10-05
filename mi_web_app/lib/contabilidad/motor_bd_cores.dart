// lib/contabilidad/motor_bd_core.dart
import 'package:postgres/postgres.dart';

class MotorBDCore {
  static PostgreSQLConnection? _conexion;

  // 🔹 Abre la conexión si no está abierta
  static Future<void> abrirConexion() async {
    _conexion ??= PostgreSQLConnection(
      'localhost', // ⚙️ Cambia según tu configuración
      5432,
      'erpsat',
      username: 'postgres',
      password: '123456',
    );
    if (_conexion!.isClosed) {
      await _conexion!.open();
      print("✅ Conexión abierta con PostgreSQL");
    }
  }

  // 🔹 Ejecuta una consulta SQL (SELECT / INSERT / UPDATE / DELETE)
  static Future<List<Map<String, dynamic>>> ejecutarSQL(
    String sql, [
    List<dynamic>? params,
  ]) async {
    await abrirConexion();
    try {
      final resultado = await _conexion!.mappedResultsQuery(
        sql,
        substitutionValues: _toParamMap(params),
      );
      return resultado.map((fila) => fila.values.first).toList();
    } catch (e) {
      print("❌ Error al ejecutar SQL: $e");
      rethrow;
    }
  }

  // 🔹 Convierte lista de parámetros a mapa nombrado
  static Map<String, dynamic> _toParamMap(List<dynamic>? params) {
    if (params == null) return {};
    return {for (var i = 0; i < params.length; i++) 'p$i': params[i]};
  }

  // 🔹 Manejo de transacciones
  static Future<void> manejarTransaccion(Future<void> Function() operacion) async {
    await abrirConexion();
    await _conexion!.transaction((ctx) async {
      await operacion();
    });
  }

  // 🔹 Cierra la conexión
  static Future<void> cerrarConexion() async {
    await _conexion?.close();
    _conexion = null;
    print("🔒 Conexión cerrada con PostgreSQL");
  }
}
