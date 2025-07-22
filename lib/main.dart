import 'package:flutter/material.dart';
import 'package:project_marketplace/entities/pedido_entity.dart';

import 'repositories/pedido_detail_cliente_screen.dart';
import 'repositories/pedido_detail_vendedor_screen.dart';
import 'repositories/vendedor_pedidos_screen.dart';
import 'screens/pedido/cliente_pedidos_screen.dart';
import 'screens/producto/carrito_screen.dart';
import 'screens/producto/producto_formulario.dart';
import 'screens/producto/producto_listado.dart';
import 'screens/producto/producto_listado_cliente.dart';
import 'screens/usuario/listado_vendedor.dart';
import 'screens/usuario/login_screen.dart';
import 'screens/usuario/register_screen.dart';
import 'screens/usuario/register_vendedor.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Entidades',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(), // Ruta al formulario de registro
        '/listado_vendedores': (context) => const ListadoVendedoresScreen(), // Ruta a la pantalla de listado de vendedores
        '/registerVendedor': (context) => const RegisterVendedorFormScreen(), // Ruta al formulario de registro de vendedor
        '/listado_productos_vendedor': (context) => const ProductListScreen(), // Ruta a la pantalla de productos
        '/producto/create': (context) => const AddProductScreen(), // Ruta a la pantalla de creación de productos
        '/listado_productos_cliente': (context) => const ProductListClienteScreen(), // Ruta a la pantalla de listado de productos
        '/cliente_pedidos': (context) => const ClientePedidosScreen(),
        '/vendedor_pedidos': (context) => const VendedorPedidosScreen(),
        '/pedido/detalle_cliente': (context) {
          final pedido = ModalRoute.of(context)!.settings.arguments as Pedido;
          return PedidoDetailClienteScreen(pedido: pedido);
        },
        '/pedido/detalle_vendedor': (context) {
          final pedido = ModalRoute.of(context)!.settings.arguments as Pedido;
          return PedidoDetailVendedorScreen(pedido: pedido);
        },
                // Otras rutas...
      },
    );
  }
}
