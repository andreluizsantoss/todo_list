import 'dart:convert';

class TodoModel {
  int id;
  String descricao;
  DateTime datahora;
  bool finalizado;

  TodoModel({
    this.id,
    this.descricao,
    this.datahora,
    this.finalizado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'datahora': datahora?.millisecondsSinceEpoch,
      'finalizado': finalizado,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoModel(
      id: map['id'],
      descricao: map['descricao'],
      datahora: DateTime.parse(map['data_hora']),
      finalizado: map['finalizado'] == 0 ? false : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));
}
