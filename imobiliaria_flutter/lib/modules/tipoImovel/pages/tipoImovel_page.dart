import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:biblioteca_flutter/entities/tipoImovel.dart';
import 'package:biblioteca_flutter/modules/login/pages/login_page.dart';
import 'package:biblioteca_flutter/config/api.dart';

class TipoImovelPage extends StatefulWidget {
  const TipoImovelPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TipoImovelPageState();
}

Future<List<TipoImovelData>> _fetchTiposImoveis() async {
  const url = '$baseURL/tipos-imoveis';
  final preferences = await SharedPreferences.getInstance();
  final token = preferences.getString('auth_token');
  Map<String, String> headers = {};
  headers["Authorization"] = 'Bearer $token';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((tipoImovel) => TipoImovelData.fromJson(tipoImovel)).toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar os tipos de imóveis!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem tipos de imóveis');
  }
}

class _TipoImovelPageState extends State<TipoImovelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<TipoImovelData>> futureTiposImoveis;

  @override
  void initState() {
    super.initState();
    futureTiposImoveis = _fetchTiposImoveis();
  }

  void submit(String action, TipoImovelData tipoImovelData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (tipoImovelData.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarTipoImovel(tipoImovelData);
        } else {
          _editarTipoImovel(tipoImovelData);
        }
      }
    }
  }

  void _adicionarTipoImovel(TipoImovelData tipoImovelData) async {
    const url = '$baseURL/tipos-imoveis';
    var body =
        json.encode({'nome': tipoImovelData.nome});
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = 'Bearer $token';
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Tipo de Imóvel Adicionado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao inserir o tipo de imóvel!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _editarTipoImovel(TipoImovelData tipoImovelData) async {
    var id = tipoImovelData.id;
    var url = '$baseURL/tipos-imoveis/$id';
    var body = json.encode({
      'nome': tipoImovelData.nome,
    });
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = 'Bearer $token';
    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Tipo de Imóvel Editado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao editar o tipo de imóvel!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _excluirTipoImovel(int id) async {
    var url = '$baseURL/tipos-imoveis/$id';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Tipo de Imóvel Excluído!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir o tipo de imóvel!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _adicionarOuEditarTipoImovel(TipoImovelData tipoImovelData) async {
    String action = 'adicionar';
    if (tipoImovelData.id != null) {
      action = 'editar';
    }
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Nome', labelText: 'Nome'),
                      initialValue: tipoImovelData.nome,
                      onSaved: (String? value) {
                        tipoImovelData.nome = value!;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                    onPressed: () {
                      submit(action, tipoImovelData);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('auth_token');
      if (token == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Gerenciar Tipos de Imóveis'),
      ),
      body: Center(
        child: FutureBuilder<List<TipoImovelData>>(
          future: futureTiposImoveis,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<TipoImovelData> _tipoImovel = snapshot.data!;
              return ListView.builder(
                  itemCount: _tipoImovel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_tipoImovel[index].nome!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _adicionarOuEditarTipoImovel(_tipoImovel[index])
                                          .whenComplete(() {
                                        setState(() {
                                          futureTiposImoveis = _fetchTiposImoveis();
                                        });
                                      })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir o tipo de imóvel "' +
                                            _tipoImovel[index].nome! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirTipoImovel(_tipoImovel[index].id!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureTiposImoveis = _fetchTiposImoveis();
                                      });
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Text("Sem tipos de imóveis");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      // Ícone para adicionar um novo tipo de imóvel
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditarTipoImovel(TipoImovelData()).whenComplete(() {
          setState(() {
            futureTiposImoveis = _fetchTiposImoveis();
          });
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
