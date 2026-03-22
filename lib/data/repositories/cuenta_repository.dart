import '../../core/database/database_helper.dart';
import '../models/cuenta_model.dart';

class CuentaRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  static const String _table = 'cuenta';

  Future<int> insertar(CuentaModel cuenta) async {
    return await _db.insert(_table, cuenta.toMap());
  }

  Future<List<CuentaModel>> obtenerTodos() async {
    final results = await _db.queryAll(_table);
    return results.map((map) => CuentaModel.fromMap(map)).toList();
  }

  Future<CuentaModel?> obtenerPorId(int id) async {
    final result = await _db.queryById(_table, id);
    if (result != null) {
      return CuentaModel.fromMap(result);
    }
    return null;
  }

  Future<List<CuentaModel>> obtenerPorUsuario(int usuarioId) async {
    final results = await _db.queryByField(_table, 'usuario_id', usuarioId);
    return results.map((map) => CuentaModel.fromMap(map)).toList();
  }

  Future<int> actualizar(CuentaModel cuenta) async {
    if (cuenta.id == null) {
      throw Exception('No se puede actualizar una cuenta sin id');
    }
    return await _db.update(_table, cuenta.toMap(), cuenta.id!);
  }

  Future<int> actualizarSaldo(int cuentaId, double nuevoSaldo) async {
    return await _db.updateByField(
      _table,
      {'saldo': nuevoSaldo},
      'id',
      cuentaId,
    );
  }

  Future<int> eliminar(int id) async {
    return await _db.delete(_table, id);
  }
}
