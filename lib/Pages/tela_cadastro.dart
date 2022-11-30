import 'package:flutter/material.dart';
import 'package:trabalho_final/Pages/tela_inicial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:trabalho_final/Pages/tela_lista.dart';
import 'package:trabalho_final/templates/menu.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>(); //key do Form
  final _formData = <String, Object>{}; //onde salvo on valor do Input
  final formata = DateFormat('yy/MM/dd HH:mm:ss'); 
  String url = "";
  String horario = "";

  //Funcao que adiciona na lista.
  Future<void> _adicionaLista() {
    final String nome = _formData['nome'] as String;
    return http.post(
      Uri.parse('$url/insere.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nome,
        'data': horario.toString(), //minha variavel horario que foi setada no initState
      }),
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

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now(); //Pegando data atual

    /*Setando minha variavel url, com a Url que foi inserida no inicio,
    O Obj urlLida foi instanciado Na TelaInicial(Com a Url fornecida pelo usuario).*/ 
    setState(() {
      url = urlLida.getUrl();
    });

    //setando a variavel horario, com a data atual ja formatada
    setState(() {
      horario = formata.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar na fila'),
      ),
      drawer: const Drawer(
        child: Menu() // chamando minha classe menu
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 65,
                      child: TextFormField(
                        textInputAction: TextInputAction.send,
                        onChanged: (nome) => _formData['nome'] = nome ?? '',
                        decoration:
                            const InputDecoration(label: Text('Digite o nome')),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _adicionaLista,
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
