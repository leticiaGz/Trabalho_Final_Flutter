import 'package:flutter/material.dart';
import 'package:trabalho_final/models/detahes.dart';
import 'package:trabalho_final/models/lista.dart';
import 'package:trabalho_final/telaCadastro.dart';
import 'telaInicial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String url = " ";

Future<List<Lista>> getLista() async {
  final response = await http.get(Uri.parse('$url/getLista.php'),
      headers: {"Accept": "application/json"});
  if (response.statusCode == 200) {
    List fila = json.decode(response.body);
    return fila.map((data) => Lista.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado...');
  }
}

maisDetalhes(dynamic context, int id) async {
  http.get(Uri.parse('$url/getDetalhe.php?id=$id'),
      headers: {"Accept": "application/json"}).then(
    (data) {
      List<dynamic> jsonData = json.decode(data.body);
      List<Detalhes> dados =jsonData.map((data) => Detalhes.fromJson(data)).toList();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Id: "+dados.map((e) => e.id.toString()).first),
          content: SizedBox(
            width: 100,
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: "+dados.map((e) => e.nome).first),
                Text("Data: "+dados.map((e) => e.data).first),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    },
  );
}
Future<void> remove(int id) {
  return http
      .delete(Uri.parse('$url/delete.php?id=$id'), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  late Future<List<Lista>> listaData;

  @override
  void initState() {
    super.initState();

    setState(() {
      url = urlLida.getUrl();
    });

    listaData = getLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagem')),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Cadastro"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cadastro(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 500,
            height: 700,
            child: FutureBuilder<List<Lista>>(
              future: listaData,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  List<Lista> data = snapshot.data!;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                maisDetalhes(context, data[index].id);
                              },
                              child: ListTile(
                                title: Text(data[index].nome),
                                subtitle: Text(data[index].id.toString()),
                              ),
                            ),
                            SizedBox(
                              width: 330,
                              child: ElevatedButton(
                                  child: const Text("Deletar"),
                                  onPressed: () {
                                    remove(data[index].id);
                                  }),
                            ),
                          ]),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
