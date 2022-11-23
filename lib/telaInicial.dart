import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trabalho_final/controller/url_api.dart';
import 'telaLista.dart';

UrlApi urlLida = UrlApi();

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicial();
}

class _TelaInicial extends State<TelaInicial> {
 
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  lerQr() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "cancelar", false, ScanMode.QR);
    setState(() {
      urlLida.saveUrl(code);
    });
  }

  lerQrInput()  {
    String urlFinal = _formData['url'] as String;
    setState(() {
      urlLida.saveUrl(urlFinal);
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
              padding: const EdgeInsets.fromLTRB(5, 100,0, 0),
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
              height: 20,
              child: const  Text('Use o leitor Qr ou Digite a Url')
            ),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                child: const Text('Ler Qr'),
                onPressed: lerQr,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
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
