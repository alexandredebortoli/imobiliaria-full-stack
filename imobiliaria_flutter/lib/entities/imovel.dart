import 'package:biblioteca_flutter/entities/tipoImovel.dart';

class ImovelData {
  int? id;
  TipoImovelData? tipoImovel;
  String? titulo;
  String? descricao;
  String? valor;
  DateTime? dataCriacao;


  ImovelData({this.id, this.descricao, this.titulo, this.valor, this.dataCriacao, this.tipoImovel});

  factory ImovelData.fromJson(Map<String, dynamic> json) {
    return ImovelData(
        id: json['id'],
        descricao: json['descricao'],
        titulo: json['titulo'],
        valor: json['valor'].toString(),
        tipoImovel: TipoImovelData.fromJson(json['tipoImovel']),
        dataCriacao: DateTime.parse(json['dataCriacao'])
    );
  }
}
