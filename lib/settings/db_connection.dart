import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class DbConnection {
  static const version = 1; 
  static const dbName = 'marketplace.db';
  static Database? _database;
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), dbName);
    
    return await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        // Crear tabla de usuarios
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            nombre TEXT NOT NULL,
            email TEXT NOT NULL,
            telefono TEXT,
            rol TEXT NOT NULL
          )
        ''');

        // Crear tabla de productos
        await db.execute('''
          CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT,
            precio REAL NOT NULL,
            stock INTEGER DEFAULT 0,
            imagen TEXT
          )
        ''');

        // Crear tabla de pedidos
        await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha TEXT DEFAULT CURRENT_TIMESTAMP,
            estado TEXT DEFAULT 'pendiente',
            fk_id_cliente INTEGER NOT NULL,
            FOREIGN KEY(fk_id_cliente) REFERENCES usuarios(id)
          )
        ''');

        // Crear tabla de detalle_pedido
        await db.execute('''
          CREATE TABLE detalle_pedido (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cantidad INTEGER NOT NULL,
            subtotal REAL NOT NULL,
            fk_id_producto INTEGER NOT NULL,
            fk_id_pedido INTEGER NOT NULL,
            FOREIGN KEY(fk_id_producto) REFERENCES productos(id),
            FOREIGN KEY(fk_id_pedido) REFERENCES pedidos(id)
          )
        ''');

        // NUEVA TABLA CARRITO CON USUARIO
        await db.execute('''
          CREATE TABLE carrito (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_producto INTEGER NOT NULL,
            cantidad INTEGER NOT NULL,
            id_usuario INTEGER NOT NULL,
            FOREIGN KEY(id_producto) REFERENCES productos(id),
            FOREIGN KEY(id_usuario) REFERENCES usuarios(id)
          )
        ''');

        await db.execute("INSERT INTO usuarios (usuario, password, nombre, email, telefono, rol) VALUES ('admin', 'admin', 'Admin', 'admin@gmail.com', '099999993', 'admin')");
      },
      version: version,
      onOpen: (db) async {},
    );
  }

  // Métodos estáticos para operaciones CRUD
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert(table, data);
    } catch (e) {
      print('Error en insert: $e');
      rethrow;
    }
  }

  static Future<int> update(String table, Map<String, dynamic> data, int id) async {
    try {
      final db = await database;
      return await db.update(
        table,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error en update: $e');
      rethrow;
    }
  }

  static Future<int> delete(String table, int id) async {
    try {
      final db = await database;
      return await db.delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error en delete: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> list(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      print('Error en list: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> filter(
    String table,
    String where,
    List<dynamic> whereArgs,
  ) async {
    final db = await database;
    var resultado = await db.query(table, where: where, whereArgs: whereArgs);
    return resultado;
  }

  static Future<Map<String, dynamic>?> getById(String table, int id) async {
    try {
      final db = await database;
      final result = await db.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error en getById: $e');
      rethrow;
    }
  }
}
