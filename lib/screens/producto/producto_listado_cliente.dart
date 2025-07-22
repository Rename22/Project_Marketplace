import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/carrito_entity.dart';
import '../../entities/producto_entity.dart';
import '../../repositories/producto_repository.dart';
import '../../repositories/carrito_repository.dart';
import 'carrito_screen.dart';

class ProductListClienteScreen extends StatefulWidget {
  const ProductListClienteScreen({super.key});

  @override
  State<ProductListClienteScreen> createState() => _ProductListClienteScreenState();
}

class _ProductListClienteScreenState extends State<ProductListClienteScreen> {
  late Future<List<Producto>> _listProducts = Future.value([]);
  late Future<List<CarritoItem>> _carritoFuture;
  int? userId;

  @override
  void initState() {
    super.initState();
    _carritoFuture = Future.value([]);
    _loadProducts(); // Cargar productos inmediatamente
    _loadUserId().then((_) {
      if (userId != null) {
        _loadCarrito();
      }
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  void _loadProducts() {
    setState(() {
      _listProducts = ProductoRepository.list();
    });
  }

  void _loadCarrito() {
    if (userId == null) return;
    setState(() {
      _carritoFuture = CarritoRepository.list(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 97, 117, 150)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [ 
                  Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
                  Image.asset(
                    'assets/images/tienda1.png',  
                    width: 100, 
                    height: 100, 
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Listado de Productos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Carrito'),
              onTap: () async {
                if (userId == null) return;
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarritoScreen(
                    userId: userId!,
                    onCartUpdated: _loadCarrito
                  )),
                );
                if (result == true) _loadProducts();
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Pedidos'),
              onTap: () => Navigator.pushNamed(context, '/cliente_pedidos'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 117, 150),
        title: const Text("Listado de productos", style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          FutureBuilder<List<CarritoItem>>(
            future: _carritoFuture,
            builder: (context, snapshot) {
              final itemCount = snapshot.hasData ? snapshot.data!.length : 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () async {
                      if (userId == null) return;
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CarritoScreen(
                          userId: userId!,
                          onCartUpdated: _loadCarrito
                        )),
                      );
                      if (result == true) _loadProducts();
                    },
                  ),
                  if (itemCount > 0) Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        itemCount.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
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
                  title: Text(product.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Precio: \$${product.precio}"),
                      Text("Stock: ${product.stock}", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: product.stock > 0 ? Colors.black : Colors.red,
                      )),
                      if (product.descripcion.isNotEmpty)
                        Text("Descripción: ${product.descripcion}"),
                    ],
                  ),
                  trailing: product.stock > 0
                      ? IconButton(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                          onPressed: () => _agregarAlCarrito(product),
                        )
                      : const Text("Sin stock", style: TextStyle(color: Colors.red)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getProductImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
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

  Future<void> _agregarAlCarrito(Producto product) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no identificado'), backgroundColor: Colors.red),
      );
      return;
    }
    
    try {
      if (product.stock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto "${product.nombre}" sin stock'), backgroundColor: Colors.red),
        );
        return;
      }

      final updatedProduct = Producto(
        id: product.id,
        nombre: product.nombre,
        descripcion: product.descripcion,
        precio: product.precio,
        stock: product.stock - 1,
        imagen: product.imagen,
      );
      
      await ProductoRepository.update(updatedProduct);

      final existingItem = await CarritoRepository.getByProductId(product.id!, userId!);
      
      if (existingItem != null) {
        final updatedItem = CarritoItem(
          id: existingItem.id,
          idProducto: product.id!,
          cantidad: existingItem.cantidad + 1,
          idUsuario: userId!,
          producto: existingItem.producto,
        );
        await CarritoRepository.update(updatedItem);
      } else {
        final newItem = CarritoItem(
          idProducto: product.id!,
          cantidad: 1,
          idUsuario: userId!,
          producto: product,
        );
        await CarritoRepository.insert(newItem);
      }

      _loadProducts();
      _loadCarrito();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto "${product.nombre}" agregado al carrito'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar producto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
