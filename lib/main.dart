import 'package:flutter/material.dart';

import '9ListadoPorEntregar.dart';
import 'CrearCategory.dart';
import 'CrearProduct.dart';
import 'ListCategory.dart';
import 'ListPproduct.dart';
import 'login.dart';
import 'menu.dart';
import 'menu_cliente.dart';
import 'pedidos.dart';
import 'pendientes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplicacion de pedidos",
      initialRoute: '/login',
      routes: {
        '/menu': (context) => Menu(),
        '/pedidos': (context) => Pedidos(),
        '/pendientes': (context) => Pendientes(),
        '/ListadoPorEntregar': (context) => ListadoPorEntregar(),
        '/login': (context) => Login(),
        '/menu_cliente': (context) => MenuCliente(),
        '/list_category': (context) => ListCategory(),
        '/CrearCate': (context) => CrearCategoria(),
        '/listProduct': (context) => ListProduct(),
        '/CrearProduct': (context) => CrearProduct(),

        
      },
    );
  }
}
