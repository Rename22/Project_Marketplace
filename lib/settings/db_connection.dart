import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection {
  static const version = 1;
  static const dbName = 'marketplace.db';

  static Future<Database> getDb() async {
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) async {
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

        await db.execute('''
          CREATE TABLE categorias (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT,
            precio REAL NOT NULL,
            stock INTEGER DEFAULT 0,
            imagen TEXT,
            fk_id_vendedor INTEGER NOT NULL,
            fk_id_categoria INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha TEXT DEFAULT CURRENT_TIMESTAMP,
            estado TEXT DEFAULT 'pendiente',
            fk_id_cliente INTEGER NOT NULL,
            fk_id_vendedor INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE detalle_pedido (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cantidad INTEGER NOT NULL,
            subtotal REAL NOT NULL,
            fk_id_producto INTEGER NOT NULL,
            fk_id_pedido INTEGER NOT NULL
          )
        ''');
      },
      version: version,
    );
  }

  static Future<int> insert(String tableName, dynamic data) async {
    final db = await getDb();
    return db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(String tableName, dynamic data, int id) async {
    final db = await getDb();
    return db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> delete(String tableName, int id) async {
    final db = await getDb();
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> list(String tableName) async {
    final db = await getDb();
    return db.query(tableName);
  }

  static Future<List<Map<String, dynamic>>> filter(
    String tableName,
    String where,
    List<dynamic> whereArgs,
  ) async {
    final db = await getDb();
    return db.query(tableName, where: where, whereArgs: whereArgs);
  }

  static Future<Map<String, dynamic>?> getById(String tableName, int id) async {
    final db = await getDb();
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }
}
