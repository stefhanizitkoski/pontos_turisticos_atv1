import 'package:flutter/material.dart';
import 'package:pontos_turisticos_entrega/pages/lista_pontos_turisticos.dart';
import 'package:pontos_turisticos_entrega/pages/filtro_page.dart';

void main() {
  runApp(const AppPontosTuristicos());
}

class AppPontosTuristicos extends StatelessWidget {
  const AppPontosTuristicos({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pontos Turisticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PontosTuristicosPage(),
      routes: {
        FiltroPage.routeName: (BuildContext context) => FiltroPage(),
      },
    );
  }
}

