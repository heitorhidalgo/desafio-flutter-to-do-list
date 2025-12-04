import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/tarefa_controller.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find();

  final TarefaController tarefaController = Get.put(TarefaController());

  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        actions: [
          // Botão de Sair (Logout)
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authController.logout(),
          ),
        ],
      ),

      body: Obx(() {
        if (tarefaController.tarefas.isEmpty) {
          return const Center(
            child: Text(
              "Nenhuma tarefa ainda.\nClique no + para adicionar!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: tarefaController.tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = tarefaController.tarefas[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Checkbox(
                  value: tarefa.concluida,
                  onChanged: (bool? valor) {
                    tarefaController.alternarConcluida(tarefa);
                  },
                ),

                title: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: tarefa.concluida
                        ? TextDecoration.lineThrough
                        : null,
                    color: tarefa.concluida ? Colors.grey : null,
                  ),
                ),

                subtitle: Text(
                  tarefa.descricao,
                  style: TextStyle(
                    decoration: tarefa.concluida
                        ? TextDecoration.lineThrough
                        : null,
                    color: tarefa.concluida ? Colors.grey : null,
                  ),
                ),

                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          tituloCtrl.text = tarefa.titulo;
                          descCtrl.text = tarefa.descricao;

                          Get.defaultDialog(
                            title: "Editar Tarefa",
                            content: Column(
                              children: [
                                TextField(
                                  controller: tituloCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Título",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: descCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Descrição",
                                  ),
                                ),
                              ],
                            ),
                            textConfirm: "Salvar",
                            textCancel: "Cancelar",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              if (tituloCtrl.text.isNotEmpty) {
                                tarefaController.atualizarTarefa(
                                  tarefa.id!,
                                  tituloCtrl.text,
                                  descCtrl.text,
                                );
                                Get.back(); // Fecha a janela
                              } else {
                                Get.snackbar(
                                  "Erro",
                                  "O título não pode ser vazio",
                                );
                              }
                            },
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          tarefaController.excluirTarefa(tarefa.id!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          tituloCtrl.clear();
          descCtrl.clear();

          Get.defaultDialog(
            title: "Nova Tarefa",
            content: Column(
              children: [
                TextField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: "Título"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Descrição"),
                ),
              ],
            ),
            textConfirm: "Salvar",
            textCancel: "Cancelar",
            confirmTextColor: Colors.white,
            onConfirm: () {
              if (tituloCtrl.text.isNotEmpty) {
                tarefaController.adicionarTarefa(
                  tituloCtrl.text,
                  descCtrl.text,
                );
                Get.back();
              } else {
                Get.snackbar("Erro", "Digite um título!");
              }
            },
          );
        },
      ),
    );
  }
}
