import 'package:flutter/material.dart';
import 'producto_entity.dart';

class CarritoItem {
  int? id;
  int idProducto;
  int cantidad;
  int idUsuario;
  Producto producto;

  CarritoItem({
    this.id,
    required this.idProducto,
    required this.cantidad,
    required this.idUsuario,
    required this.producto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_producto': idProducto,
      'cantidad': cantidad,
      'id_usuario': idUsuario,
    };
  }

  factory CarritoItem.fromMap(Map<String, dynamic> map, Producto producto) {
    return CarritoItem(
      id: map['id'],
      idProducto: map['id_producto'],
      cantidad: map['cantidad'],
      idUsuario: map['id_usuario'],
      producto: producto,
    );
  }
}