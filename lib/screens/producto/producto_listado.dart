import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/producto_entity.dart';
import '../../repositories/producto_repository.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Producto>> _listProducts;
  String? _userRole; // 'admin' o 'vendedor'
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadUserData();
  }

  void _loadProducts() {
    setState(() {
      _listProducts = ProductoRepository.list();
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('userRole');
      _userId = prefs.getInt('userId');
    });
  }

  // Construir el Drawer según el rol del usuario
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 97, 117, 150)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [ 
                Text(
                  _userRole == 'admin' ? 'Menú Administrador' : 'Menú Vendedor',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Image.asset(
                  'assets/images/tienda1.png',  
                  width: 100, 
                  height: 100, 
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
                    
          // Opciones comunes a ambos roles
          ListTile(
            leading: const Icon(Icons.inventory, color: Colors.black),
            title: const Text('Gestión de Productos'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Solo para admin
          if (_userRole == 'admin')
            ListTile(
              leading: const Icon(Icons.people, color: Colors.black),
              title: const Text('Gestión de Vendedores'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/listado_vendedores');
              },
            ),
          // Gestión de pedidos para ambos
          ListTile(
            leading: const Icon(Icons.receipt, color: Colors.black),
            title: const Text('Gestión de Pedidos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context, 
                _userRole == 'admin' ? '/vendedor_pedidos' : '/vendedor_pedidos'
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        foregroundColor: Colors.white,
        title: const Text("Listado de productos"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        elevation: 1,
      ),
      body: FutureBuilder<List<Producto>>(
        future: _listProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No existen registros"));
          }
          
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: _getProductImage(product.imagen),
                  title: Text(
                    product.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Precio: \$${product.precio}"),
                      Text("Stock: ${product.stock}", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: product.stock > 0 ? Colors.black : Colors.red
                          )
                      ),
                      if (product.descripcion.isNotEmpty)
                        Text("Descripción: ${product.descripcion}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/producto/create',
                            arguments: product,
                          ).then((_) => _loadProducts());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () => _eliminarProducto(product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/producto/create').then((_) => _loadProducts());
        },
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _getProductImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const Icon(
        Icons.image_not_supported, 
        size: 50, 
        color: Colors.grey
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          File(imagePath),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
          },
        ),
      );
    } catch (e) {
      return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
    }
  }

  Future<void> _eliminarProducto(Producto product) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar producto?"),
        content: Text("¿Estás seguro de eliminar el producto ${product.nombre}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
    
    if (respuesta == true) {
      try {
        await ProductoRepository.delete(product.id!);
        _loadProducts();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Producto "${product.nombre}" eliminado'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
