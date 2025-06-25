import 'package:flutter/material.dart';


class Pedidos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Pedidos"),
            SizedBox(height: 20,
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context,'/pendientes' );
              },
             child: Row(
              children: [
                Icon(Icons.verified_user),
                SizedBox(
                  width: 25,
                ),
                Text("Pendietes"),
              ],
             ),
            ),
            SizedBox(height: 20,
            ),
            ElevatedButton(
              onPressed: (){
                 Navigator.pushNamed(context,'/ListadoPorEntregar' );
            }, 
            child:Row(
              children: [
                Icon(Icons.people),
                SizedBox(
                  width: 25,
                ),
                Text(" Por entregar"),
              ],
             ),
            ),
          ],
        ),
        ),
    );
  }
}

