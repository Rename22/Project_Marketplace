import 'package:flutter/material.dart';
import '../../entities/carrito_entity.dart';
import '../../entities/detalle_pedido_entity.dart';
import '../../entities/pedido_entity.dart';
import '../../entities/producto_entity.dart';
import '../../repositories/carrito_repository.dart';
import '../../repositories/detalle_pedido_repository.dart';
import '../../repositories/pedido_repository.dart';
import '../../repositories/producto_repository.dart';

class CarritoScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onCartUpdated;

  const CarritoScreen({Key? key, required this.userId, required this.onCartUpdated}) : super(key: key);

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  late Future<List<CarritoItem>> _carritoFuture;
  bool _hasStockChanges = false;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _loadCarrito();
  }

  void _loadCarrito() {
    setState(() {
      _carritoFuture = CarritoRepository.list(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        title: const Text("Carrito de compras", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _hasStockChanges),
        ),
      ),
      body: FutureBuilder<List<CarritoItem>>(
        future: _carritoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("El carrito está vacío"));
          }
          
          final carrito = snapshot.data!;
          double total = 0.0;
          
          for (var item in carrito) {
            total += item.producto.precio * item.cantidad;
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: carrito.length,
                  itemBuilder: (context, index) {
                    final item = carrito[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(item.producto.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cantidad: ${item.cantidad}"),
                            Text("Precio unitario: \$${item.producto.precio.toStringAsFixed(2)}"),
                            Text("Subtotal: \$${(item.producto.precio * item.cantidad).toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                              onPressed: () => _reducirCantidad(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarCompletamente(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                    )),
                  ],
                ),
              ),
              // Botón para confirmar pedido
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50), // ancho completo y altura 50
                  ),
                  onPressed: _isConfirming ? null : () => _confirmarPedido(carrito),
                  child: _isConfirming 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('CONFIRMAR PEDIDO', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmarPedido(List<CarritoItem> carritoItems) async {
    if (carritoItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El carrito está vacío'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isConfirming = true);

    try {
      // Crear el pedido
      final nuevoPedido = Pedido(
        fecha: DateTime.now().toIso8601String(),
        estado: 'pendiente',
        fkIdCliente: widget.userId,
      );
      final pedidoId = await PedidoRepository.insert(nuevoPedido);

      // Crear los detalles del pedido
      for (var item in carritoItems) {
        final detalle = DetallePedido(
          cantidad: item.cantidad,
          subtotal: item.producto.precio * item.cantidad,
          fkIdProducto: item.idProducto,
          fkIdPedido: pedidoId,
        );
        await DetallePedidoRepository.insert(detalle);
      }

      // Vaciar el carrito
      await CarritoRepository.deleteByUserId(widget.userId);

      // Actualizar el estado
      setState(() {
        _hasStockChanges = true;
        _isConfirming = false;
      });

      // Notificar que el carrito se actualizó
      widget.onCartUpdated();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido confirmado con éxito'),
          backgroundColor: Colors.green,
        ),
      );

      // Cerrar la pantalla de carrito
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isConfirming = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al confirmar el pedido: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _reducirCantidad(CarritoItem item) async {
    try {
      final updatedProduct = Producto(
        id: item.producto.id,
        nombre: item.producto.nombre,
        descripcion: item.producto.descripcion,
        precio: item.producto.precio,
        stock: item.producto.stock + 1,
        imagen: item.producto.imagen,
      );
      
      await ProductoRepository.update(updatedProduct);

      if (item.cantidad > 1) {
        final updatedItem = CarritoItem(
          id: item.id,
          idProducto: item.idProducto,
          cantidad: item.cantidad - 1,
          idUsuario: item.idUsuario,
          producto: updatedProduct,
        );
        await CarritoRepository.update(updatedItem);
      } else {
        await CarritoRepository.delete(item.id!);
      }

      setState(() {
        _hasStockChanges = true;
        _loadCarrito();
        widget.onCartUpdated();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cantidad de "${item.producto.nombre}" reducida'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _eliminarCompletamente(CarritoItem item) async {
    try {
      final updatedProduct = Producto(
        id: item.producto.id,
        nombre: item.producto.nombre,
        descripcion: item.producto.descripcion,
        precio: item.producto.precio,
        stock: item.producto.stock + item.cantidad,
        imagen: item.producto.imagen,
      );
      
      await ProductoRepository.update(updatedProduct);
      await CarritoRepository.delete(item.id!);

      setState(() {
        _hasStockChanges = true;
        _loadCarrito();
        widget.onCartUpdated();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto "${item.producto.nombre}" eliminado del carrito'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}