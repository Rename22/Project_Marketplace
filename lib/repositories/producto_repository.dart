import '../entities/producto_entity.dart';
import '../settings/db_connection.dart';

class ProductoRepository {
  static String tableName = 'productos';

  static Future<int> insert(Producto producto) async {
    return await DbConnection.insert(tableName, producto.toMap());
  }

  static Future<int> update(Producto producto) async {
    return await DbConnection.update(tableName, producto.toMap(), producto.id!);
  }

  static Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  static Future<List<Producto>> list() async {
    var result = await DbConnection.list(tableName);
    if (result.isEmpty) {
      return [];
    }
    return result.map((map) => Producto.fromMap(map)).toList();
  }

  static Future<Producto?> getById(int id) async {
    var result = await DbConnection.getById(tableName, id);
    if (result == null) {
      return null;
    }
    return Producto.fromMap(result);
  }
   // Obtener el nombre de un producto por su ID
  static Future<String> getNombreProducto(int idProducto) async {
    final producto = await getById(idProducto);
    if (producto != null) {
      return producto.nombre;
    } else {
      return 'Cliente no encontrado';
    }
  }
  
}