import 'package:flutter/material.dart';
import '../../entities/detalle_pedido_entity.dart';
import '../../entities/pedido_entity.dart';
import '../../repositories/detalle_pedido_repository.dart';
import '../../repositories/producto_repository.dart';

class PedidoDetailClienteScreen extends StatelessWidget {
  final Pedido pedido;

  const PedidoDetailClienteScreen({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle Pedido #${pedido.id}"),
        backgroundColor: Color.fromARGB(255, 97, 117, 150), // Mismo color que en vendedor
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            const Text("Productos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: _buildProductosList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pedido #${pedido.id}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fecha: ${pedido.fecha}"),
                  ],
                ),
                Chip(
                  label: Text(
                    pedido.estado.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: pedido.estado == "pendiente" ? Colors.orange : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosList() {
    return FutureBuilder<List<DetallePedido>>(
      future: DetallePedidoRepository.getByPedidoId(pedido.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay productos en este pedido"));
        }
        
        final detalles = snapshot.data!;
        // Calcular el total sumando todos los subtotales
        double total = detalles.fold(0.0, (sum, detalle) => sum + detalle.subtotal);
        
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: detalles.length,
                itemBuilder: (context, index) {
                  final detalle = detalles[index];
                  
                  return FutureBuilder<String>(
                    future: ProductoRepository.getNombreProducto(detalle.fkIdProducto),
                    builder: (context, nombreSnapshot) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(nombreSnapshot.data ?? "Producto desconocido"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Cantidad: ${detalle.cantidad}"),
                              Text("Precio unitario: \$${(detalle.subtotal / detalle.cantidad).toStringAsFixed(2)}"),
                              Text("Subtotal: \$${detalle.subtotal.toStringAsFixed(2)}", 
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }
                  );
                },
              ),
            ),
            // Mostrar el total con el mismo diseño que en vendedor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${total.toStringAsFixed(2)}", 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}