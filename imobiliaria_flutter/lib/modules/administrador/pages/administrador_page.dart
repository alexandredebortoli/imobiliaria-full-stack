import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:biblioteca_flutter/entities/administrador.dart';
import 'package:biblioteca_flutter/modules/login/pages/login_page.dart';
import 'package:biblioteca_flutter/config/api.dart';

class AdministradorPage extends StatefulWidget {
  const AdministradorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdministradorPageState();
}

Future<List<AdministradorData>> _fetchAdministradores() async {
  const url = '$baseURL/administradores';
  final preferences = await SharedPreferences.getInstance();
  final token = preferences.getString('auth_token');
  Map<String, String> headers = {};
  headers["Authorization"] = 'Bearer $token';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse
        .map((administrador) => AdministradorData.fromJson(administrador))
        .toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar os administradores!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0);
    throw ('Sem administradores');
  }
}

class _AdministradorPageState extends State<AdministradorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<AdministradorData>> futureAdministradores;

  @override
  void initState() {
    super.initState();
    futureAdministradores = _fetchAdministradores();
  }

  void submit(String action, AdministradorData administradorData) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (administradorData.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (administradorData.email == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o e-mail!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (action == "adicionar" && administradorData.senha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (action == "adicionar" && administradorData.confirmarSenha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a confirmação da senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (action == "adicionar" &&
          administradorData.senha != administradorData.confirmarSenha) {
        Fluttertoast.showToast(
            msg: 'As senhas não são iguais!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (action == "editar" &&
          administradorData.senha != "" &&
          administradorData.confirmarSenha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a confirmação da senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (action == "editar" &&
          administradorData.senha != "" &&
          administradorData.senha != administradorData.confirmarSenha) {
        Fluttertoast.showToast(
            msg: 'As senhas não são iguais!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        if (action == "adicionar") {
          _adicionarAdministrador(administradorData);
        } else {
          _editarAdministrador(administradorData);
        }
      }
    }
  }

  void _adicionarAdministrador(AdministradorData administradorData) async {
    const url = '$baseURL/administradores';
    var body = json.encode({
      'nome': administradorData.nome,
      'email': administradorData.email,
      'senha': administradorData.senha
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
            msg: 'Administrador Adicionado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Map<String, dynamic> responseMap = json.decode(response.body);
        if (responseMap["message"].contains('ConstraintViolationException')) {
          Fluttertoast.showToast(
              msg: 'E-mail duplicado!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        } else {
          Fluttertoast.showToast(
              msg: 'Erro ao inserir o administrador!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        }
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _editarAdministrador(AdministradorData administradorData) async {
    var id = administradorData.id;
    var url = '$baseURL/administradores/$id';
    var body = '';
    if (administradorData.senha != "") {
      body = json.encode({
        'nome': administradorData.nome,
        'email': administradorData.email,
        'senha': administradorData.senha
      });
    } else {
      body =
          json.encode({'nome': administradorData.nome, 'email': administradorData.email});
    }
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
            msg: 'Administrador Editado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Map<String, dynamic> responseMap = json.decode(response.body);
        if (responseMap["message"].contains('ConstraintViolationException')) {
          Fluttertoast.showToast(
              msg: 'E-mail duplicado!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        } else {
          Fluttertoast.showToast(
              msg: 'Erro ao editar o administrador!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        }
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _excluirAdministrador(int id) async {
    var url = '$baseURL/administradores/$id';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Administrador Excluído!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Erro ao excluir o administrador!',
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

  Future<void> _adicionarOuEditarAdministrador(AdministradorData administradorData) async {
    String action = 'adicionar';
    bool trocouSenha = false;
    if (administradorData.id != null) {
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
                      initialValue: administradorData.nome,
                      onSaved: (String? value) {
                        administradorData.nome = value!;
                      }),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'E-mail', labelText: 'E-mail'),
                      initialValue: administradorData.email,
                      onSaved: (String? value) {
                        administradorData.email = value!;
                      }),
                  TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Senha', labelText: 'Senha'),
                      initialValue: '',
                      onSaved: (String? value) {
                        if(value != "") {
                          administradorData.senha = value!;
                          trocouSenha = true;
                        }
                      }),
                  TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Confirmar Senha',
                          labelText: 'Confirmar Senha'),
                      initialValue: '',
                      onSaved: (String? value) {
                        if(trocouSenha == true) {
                          administradorData.confirmarSenha = value!;
                        } else {
                          administradorData.confirmarSenha = administradorData.senha;
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(action == 'adicionar' ? 'Adicionar' : 'Editar'),
                    onPressed: () {
                      submit(action, administradorData);
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
        title: const Text('Gerenciar Administradores'),
      ),
      body: Center(
        child: FutureBuilder<List<AdministradorData>>(
          future: futureAdministradores,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AdministradorData> _administrador = snapshot.data!;
              return ListView.builder(
                  itemCount: _administrador.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(_administrador[index].nome!),
                        subtitle: Text(_administrador[index].email!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _adicionarOuEditarAdministrador(_administrador[index])
                                          .whenComplete(() {
                                        setState(() {
                                          futureAdministradores = _fetchAdministradores();
                                        });
                                      })),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você deseja excluir o administrador "' +
                                            _administrador[index].nome! +
                                            '"?'),
                                    textOK: const Text('Sim'),
                                    textCancel: const Text('Não'),
                                  )) {
                                    _excluirAdministrador(_administrador[index].id!)
                                        .whenComplete(() {
                                      setState(() {
                                        futureAdministradores = _fetchAdministradores();
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
              return const Text("Sem administradores");
            }
            // By default show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

      // Ícone para dicionar um novo usuário
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarAdministrador(AdministradorData()).whenComplete(() {
          setState(() {
            futureAdministradores = _fetchAdministradores();
          });
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
