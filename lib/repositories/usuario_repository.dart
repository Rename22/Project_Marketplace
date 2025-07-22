import '../entities/usuario_entity.dart';
import '../settings/db_connection.dart';

class UsuarioRepository {
  static String tableName = 'usuarios';

  // Insertar un nuevo usuario
  static Future<int> insert(Usuario usuario) async {
    return await DbConnection.insert(tableName, usuario.toMap());
  }

  // Obtener usuario por credenciales
  static Future<Usuario?> getByCredentials(String usuario, String password) async {
    var result = await DbConnection.filter(
      tableName,
      'usuario = ? AND password = ?',
      [usuario, password],
    );
    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  // Actualizar usuario
  static Future<int> update(Usuario usuario) async {
    // Asegurarnos de que el usuario tiene un ID
    if (usuario.id == null) {
      throw Exception("El usuario no tiene ID");
    }
    return await DbConnection.update(
      tableName,
      usuario.toMap(),
      usuario.id!,
    );
  }

  // Eliminar usuario
  static Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Listar todos los usuarios
  static Future<List<Usuario>> list() async {
    var result = await DbConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Usuario.fromMap(result[index]),
      );
    }
  }

  // Obtener usuario por ID
  static Future<Usuario?> getById(int id) async {
    var result = await DbConnection.getById(tableName, id);
    if (result == null) {
      return null;
    } else {
      return Usuario.fromMap(result);
    }
  }

  // Obtener nombre del cliente
  static Future<String> getNombreCliente(int idCliente) async {
    final usuario = await getById(idCliente);
    if (usuario != null) {
      return usuario.nombre;
    } else {
      return 'Cliente no encontrado';
    }
  }

  // Nuevo método: Obtener usuarios por rol (para listado de vendedores)
  static Future<List<Usuario>> getByRol(String rol) async {
    try {
      final db = await DbConnection.database;
      final result = await db.query(
        tableName,
        where: 'rol = ?',
        whereArgs: [rol],
      );

      if (result.isEmpty) return [];

      return List.generate(
        result.length,
        (index) => Usuario.fromMap(result[index]),
      );
    } catch (e) {
      print('Error en UsuarioRepository.getByRol: $e');
      rethrow;
    }
  }

  // Nuevo método: Eliminar usuario por ID
  static Future<int> deleteById(int id) async {
    try {
      final db = await DbConnection.database;
      return await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error en UsuarioRepository.deleteById: $e');
      rethrow;
    }
  }

  // Nuevo método: Actualizar usuario (versión mejorada)
  static Future<int> updateUsuario(Usuario usuario) async {
    try {
      final db = await DbConnection.database;
      return await db.update(
        tableName,
        usuario.toMap(),
        where: 'id = ?',
        whereArgs: [usuario.id],
      );
    } catch (e) {
      print('Error en UsuarioRepository.updateUsuario: $e');
      rethrow;
    }
  }
}