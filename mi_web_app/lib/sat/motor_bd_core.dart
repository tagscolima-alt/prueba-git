import 'package:postgres/postgres.dart';

class MotorBDCore {
  static PostgreSQLConnection? _conexion;

  static Future<void> abrirConexion() async {
    if (_conexion == null || _conexion!.isClosed) {
      _conexion = PostgreSQLConnection(
        'localhost',
        5432,
        'erpsat', // ✅ usa tu base correcta
        username: 'postgres',
        password: '123456',
      );
      await _conexion!.open();
      print("✅ Conexión abierta con PostgreSQL");
    }
  }

  static Future<List<Map<String, dynamic>>> ejecutarSQL(
    String sql, [
    List<dynamic>? params,
  ]) async {
    await abrirConexion();
    final resultado = await _conexion!.mappedResultsQuery(
      sql,
      substitutionValues: _toParamMap(params),
    );
    return resultado.map((fila) => fila.values.first).toList();
  }

  static Map<String, dynamic> _toParamMap(List<dynamic>? params) {
    if (params == null) return {};
    return {for (var i = 0; i < params.length; i++) 'p$i': params[i]};
  }

  static Future<void> cerrarConexion() async {
    if (_conexion != null && !_conexion!.isClosed) {
      await _conexion!.close();
      print("🔒 Conexión cerrada con PostgreSQL");
    }
  }
}
