import 'package:flutter/material.dart';
import 'package:trabalho_final/controller/url_api.dart';
import 'telaInicial.dart';

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  String urlinha = " ";
  @override
  void initState() {
    super.initState();

    setState(() {
      urlinha = urlLida.getUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 100, 0, 0),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Ler Qr"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaInicial(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Lista"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaLista(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(110, 0, 110, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
