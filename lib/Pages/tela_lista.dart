import 'package:flutter/material.dart';
import 'package:trabalho_final/templates/menu.dart';
import 'package:trabalho_final/models/detalhes.dart';
import 'package:trabalho_final/models/lista.dart';
import 'tela_inicial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String url = " ";

//Funcao que lista
Future<List<Lista>> getLista() async {
  final response = await http.get(Uri.parse('$url/getLista.php'),
      headers: {"Accept": "application/json"});
  if (response.statusCode == 200) {
    List fila = json.decode(response.body);
    return fila.map((data) => Lista.fromJson(data)).toList(); //Mapeando Obj de acordo com a minha classe
  } else {
    throw Exception('Erro inesperado...');
  }
}

/*
  Funcao que Exibe os Detalhes da rota GetDetalhe,
  Ela Exibe um ShowDialog com as informaçoes,
  E chama a funcao que calcula a quanto tempo a pessoan esta na fila.
*/ 
maisDetalhes(BuildContext context, int id) async {

  http.get(Uri.parse('$url/getDetalhe.php?id=$id'),
    headers: {"Accept": "application/json"}
    ).then((data) {

      List<dynamic> jsonData = json.decode(data.body);
      List<Detalhes> dados =jsonData.map((data) => Detalhes.fromJson(data)).toList();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Id: ${dados.map((e) => e.id.toString()).first}'),
          content: SizedBox(
            width: 100,
            height: 95 ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dados.map((e) => e.nome).first}'),
                Text('Data: ${dados.map((e) => e.data).first}'),
                Text(tempoNaFila(dados.map((e) => e.data).first)),
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

//Funçao para a Remocao, ela recebe o context para que eu possa utiliza-lo no showDialog
Future<void> remove(BuildContext context,int id) {
  return http.delete( 
    Uri.parse('$url/delete.php?id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    } 
  ).then((response) {
      //retorna um showDialog com o Status e o body.
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Status :${response.statusCode.toString()}'),
                content: Text(response.body.toString()),
                actions: [
                  TextButton(
                      onPressed: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaLista(),
                            ),
                          )),
                      child: const Text('ok'))
                ],
              ));
    }).catchError((error) {
      //Em caso de Erro retorna um ShowDialog com o erro.
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: Text(error.toString()),
          actions: [
            TextButton(
                onPressed: (() => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaLista(),
                      ),
                    )),
                child: const Text('ok'))
          ],
        ),
      );
    });
}

//Funcao que calcula a quanto tempo esta na fila
  String tempoNaFila(String data){

   DateTime now = DateTime.now();
   DateTime naFila = DateTime.parse(data);

   int ano = now.year-naFila.year;
   int mes = now.month-naFila.month;
   int dia = now.day-naFila.day;
   int hora = now.hour-naFila.hour;
   int minuto = now.minute-naFila.minute;
   int segundo = now.second-naFila.second;

   /*uso o ReplaceAll pois nossa data atual pode ser menor que a da entrada na fila,
    O que geraria um sinal de negativo, então removo ele.*/
   return ('Está na fila há:\n$ano anos, $mes meses, $dia dias\n$hora hora, $minuto minutos, $segundo seg').replaceAll('-', '');

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
    /*
      Setando minha variavel url, com a Url que foi inserida no inicio,
      O Obj urlLida foi instanciado Na TelaInicial(Com a Url fornecida pelo usuario).
    */ 
    setState(() {
      url = urlLida.getUrl();
    });

    //Setando minha lista 
    setState(() {
      listaData = getLista();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagem')),
      drawer: const Drawer(
        child: Menu() // chamando minha classe menu,
      ),
      body: Column(
        children: [
          SizedBox(
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
                            //Tornando os itens da lista clicaveis.
                            InkWell(
                              //quando clicado chamo a funcao de detalhes.
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
                                    remove(context,data[index].id);
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
