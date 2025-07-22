import 'package:flutter/material.dart';
import '../../entities/pedido_entity.dart';
import '../../repositories/pedido_repository.dart';
import '../../repositories/usuario_repository.dart';
import 'pedido_detail_vendedor_screen.dart';

class VendedorPedidosScreen extends StatefulWidget {
  const VendedorPedidosScreen({super.key});

  @override
  State<VendedorPedidosScreen> createState() => _VendedorPedidosScreenState();
}

class _VendedorPedidosScreenState extends State<VendedorPedidosScreen> {
  late Future<List<Pedido>> _listPedidos;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  void _loadPedidos() {
    setState(() {
      _listPedidos = PedidoRepository.list();
    });
  }

  Color _getEstadoColor(String estado) {
    return estado == "pendiente" ? Colors.orange : Colors.green;
  }

  IconData _getEstadoIcon(String estado) {
    return estado == "pendiente" ? Icons.pending : Icons.check_circle;
  }

  List<Pedido> _ordenarPedidos(List<Pedido> pedidos) {
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
      appBar: AppBar(
        title: const Text("Pedidos"),
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _listPedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay pedidos registrados"));
          }
          
          final pedidos = _ordenarPedidos(snapshot.data!);
          
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(
                    _getEstadoIcon(pedido.estado),
                    color: _getEstadoColor(pedido.estado),
                  ),
                  title: Text("Pedido #${pedido.id}"),
                  subtitle: FutureBuilder<String?>(
                    future: UsuarioRepository.getNombreCliente(pedido.fkIdCliente),
                    builder: (context, nombreSnapshot) {
                      return Text("Cliente: ${nombreSnapshot.data ?? 'Desconocido'}");
                    }
                  ),
                  trailing: Chip(
                    label: Text(
                      pedido.estado.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getEstadoColor(pedido.estado),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PedidoDetailVendedorScreen(pedido: pedido),
                      ),
                    ).then((_) => _loadPedidos());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
