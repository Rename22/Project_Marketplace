import 'package:flutter/material.dart';
import '../../../entities/detalle_pedido_entity.dart';
import '../../../entities/pedido_entity.dart';
import '../../../repositories/detalle_pedido_repository.dart';
import '../../../repositories/pedido_repository.dart';
import '../../../repositories/producto_repository.dart';
import '../../repositories/usuario_repository.dart';

class PedidoDetailVendedorScreen extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetailVendedorScreen({super.key, required this.pedido});

  @override
  State<PedidoDetailVendedorScreen> createState() => _PedidoDetailVendedorScreenState();
}

class _PedidoDetailVendedorScreenState extends State<PedidoDetailVendedorScreen> {
  late Pedido pedido;
  late Future<List<DetallePedido>> _detallesPedido;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    pedido = widget.pedido;
    _loadDetalles();
  }

  void _loadDetalles() {
    setState(() {
      _detallesPedido = DetallePedidoRepository.getByPedidoId(pedido.id!);
    });
  }

  Future<void> _actualizarEstado(String nuevoEstado) async {
    setState(() => _isLoading = true);
    
    try {
      pedido.estado = nuevoEstado;
      await PedidoRepository.update(pedido);
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Estado actualizado a $nuevoEstado"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al actualizar estado: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle Pedido #${pedido.id}"),
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  const Text("Productos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(child: _buildProductosList()),
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
                    FutureBuilder<String?>(
                      future: UsuarioRepository.getNombreCliente(pedido.fkIdCliente),
                      builder: (context, snapshot) {
                        return Text("Cliente: ${snapshot.data ?? 'Desconocido'}");
                      }
                    ),
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
            const SizedBox(height: 10),
            if (pedido.estado == 'pendiente')
              Center(
                child: ElevatedButton(
                  onPressed: () => _actualizarEstado('entregado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 97, 117, 150),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("MARCAR COMO ENTREGADO"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosList() {
    return FutureBuilder<List<DetallePedido>>(
      future: _detallesPedido,
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