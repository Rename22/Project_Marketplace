import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/pedido_entity.dart';
import '../../repositories/pedido_detail_cliente_screen.dart';
import '../../repositories/pedido_repository.dart';

class ClientePedidosScreen extends StatefulWidget {
  const ClientePedidosScreen({super.key});

  @override
  State<ClientePedidosScreen> createState() => _ClientePedidosScreenState();
}

class _ClientePedidosScreenState extends State<ClientePedidosScreen> {
  late Future<List<Pedido>> _listPedidos;
  int? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
      if (_userId != null) {
        _listPedidos = PedidoRepository.getByClienteId(_userId!);
      }
    });
  }

  Color _getEstadoColor(String estado) {
    return estado == "pendiente" ? Colors.orange : Colors.green;
  }

  IconData _getEstadoIcon(String estado) {
    return estado == "pendiente" ? Icons.pending : Icons.check_circle;
  }

  Future<void> _eliminarPedido(Pedido pedido) async {
    if (pedido.estado != "pendiente") return;

    setState(() => _isLoading = true);
    
    try {
      await PedidoRepository.delete(pedido.id!);
      // Actualizar la lista después de eliminar
      setState(() {
        _listPedidos = PedidoRepository.getByClienteId(_userId!);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pedido eliminado"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al eliminar pedido: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmarEliminacion(Pedido pedido) async {
    if (pedido.estado != "pendiente") return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Pedido"),
        content: const Text("¿Estás seguro de que deseas eliminar este pedido pendiente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _eliminarPedido(pedido);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
        backgroundColor: Color.fromARGB(255, 97, 117, 150), // Mismo color que en otras pantallas
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userId == null
              ? const Center(child: Text("Usuario no identificado"))
              : FutureBuilder<List<Pedido>>(
                  future: _listPedidos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No tienes pedidos",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                    
                    final pedidos = snapshot.data!;
                    return ListView.builder(
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = pedidos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _getEstadoIcon(pedido.estado),
                                          color: _getEstadoColor(pedido.estado),
                                          size: 28,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "Pedido #${pedido.id}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Chip(
                                      label: Text(
                                        pedido.estado.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: _getEstadoColor(pedido.estado),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Fecha: ${pedido.fecha.split('T')[0]}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Botón para eliminar solo si está pendiente
                                    if (pedido.estado == "pendiente")
                                      TextButton.icon(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        label: const Text(
                                          "Eliminar",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () => _confirmarEliminacion(pedido),
                                      ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.visibility, size: 18),
                                      label: const Text("Ver Detalle"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 97, 117, 150),
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PedidoDetailClienteScreen(pedido: pedido),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}