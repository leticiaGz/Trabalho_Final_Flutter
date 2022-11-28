
import 'package:flutter/material.dart';
import 'package:trabalho_final/telaInicial.dart';
import 'package:trabalho_final/telaLista.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  String url = "";
  String horario = "";

Future<void> _criaUsuario(){
    final String nome = _formData['nome'] as String;
    final body= jsonEncode(<String, String>{
        'nome': nome,
        'data': horario,
      });
    print("Json : "+body);
  
    return http.post(
      Uri.parse('$url/insere.php'),
       headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
      
    ).then((response) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title:  Text(response.statusCode.toString()),
                actions: [
                  TextButton(
                      onPressed: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaInicial(),
                            ),
                          )),
                      child:  const Text('ok'))
                ],
              ));
    }).catchError((error) {
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
                        builder: (context) => const TelaInicial(),
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
    DateTime now = DateTime.now();

    setState(() {
      url = urlLida.getUrl();
    });

    setState(() {
      String year = now.year.toString().substring(2,4);
      String month = now.month.toString();
      String day = now.day.toString();
      String hour = now.hour.toString();
      String minute = now.minute.toString();
      String second = now.second.toString();

    //verificaçoes para adicionar 0 pois o flutter deixa apenas uma casa
      if(month.length==1) month='0$month';
      if(day.length==1) day='0$day';
      if(hour.length==1) hour='0$hour';
      if(minute.length==1) minute='0$minute';
      if(second.length==1) second='0$second';
      

      horario = '$day/$month/$year $hour:$minute:$second';

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Entrar na fila'),
      ),
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
                            const InputDecoration(label: Text('Digite o nome'))
                            ,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _criaUsuario,
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
