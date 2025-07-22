import 'package:flutter/material.dart';
import '../../entities/detalle_pedido_entity.dart';
import '../../entities/pedido_entity.dart';
import '../../repositories/detalle_pedido_repository.dart';
import '../../repositories/pedido_repository.dart';
import '../../repositories/producto_repository.dart';

class PedidoDetailScreen extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetailScreen({super.key, required this.pedido});

  @override
  State<PedidoDetailScreen> createState() => _PedidoDetailScreenState();
}

class _PedidoDetailScreenState extends State<PedidoDetailScreen> {
  late Pedido pedido;
  late Future<List<DetallePedido>> _detallesPedido;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    pedido = widget.pedido;
    _cargarDetalles();
  }

  void _cargarDetalles() {
    setState(() {
      _detallesPedido = DetallePedidoRepository.getByPedidoId(pedido.id!);
    });
  }

  Future<void> _cambiarEstado(String nuevoEstado) async {
    if (pedido.estado == 'entregado') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido ya entregado"))
      );
      return;
    }

    setState(() => _cargando = true);
    
    try {
      pedido.estado = nuevoEstado;
      await PedidoRepository.update(pedido);
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
        );
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Pedido"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _cargando 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera del pedido
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pedido #${pedido.id}", 
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Fecha: ${pedido.fecha}"),
                              Chip(
                                label: Text(
                                  pedido.estado.toUpperCase(),
                                  style: TextStyle(
                                    color: pedido.estado == 'entregado' 
                                        ? Colors.green 
                                        : Colors.orange
                                  ),
                                ),
                                backgroundColor: pedido.estado == 'entregado' 
                                    ? Colors.green[100] 
                                    : Colors.orange[100],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Botón para cambiar estado
                  if (pedido.estado == 'pendiente')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => _cambiarEstado('entregado'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: const Text("MARCAR COMO ENTREGADO"),
                        ),
                      ),
                    ),
                  
                  // Lista de productos
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text("Productos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: FutureBuilder<List<DetallePedido>>(
                      future: _detallesPedido,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No hay productos en este pedido"));
                        }
                        
                        final detalles = snapshot.data!;
                        double total = 0.0;
                        
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: detalles.length,
                                itemBuilder: (context, index) {
                                  final detalle = detalles[index];
                                  total += detalle.subtotal;
                                  
                                  return FutureBuilder<String>(
                                    future: ProductoRepository.getNombreProducto(detalle.fkIdProducto),
                                    builder: (context, nombreSnapshot) {
                                      final nombre = nombreSnapshot.data ?? "Producto desconocido";
                                      
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(12),
                                          leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                                          title: Text(nombre),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Cantidad: ${detalle.cantidad}"),
                                              Text("Subtotal: \$${detalle.subtotal.toStringAsFixed(2)}"),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                },
                              ),
                            ),
                            
                            // Total
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
                                  Text("\$${total.toStringAsFixed(2)}", 
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}