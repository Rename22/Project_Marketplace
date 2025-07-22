import '../entities/pedido_entity.dart';
import '../settings/db_connection.dart';

class PedidoRepository {
  static String tableName = 'pedidos';

  static Future<int> insert(Pedido pedido) async {
    final id = await DbConnection.insert(tableName, pedido.toMap());
    return id;
  }

  static Future<int> update(Pedido pedido) async {
    return await DbConnection.update(
      tableName,
      pedido.toMap(),
      pedido.id!,
    );
  }

  static Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  static Future<List<Pedido>> list() async {
    try {
      final db = await DbConnection.database;
      final result = await db.query(tableName);
      
      if (result.isEmpty) return [];
      
      return List.generate(
        result.length,
        (index) => Pedido.fromMap(result[index]),
      );
    } catch (e) {
      print('Error en PedidoRepository.list: $e');
      rethrow;
    }
  }

  static Future<Pedido?> getById(int id) async {
    try {
      final result = await DbConnection.getById(tableName, id);
      return result != null ? Pedido.fromMap(result) : null;
    } catch (e) {
      print('Error en PedidoRepository.getById: $e');
      rethrow;
    }
  }
  static Future<List<Pedido>> listByGetNombre(String nombre) async {
    try {
      final db = await DbConnection.database;
      final result = await db.query(tableName,
          where: 'nombre = ?', whereArgs: [nombre]);
      if (result.isEmpty) return [];
      return List.generate(result.length, (index) => Pedido.fromMap(result[index]));
    } catch (e) {
      print('Error en PedidoRepository.listByGetNombre: $e');
      rethrow;
    }
  }

  static Future<List<Pedido>> getByClienteId(int clienteId) async {
    try {
      final db = await DbConnection.database;
      final result = await db.query(
        tableName,
        where: 'fk_id_cliente = ?',
        whereArgs: [clienteId],
      );
      
      if (result.isEmpty) return [];
      
      return List.generate(
        result.length,
        (index) => Pedido.fromMap(result[index]),
      );
    } catch (e) {
      print('Error en PedidoRepository.getByClienteId: $e');
      rethrow;
    }
  }
}