import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/tarefa_controller.dart';
import '../models/tarefa_model.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find();
  final TarefaController tarefaController = Get.put(TarefaController());

  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  final Rx<DateTime?> dataSelecionada = Rx<DateTime?>(null);

  HomePage({super.key});

  Future<void> _escolherData(BuildContext context) async {
    FocusScope.of(context).unfocus();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dataSelecionada.value = picked;
    }
  }

  void _abrirFormulario({BuildContext? context, Tarefa? tarefa}) {
    if (tarefa != null) {
      tituloCtrl.text = tarefa.titulo;
      descCtrl.text = tarefa.descricao;

      dataSelecionada.value = tarefa.dataVencimento?.toDate();
    } else {
      tituloCtrl.clear();
      descCtrl.clear();
      dataSelecionada.value = null;
    }

    Get.defaultDialog(
      title: tarefa == null ? "Nova Tarefa" : "Editar Tarefa",
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(
                labelText: "Título",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        dataSelecionada.value == null
                            ? "Escolher Vencimento"
                            : "Vence: ${DateFormat('dd/MM/yyyy').format(dataSelecionada.value!)}",
                      ),
                      onPressed: () {
                        if (Get.context != null) {
                          _escolherData(Get.context!);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: dataSelecionada.value != null
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),

                  if (dataSelecionada.value != null)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => dataSelecionada.value = null,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      textConfirm: "Salvar",
      textCancel: "Cancelar",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (tituloCtrl.text.isNotEmpty) {
          if (tarefa == null) {
            tarefaController.adicionarTarefa(
              tituloCtrl.text,
              descCtrl.text,
              dataSelecionada.value,
            );
          } else {
            tarefaController.atualizarTarefa(
              tarefa.id!,
              tituloCtrl.text,
              descCtrl.text,
              dataSelecionada.value,
            );
          }
          Get.back();
        } else {
          Get.snackbar("Erro", "O título é obrigatório");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        actions: [
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
              "Nenhuma tarefa.\nToque no + para começar!",
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: tarefaController.tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = tarefaController.tarefas[index];

            String dataTexto = "";
            bool atrasada = false;

            if (tarefa.dataVencimento != null) {
              DateTime dataVenc = tarefa.dataVencimento!.toDate();
              dataTexto = DateFormat('dd/MM/yyyy').format(dataVenc);

              final agora = DateTime.now();
              final hoje = DateTime(agora.year, agora.month, agora.day);

              if (dataVenc.isBefore(hoje) && !tarefa.concluida) {
                atrasada = true;
              }
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              color: atrasada
                  ? Colors.red[50]
                  : (tarefa.concluida ? Colors.grey[100] : null),
              child: ListTile(
                leading: Checkbox(
                  value: tarefa.concluida,
                  onChanged: (_) => tarefaController.alternarConcluida(tarefa),
                ),
                title: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: tarefa.concluida
                        ? TextDecoration.lineThrough
                        : null,
                    color: atrasada
                        ? Colors.red
                        : (tarefa.concluida ? Colors.grey : null),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tarefa.descricao.isNotEmpty) Text(tarefa.descricao),

                    if (dataTexto.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 14,
                              color: atrasada ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              atrasada
                                  ? "Venceu em: $dataTexto"
                                  : "Vence: $dataTexto",
                              style: TextStyle(
                                color: atrasada ? Colors.red : Colors.grey,
                                fontSize: 12,
                                fontWeight: atrasada
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                trailing: SizedBox(
                  width: 96,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _abrirFormulario(context: context, tarefa: tarefa),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            tarefaController.excluirTarefa(tarefa.id!),
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
        onPressed: () => _abrirFormulario(context: context),
      ),
    );
  }
}
