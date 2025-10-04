// lib/contabilidad/registro_ingresos_api.dart
import 'motor_bd_api.dart';

class RegistroIngresosAPI {
  static Future<void> registrarIngreso(Map<String, dynamic> ingreso) async {
    await MotorBDAPI.insert('ingresos', ingreso);
  }

  static Future<List<Map<String, dynamic>>> obtenerIngresos({String? filtro}) async {
    return await MotorBDAPI.query('ingresos', filtro: filtro);
  }

  static Future<void> actualizarIngreso(
    int id,
    Map<String, dynamic> nuevosDatos,
  ) async {
    await MotorBDAPI.update('ingresos', nuevosDatos, "id = $id");
  }

  static Future<void> eliminarIngreso(int id) async {
    await MotorBDAPI.delete('ingresos', "id = $id");
  }
}
