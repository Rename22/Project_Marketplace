class Pedido {
  int? id;
  String fecha;
  String estado;
  int fkIdCliente;

  Pedido({
    this.id,
    required this.fecha,
    required this.estado,
    required this.fkIdCliente,
  });

  // Transforma de clase a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'estado': estado,
      'fk_id_cliente': fkIdCliente,
    };
  }

  // Transforma de Map a clase
  factory Pedido.fromMap(Map<String, dynamic> data) {
    return Pedido(
      id: data['id'],
      fecha: data['fecha'],
      estado: data['estado'],
      fkIdCliente: data['fk_id_cliente'],
    );
  }
}
