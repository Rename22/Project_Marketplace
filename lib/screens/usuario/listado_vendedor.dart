import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/usuario_entity.dart';
import '../../repositories/usuario_repository.dart';
import 'register_vendedor.dart';

class ListadoVendedoresScreen extends StatefulWidget {
  const ListadoVendedoresScreen({super.key});

  @override
  State<ListadoVendedoresScreen> createState() => _ListadoVendedoresScreenState();
}

class _ListadoVendedoresScreenState extends State<ListadoVendedoresScreen> {
  late Future<List<Usuario>> _listVendedores;
  bool _isLoading = false;
  String? _errorMessage;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadVendedores();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  void _loadVendedores() {
    setState(() {
      _listVendedores = UsuarioRepository.getByRol('vendedor');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Vendedores" , style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterVendedorFormScreen()),
          ).then((_) => _loadVendedores());
        },
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : FutureBuilder<List<Usuario>>(
                  future: _listVendedores,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No existen vendedores registrados"));
                    }

                    final vendedores = snapshot.data!;
                    return ListView.builder(
                      itemCount: vendedores.length,
                      itemBuilder: (context, index) {
                        final vendedor = vendedores[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 97, 117, 150),
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(vendedor.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Usuario: ${vendedor.usuario}"),
                                Text("Email: ${vendedor.email}"),
                                Text("Teléfono: ${vendedor.telefono}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editarVendedor(vendedor),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _eliminarVendedor(vendedor),
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

  void _editarVendedor(Usuario vendedor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterVendedorFormScreen(
          vendedorExistente: vendedor,
        ),
      ),
    ).then((_) => _loadVendedores());
  }

  Future<void> _eliminarVendedor(Usuario vendedor) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de eliminar al vendedor ${vendedor.nombre}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      try {
        await UsuarioRepository.delete(vendedor.id!);
        _loadVendedores();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Vendedor ${vendedor.nombre} eliminado"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() => _errorMessage = "Error al eliminar vendedor: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
