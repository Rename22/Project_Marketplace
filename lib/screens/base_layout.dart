import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final void Function(int)? onTap;

  const BaseLayout({
    super.key,
    required this.body,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap:
            onTap ??
            (index) {
              switch (index) {
                case 0:
                  //Navigator.pushNamed(context, '/');
                  break;
                case 1:
                  //Navigator.pushNamed(context, '/products');
                  break;
                case 2:
                  //Navigator.pushNamed(context, '/clients');
                  break;
              }
            },
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
        ],
      ),
    );
  }
}
