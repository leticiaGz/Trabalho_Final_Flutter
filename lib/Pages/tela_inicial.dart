import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trabalho_final/templates/menu.dart';
import 'package:trabalho_final/controller/url_api.dart';

//Instanciando Obj para Salvar a Url Lida,
//Ele ficara disponivel em todas as classes.
UrlApi urlLida = UrlApi();

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicial();
}

class _TelaInicial extends State<TelaInicial> {
  final _formKey = GlobalKey<FormState>(); //key do Formulario
  final _formData = <String, Object>{}; //Obj que guardo os valores do input

 //lendo codigo Qr com o pacote,
 //E salvando minha url, chamando um metodo da minha classe UrlApi.
  lerQr() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "cancelar", false, ScanMode.QR);
    setState(() {
      urlLida.setUrl(code);
    });
  }

  //Salvando a Url Atraves do Input.
  lerQrInput() {
    String urlFinal = _formData['url'] as String;
    setState(() {
      urlLida.setUrl(urlFinal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe sua Api')
      ),
      drawer: const Drawer(
        child: Menu() //chamando minha classe Menu
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                height: 20, child: Text('Use o leitor Qr ou Digite a Url')),
            //Botao para Ler Atraves do Qr
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: lerQr,
                child: const Text('Ler Qr'),
              ),
            ),
            //Form para ler através do Input
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 65,
                    child: TextFormField(
                      textInputAction: TextInputAction.send,
                      onChanged: (url) => _formData['url'] = url ?? '',
                      decoration:
                          const InputDecoration(label: Text('Digite a Url')),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: lerQrInput,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
