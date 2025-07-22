import 'package:flutter/material.dart';
import '../../entities/pedido_entity.dart';
import '../../repositories/pedido_repository.dart';
import '../../repositories/usuario_repository.dart'; // Repositorio para obtener los datos del cliente (usuario)

class PedidoListScreen extends StatefulWidget {
  const PedidoListScreen({super.key});

  @override
  State<PedidoListScreen> createState() => _PedidoListScreenState();
}

class _PedidoListScreenState extends State<PedidoListScreen> {
  late Future<List<Pedido>> _listPedidos;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  void _loadPedidos() {
    _listPedidos = PedidoRepository.list();
  }

  // Color del estado
  Color getEstadoColor(String estado) {
    switch (estado) {
      case "pendiente":
        return Colors.orange;  
      case "entregado":
        return Colors.green;  
      default:
        return Colors.grey;  
    }
  }

  // Icono del estado
  IconData getEstadoIcon(String estado) {
    switch (estado) {
      case "pendiente":
        return Icons.hourglass_empty;  
      case "entregado":
        return Icons.check_circle;  
      default:
        return Icons.info;  
    }
  }

  // Función para ordenar los pedidos: pendiente primero, luego entregado
  List<Pedido> ordenarPedidos(List<Pedido> pedidos) {
    // Ordenamos primero los pendientes, luego los entregados
    pedidos.sort((a, b) {
      if (a.estado == 'pendiente' && b.estado == 'entregado') return -1;
      if (a.estado == 'entregado' && b.estado == 'pendiente') return 1;
      return 0;
    });
    return pedidos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      appBar: AppBar(
        title: const Text("Pedidos", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _listPedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No existen pedidos disponibles.", style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          } else {
            // Ordenar los pedidos antes de pasarlos a la lista
            final pedidos = ordenarPedidos(snapshot.data!);

            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: pedidos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return Card(
                  color: Colors.white,
                  elevation: 6,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CABECERA
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: getEstadoColor(pedido.estado),
                              child: Icon(getEstadoIcon(pedido.estado), color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Pedido #${pedido.id}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text(
                                pedido.estado.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: getEstadoColor(pedido.estado),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // DATOS DEL CLIENTE
                        FutureBuilder<String?>(
                          future: UsuarioRepository.getNombreCliente(pedido.fkIdCliente),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  Icon(Icons.person, color: Colors.grey[600], size: 18),
                                  const SizedBox(width: 4),
                                  Text("Cliente: ", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                                  Text(snapshot.data ?? 'Nombre no disponible', style: TextStyle(color: Colors.grey[800])),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.grey[600], size: 18),
                            const SizedBox(width: 4),
                            Text("Fecha: ", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                            Text(pedido.fecha, style: TextStyle(color: Colors.grey[800])),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // BOTÓN "VER DETALLES"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Redirigir a la vista de detalles del pedido
                                Navigator.pushNamed(
                                  context,
                                  '/pedido/detalle_pedido_estado',
                                  arguments: pedido, // Pasamos el pedido a la vista de detalles
                                ).then((_) => setState(() => _loadPedidos()));
                              },
                              child: const Text("Ver Detalles"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Color de fondo
                                foregroundColor: Colors.white, // Color del texto
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
