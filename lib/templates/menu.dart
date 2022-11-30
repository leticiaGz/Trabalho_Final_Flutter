import 'package:flutter/material.dart';
import 'package:trabalho_final/Pages/tela_inicial.dart';
import 'package:trabalho_final/Pages/tela_cadastro.dart';
import 'package:trabalho_final/Pages/tela_lista.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Container azul
        Container(
          alignment: Alignment.center,
          width: 310,
          height: 150,
          color: Colors.blue,
          child: const Text(
            'Bem Vindo!!',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        //Elemento que redireciona para tela Inicial
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 30, 0, 0),
          child: ListTile(
            leading: const Icon(Icons.qr_code_2_outlined),
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
        //Elemento que redireciona para tela de Lista
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: ListTile(
            leading: const Icon(Icons.list_alt_outlined),
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
        //Elemento que redireciona paea tela De cadastro
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: ListTile(
            leading: const Icon(Icons.person),
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
    );
  }
}
