import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:biblioteca_flutter/entities/imovel.dart';
import 'package:biblioteca_flutter/modules/login/pages/login_page.dart';
import 'package:biblioteca_flutter/config/api.dart';
import 'package:biblioteca_flutter/entities/tipoImovel.dart';

class ImovelPage extends StatefulWidget {
  const ImovelPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImovelPageState();
}

Future<List<ImovelData>> _fetchImoveis() async {
  const url = '$baseURL/imoveis';
  final preferences = await SharedPreferences.getInstance();
  final token = preferences.getString('auth_token');
  Map<String, String> headers = {};
  headers["Authorization"] = 'Bearer $token';
  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((imovel) => ImovelData.fromJson(imovel))
          .toList();
    } else {
      Fluttertoast.showToast(
          msg: 'Erro ao listar os imóveis!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          fontSize: 20.0);
      throw ('Sem imóveis');
    }
  } on Object catch (error) {
    if (kDebugMode) {
      print(error);
    }
    return [];
  }
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

class _ImovelPageState extends State<ImovelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<ImovelData>> futureImoveis;
  var df = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    futureImoveis = _fetchImoveis();
  }

  void submit(String action, ImovelData imovelData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if(imovelData.titulo == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o título!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if(imovelData.descricao == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a descrição!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if(imovelData.valor == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o valor!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (imovelData.tipoImovel?.id == null) {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o tipo de imóvel!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarImovel(imovelData);
        } else {
          _editarImovel(imovelData);
        }
      }
    }
  }

  void _adicionarImovel(ImovelData imovelData) async {
    const url = '$baseURL/imoveis';
    var body = json.encode({
      'titulo': imovelData.titulo,
      'descricao': imovelData.descricao,
      'valor': imovelData.valor,
      'tipoImovel': {'id': imovelData.tipoImovel?.id},
    });
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
            msg: 'Imóvel Adicionado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao adicionar o imóvel!',
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

  void _editarImovel(ImovelData imovelData) async {
    var id = imovelData.id;
    var url = '$baseURL/imoveis/$id';
    var body = json.encode({
      'titulo': imovelData.titulo,
      'descricao': imovelData.descricao,
      'valor': double.parse(imovelData.valor.toString()),
      'tipoImovel': {'id': imovelData.tipoImovel?.id},
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
            msg: 'Imóvel Editado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao editar o imóvel!',
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

  Future<void> _excluirImovel(int id) async {
    var url = '$baseURL/imoveis/$id';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Imóvel Excluído!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir o imóvel!',
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

  Future<void> _adicionarOuEditarImovel(ImovelData imovelData) async {
    String action = 'adicionar';
    if (imovelData.id != null) {
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
                          hintText: 'Título', labelText: 'Título'),
                      initialValue: imovelData.titulo,
                      onSaved: (String? value) {
                        imovelData.titulo = value!;
                      }),
                  TextFormField(
                      maxLines: 8,
                      decoration: const InputDecoration(
                          hintText: 'Descrição', labelText: 'Descrição'),
                      initialValue: imovelData.descricao,
                      onSaved: (String? value) {
                        imovelData.descricao = value!;
                      }),
                  TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Valor', labelText: 'Valor'),
                      initialValue: imovelData.valor,
                      onSaved: (String? value) {
                        imovelData.valor = value!;
                      }),
                  FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1))
                          .then((value) => _fetchTiposImoveis()),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final List<TipoImovelData> _tipoImovel = snapshot.data;
                          return DropdownButton<String>(
                            onChanged: (String? value) {
                              setState(() {
                                imovelData.tipoImovel = TipoImovelData(
                                    id: int.parse(value.toString()));
                              });
                            },
                            items: _tipoImovel.map((map) {
                              return DropdownMenuItem(
                                child: Text(map.nome!),
                                value: map.id.toString(),
                              );
                            }).toList(),
                            value: imovelData.tipoImovel?.id.toString(),
                            hint: const Text('Selecione um tipo de imóvel'),
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                Text('Carregando tipos de imóveis'),
                              ],
                            ),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                    onPressed: () {
                      submit(action, imovelData);
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
      appBar: AppBar(
        title: const Text('Gerenciar Imóveis'),
      ),
      body: Center(
        child: FutureBuilder<List<ImovelData>>(
          future: futureImoveis,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ImovelData> _imovel = snapshot.data!;
              return ListView.builder(
                  itemCount: _imovel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_imovel[index].titulo!),
                        subtitle: Text(
                            'Tipo de Imóvel: ${_imovel[index].tipoImovel!.nome!}\nData: ${df.format(_imovel[index].dataCriacao!)}\nValor: ${_imovel[index].valor!}\nDescrição: ${_imovel[index].descricao!}'),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _adicionarOuEditarImovel(_imovel[index])
                                        .whenComplete(() {
                                      setState(() {
                                        futureImoveis = _fetchImoveis();
                                      });
                              })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir o imóvel "' +
                                            _imovel[index].titulo! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirImovel(_imovel[index].id!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureImoveis = _fetchImoveis();
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
              return const Text("Sem imóveis");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      // Ícone para dicionar um novo imóvel
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarImovel(ImovelData()).whenComplete(() {
          setState(() {
            futureImoveis = _fetchImoveis();
          });
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
