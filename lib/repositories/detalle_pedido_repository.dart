import '../entities/detalle_pedido_entity.dart';
import '../settings/db_connection.dart';

class DetallePedidoRepository {
  static String tableName = 'detalle_pedido';

  // Insertar un nuevo detalle de pedido
  static Future<int> insert(DetallePedido detallePedido) async {
    return await DbConnection.insert(tableName, detallePedido.toMap());
  }

  // Actualizar un detalle de pedido existente
  static Future<int> update(DetallePedido detallePedido) async {
    return await DbConnection.update(
      tableName,
      detallePedido.toMap(),
      detallePedido.id as int,
    );
  }

  // Eliminar un detalle de pedido
  static Future<int> delete(DetallePedido detallePedido) async {
    return await DbConnection.delete(tableName, detallePedido.id as int);
  }

  // Listar todos los detalles de pedido
  static Future<List<DetallePedido>> list() async {
    var result = await DbConnection.list(tableName);
    if (result.isEmpty) {
      return [];
    } else {
      return List.generate(
        result.length,
        (index) => DetallePedido.fromMap(result[index]),
      );
    }
  }

  // Obtener detalles de pedido por ID de pedido
  static Future<List<DetallePedido>> getByPedidoId(int pedidoId) async {
    try {
      final db = await DbConnection.database;
      final List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: 'fk_id_pedido = ?',
        whereArgs: [pedidoId],
      );

      if (result.isEmpty) {
        return [];
      }

      return List.generate(
        result.length,
        (index) => DetallePedido.fromMap(result[index]),
      );
    } catch (e) {
      print('Error en getByPedidoId: $e');
      return [];
    }
  }
}
