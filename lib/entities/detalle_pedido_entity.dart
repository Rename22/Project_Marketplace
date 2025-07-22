class DetallePedido {
  int? id;
  int cantidad;
  double subtotal;
  int fkIdProducto;
  int fkIdPedido;

  DetallePedido({
    this.id,
    required this.cantidad,
    required this.subtotal,
    required this.fkIdProducto,
    required this.fkIdPedido,
  });

  // Transforma de clase a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cantidad': cantidad,
      'subtotal': subtotal,
      'fk_id_producto': fkIdProducto,
      'fk_id_pedido': fkIdPedido,
    };
  }

  // Transforma de Map a clase
  factory DetallePedido.fromMap(Map<String, dynamic> data) {
    return DetallePedido(
      id: data['id'],
      cantidad: data['cantidad'],
      subtotal: data['subtotal'],
      fkIdProducto: data['fk_id_producto'],
      fkIdPedido: data['fk_id_pedido'],
    );
  }
}
