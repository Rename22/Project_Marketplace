import '../../entities/producto_entity.dart';

class ProductInCart {
  final Producto producto; // Almacena el producto
  int cantidad; // Almacena la cantidad del producto en el carrito

  ProductInCart({required this.producto, required this.cantidad});
}
