import 'package:cloud_firestore/cloud_firestore.dart';

class Tarefa {
  String? id;
  String titulo;
  String descricao;
  bool concluida;
  String userId;
  Timestamp? dataVencimento;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    this.concluida = false,
    required this.userId,
    this.dataVencimento,
  });

  factory Tarefa.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tarefa(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      concluida: data['concluida'] ?? false,
      userId: data['userId'] ?? '',
      dataVencimento: data['dataVencimento'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'concluida': concluida,
      'userId': userId,
      'data_criacao': FieldValue.serverTimestamp(),
      'dataVencimento': dataVencimento,
    };
  }
}
