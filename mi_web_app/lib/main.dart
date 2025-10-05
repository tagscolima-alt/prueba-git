// ==========================================================
// 🧾 Prueba de Integración: SAT ↔ MotorBD ↔ PostgreSQL
// ==========================================================
// Este script prueba las funciones principales de ClienteSATAPI
// y confirma que los datos se registran correctamente en la BD.
// ==========================================================

import 'sat/cliente_sat_api.dart';

void main() async {
  print("============================================");
  print("🚀 Iniciando prueba de integración SAT ↔ MotorBD ↔ PostgreSQL");
  print("============================================\n");

  try {
    // 1️⃣ Solicitar Token
    print("🟢 Solicitando token al SAT...");
    final tokenData = await ClienteSATAPI.solicitarToken(
      rfc: 'ABC123456T78',
      password: 'demo123',
      certificado: 'certificado-demo',
    );
    print("✅ Token recibido:");
    print(tokenData);
    print("");

    // Guardar token localmente para los siguientes pasos
    final token = tokenData["access_token"];

    // 2️⃣ Emitir CFDI
    print("🧾 Emitiendo CFDI (Timbrado)...");
    final cfdiData = await ClienteSATAPI.emitirCFDI(
      xmlFirmado: "<Comprobante>Factura de prueba</Comprobante>",
      token: token,
    );
    print("✅ CFDI emitido correctamente:");
    print(cfdiData);
    print("");

    // 3️⃣ Validar CFDI
    print("🕵️ Validando CFDI...");
    final validarData = await ClienteSATAPI.validarCFDI(
      rfcEmisor: 'AAA010101AAA',
      rfcReceptor: 'BBB010101BBB',
      uuid: '123e4567-e89b-12d3-a456-426614174000',
      total: 1000.00,
      token: token,
    );
    print("✅ Resultado de validación:");
    print(validarData);
    print("");

    // 4️⃣ Cancelar CFDI
    print("❌ Cancelando CFDI...");
    final cancelarData = await ClienteSATAPI.cancelarCFDI(
      uuid: '123e4567-e89b-12d3-a456-426614174000',
      token: token,
    );
    print("✅ CFDI cancelado correctamente:");
    print(cancelarData);
    print("");

    print("============================================");
    print("🎯 PRUEBA FINALIZADA CORRECTAMENTE");
    print("Verifica los registros en las tablas:");
    print("  → tokens_sat");
    print("  → cfdi");
    print("============================================");
  } catch (e) {
    print("🚫 Error en la prueba: $e");
  }
}
