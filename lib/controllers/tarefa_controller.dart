import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/tarefa_model.dart';

class TarefaController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<Tarefa> tarefas = <Tarefa>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bindTarefasUser();
  }

  void _bindTarefasUser() {
    String uid = _auth.currentUser!.uid;

    tarefas.bindStream(
      _db
          .collection('tarefas')
          .where('userId', isEqualTo: uid)
          .orderBy('data_criacao', descending: true)
          .snapshots()
          .map((query) {
            return query.docs.map((doc) => Tarefa.fromDocument(doc)).toList();
          }),
    );
  }

  Future<void> adicionarTarefa(
    String titulo,
    String descricao,
    DateTime? data,
  ) async {
    try {
      String uid = _auth.currentUser!.uid;

      Tarefa novaTarefa = Tarefa(
        titulo: titulo,
        descricao: descricao,
        userId: uid,

        dataVencimento: data != null ? Timestamp.fromDate(data) : null,
      );

      await _db.collection('tarefas').add(novaTarefa.toMap());
    } catch (e) {
      Get.snackbar("Erro", "Não foi possível salvar a tarefa");
    }
  }

  Future<void> atualizarTarefa(
    String id,
    String novoTitulo,
    String novaDescricao,
    DateTime? novaData,
  ) async {
    await _db.collection('tarefas').doc(id).update({
      'titulo': novoTitulo,
      'descricao': novaDescricao,
      'dataVencimento': novaData != null ? Timestamp.fromDate(novaData) : null,
    });
  }

  Future<void> alternarConcluida(Tarefa tarefa) async {
    await _db.collection('tarefas').doc(tarefa.id).update({
      'concluida': !tarefa.concluida,
    });
  }

  Future<void> excluirTarefa(String id) async {
    await _db.collection('tarefas').doc(id).delete();
  }
}
