class AdministradorData {
  int? id;
  String? nome;
  String? email;
  String? senha;
  String? confirmarSenha;

  AdministradorData(
      {this.id, this.nome, this.email, this.senha, this.confirmarSenha});

  factory AdministradorData.fromJson(Map<String, dynamic> json) {
    return AdministradorData(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      confirmarSenha: '',
    );
  }
}
