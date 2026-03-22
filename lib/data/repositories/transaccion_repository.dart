import '../../core/database/database_helper.dart';
import '../models/transaccion_model.dart';

class TransaccionRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  static const String _table = 'transaccion';

  Future<int> insertar(TransaccionModel transaccion) async {
    return await _db.insert(_table, transaccion.toMap());
  }

  Future<List<TransaccionModel>> obtenerTodos() async {
    final results = await _db.queryAll(_table);
    return results.map((map) => TransaccionModel.fromMap(map)).toList();
  }

  Future<TransaccionModel?> obtenerPorId(int id) async {
    final result = await _db.queryById(_table, id);
    if (result != null) {
      return TransaccionModel.fromMap(result);
    }
    return null;
  }

  Future<List<TransaccionModel>> obtenerPorCuenta(int cuentaId) async {
    final results = await _db.queryByFieldOrdered(
      _table,
      'cuenta_id',
      cuentaId,
      'fecha DESC',
      null,
    );
    return results.map((map) => TransaccionModel.fromMap(map)).toList();
  }

  Future<List<TransaccionModel>> obtenerUltimas(int limit) async {
    final db = await _db.database;
    final results = await db.query(
      _table,
      orderBy: 'fecha DESC',
      limit: limit,
    );
    return results.map((map) => TransaccionModel.fromMap(map)).toList();
  }

  Future<int> actualizarEstado(int transaccionId, EstadoTransaccion estado) async {
    return await _db.updateByField(
      _table,
      {'estado': estado.name},
      'id',
      transaccionId,
    );
  }

  Future<int> eliminar(int id) async {
    return await _db.delete(_table, id);
  }
}
