import 'package:sqflite/sqflite.dart';

class MigrationV1Initial {
  MigrationV1Initial._();

  static Future<void> execute(Database db) async {
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telefono TEXT,
        fecha_registro TEXT NOT NULL,
        activo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE cuenta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        numero_cuenta TEXT NOT NULL UNIQUE,
        tipo TEXT NOT NULL CHECK(tipo IN ('ahorro', 'corriente', 'digital')),
        saldo REAL NOT NULL DEFAULT 0.0,
        moneda TEXT NOT NULL DEFAULT 'USD',
        fecha_apertura TEXT NOT NULL,
        activa INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE transaccion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cuenta_id INTEGER NOT NULL,
        tipo TEXT NOT NULL CHECK(tipo IN ('deposito', 'retiro', 'transferencia')),
        monto REAL NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        estado TEXT NOT NULL DEFAULT 'completada' CHECK(estado IN ('pendiente', 'completada', 'fallida')),
        FOREIGN KEY (cuenta_id) REFERENCES cuenta(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_cuenta_usuario ON cuenta(usuario_id)');
    await db.execute('CREATE INDEX idx_transaccion_cuenta ON transaccion(cuenta_id)');
    await db.execute('CREATE INDEX idx_transaccion_fecha ON transaccion(fecha DESC)');

    await _insertSeedData(db);
  }

  static Future<void> _insertSeedData(Database db) async {
    final now = DateTime.now().toIso8601String();
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2)).toIso8601String();
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3)).toIso8601String();
    final fourDaysAgo = DateTime.now().subtract(const Duration(days: 4)).toIso8601String();

    await db.insert('usuario', {
      'nombre': 'Usuario Demo',
      'email': 'demo@senturer.com',
      'telefono': '+1234567890',
      'fecha_registro': now,
      'activo': 1,
    });

    await db.insert('cuenta', {
      'usuario_id': 1,
      'numero_cuenta': 'SAV-001-2026',
      'tipo': 'ahorro',
      'saldo': 5000.00,
      'moneda': 'USD',
      'fecha_apertura': now,
      'activa': 1,
    });

    await db.insert('cuenta', {
      'usuario_id': 1,
      'numero_cuenta': 'DGT-002-2026',
      'tipo': 'digital',
      'saldo': 1250.50,
      'moneda': 'USD',
      'fecha_apertura': now,
      'activa': 1,
    });

    await db.insert('transaccion', {
      'cuenta_id': 1,
      'tipo': 'deposito',
      'monto': 500.00,
      'descripcion': 'Aporte mensual',
      'fecha': now,
      'estado': 'completada',
    });

    await db.insert('transaccion', {
      'cuenta_id': 2,
      'tipo': 'transferencia',
      'monto': 200.00,
      'descripcion': 'Pago servicio',
      'fecha': yesterday,
      'estado': 'completada',
    });

    await db.insert('transaccion', {
      'cuenta_id': 1,
      'tipo': 'retiro',
      'monto': 150.00,
      'descripcion': 'ATM Centro',
      'fecha': twoDaysAgo,
      'estado': 'completada',
    });

    await db.insert('transaccion', {
      'cuenta_id': 2,
      'tipo': 'deposito',
      'monto': 1000.00,
      'descripcion': 'Transferencia recibida',
      'fecha': threeDaysAgo,
      'estado': 'completada',
    });

    await db.insert('transaccion', {
      'cuenta_id': 1,
      'tipo': 'transferencia',
      'monto': 75.50,
      'descripcion': 'Suscripción',
      'fecha': fourDaysAgo,
      'estado': 'completada',
    });
  }
}
