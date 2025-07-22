class Producto {
  int? id;
  String nombre;
  String descripcion;
  double precio;
  int stock;
  String imagen;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.imagen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'] is double ? map['precio'] : (map['precio'] as int).toDouble(),
      stock: map['stock'],
      imagen: map['imagen'],
    );
  }
}