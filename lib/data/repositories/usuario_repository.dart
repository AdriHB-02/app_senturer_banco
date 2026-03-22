import '../../core/database/database_helper.dart';
import '../models/usuario_model.dart';

class UsuarioRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  static const String _table = 'usuario';

  Future<int> insertar(UsuarioModel usuario) async {
    return await _db.insert(_table, usuario.toMap());
  }

  Future<List<UsuarioModel>> obtenerTodos() async {
    final results = await _db.queryAll(_table);
    return results.map((map) => UsuarioModel.fromMap(map)).toList();
  }

  Future<UsuarioModel?> obtenerPorId(int id) async {
    final result = await _db.queryById(_table, id);
    if (result != null) {
      return UsuarioModel.fromMap(result);
    }
    return null;
  }

  Future<UsuarioModel?> obtenerPorEmail(String email) async {
    final results = await _db.queryByField(_table, 'email', email);
    if (results.isNotEmpty) {
      return UsuarioModel.fromMap(results.first);
    }
    return null;
  }

  Future<int> actualizar(UsuarioModel usuario) async {
    if (usuario.id == null) {
      throw Exception('No se puede actualizar un usuario sin id');
    }
    return await _db.update(_table, usuario.toMap(), usuario.id!);
  }

  Future<int> eliminar(int id) async {
    return await _db.delete(_table, id);
  }
}
