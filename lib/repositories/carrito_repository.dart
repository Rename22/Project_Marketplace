import '../entities/carrito_entity.dart';
import '../settings/db_connection.dart';
import 'producto_repository.dart';

class CarritoRepository {
  static String tableName = 'carrito';

  static Future<int> insert(CarritoItem item) async {
    return await DbConnection.insert(tableName, item.toMap());
  }

  static Future<int> update(CarritoItem item) async {
    return await DbConnection.update(tableName, item.toMap(), item.id!);
  }

  static Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  static Future<List<CarritoItem>> list(int userId) async {
    try {
      final db = await DbConnection.database;
      final result = await db.query(
        tableName,
        where: 'id_usuario = ?',
        whereArgs: [userId],
      );

      if (result.isEmpty) return [];

      // Obtener los productos completos
      final items = <CarritoItem>[];
      for (var map in result) {
        final producto = await ProductoRepository.getById(map['id_producto'] as int);
        if (producto != null) {
          items.add(CarritoItem.fromMap(map, producto));
        }
      }
      return items;
    } catch (e) {
      print('Error en CarritoRepository.list: $e');
      rethrow;
    }
  }

  static Future<CarritoItem?> getByProductId(int productoId, int userId) async {
    try {
      final db = await DbConnection.database;
      final result = await db.query(
        tableName,
        where: 'id_producto = ? AND id_usuario = ?',
        whereArgs: [productoId, userId],
        limit: 1,
      );

      if (result.isEmpty) return null;
      
      final producto = await ProductoRepository.getById(productoId);
      return producto != null 
          ? CarritoItem.fromMap(result.first, producto)
          : null;
    } catch (e) {
      print('Error en CarritoRepository.getByProductId: $e');
      rethrow;
    }
  }

  static Future<int> deleteByUserId(int userId) async {
    try {
      final db = await DbConnection.database;
      return await db.delete(
        tableName,
        where: 'id_usuario = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Error en CarritoRepository.deleteByUserId: $e');
      rethrow;
    }
  }
}