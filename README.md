# Desafio Flutter - Lista de Tarefas (To-Do List)

Este projeto é um aplicativo de gerenciamento de tarefas com sincronização em tempo real, desenvolvido como parte do desafio técnico para a vaga de desenvolvedor Flutter.

## 📱 Funcionalidades

- **Autenticação Completa:** Cadastro e Login de usuários via E-mail/Senha (Firebase Auth).
- **Gerenciamento de Tarefas (CRUD):**
  - Criar tarefas com Título, Descrição e Data de Vencimento.
  - Editar tarefas existentes.
  - Excluir tarefas.
  - Marcar como concluída (com feedback visual).
- **Sincronização em Tempo Real:** A lista é atualizada instantaneamente entre todos os dispositivos conectados usando `Streams` do Firestore.
- **Feedback Visual:**
  - Tarefas atrasadas são destacadas em vermelho.
  - Indicadores visuais de status (riscado quando concluído).

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Dart
- **Framework:** Flutter (Compatível com Android/iOS)
- **Gerenciamento de Estado:** GetX
- **Backend:** Firebase (Authentication e Cloud Firestore)
- **Manipulação de Datas:** Pacote `intl`

## 🏗️ Arquitetura e Decisões de Design

O projeto segue o padrão **MVC (Model-View-Controller)** para garantir a separação de responsabilidades e escalabilidade.

### Estrutura de Pastas:

- `lib/models`: Contém a classe `tarefa_model`, responsável por mapear os dados do Firestore para objetos Dart.
- `lib/views`: Interface do usuário (`login_page`, `home_page`), responsável apenas pela renderização dos componentes visuais.
- `lib/controllers`: Lógica de negócios (`auth_controller`, `tarefa_controller`).

## ✅ Como o Aplicativo Atende aos Requisitos

1.  **Autenticação de Usuário:**

    - Utilizei o **Firebase Authentication** para gerenciar o cadastro e login seguro.
    - A sessão do usuário é persistida, permitindo que ele feche e abra o app sem precisar logar novamente.

2.  **Gerenciamento de Tarefas:**

    - Implementei um CRUD completo conectado ao **Cloud Firestore**.
    - Adicionei o campo "Data de Vencimento" (conforme solicitado na descrição funcional) usando o componente `showDatePicker`.

3.  **Sincronização em Tempo Real:**

    - Em vez de chamadas únicas (`get`), utilizei **Streams** (`snapshots`) do Firestore.
    - Isso garante que qualquer alteração no banco de dados (feita em outro dispositivo) reflita **instantaneamente** na lista do usuário, sem necessidade de "puxar para atualizar".

4.  **Arquitetura e Padrões (MVC + GetX):**
    - O código está estritamente separado em **Model** (dados), **View** (interface) e **Controller** (lógica).
    - O **GetX** foi utilizado para injeção de dependência e gerenciamento de estado reativo, garantindo que a interface responda às mudanças de dados de forma performática.

## 🚀 Como Rodar o Projeto

### Pré-requisitos

- Flutter SDK instalado.
- Emulador Android ou dispositivo físico.

### Passo a Passo

1.  Clone este repositório:
    ```bash
    git clone [https://github.com/heitorhidalgo/desafio-flutter-lista-tarefas.git](https://github.com/heitorhidalgo/desafio-flutter-to-do-list)
    ```
2.  Instale as dependências:
    ```bash
    flutter pub get
    ```
3.  Execute o aplicativo:
    ```bash
    flutter run
    ```
    _Obs: Caso utilize o emulador no Windows e encontre problemas de renderização, utilize:_
    ```bash
    flutter run --no-enable-impeller
    ```

## 🔮 Possíveis Melhorias e Funcionalidades Futuras

1.  **Notificações Push:** Implementar o _Firebase Cloud Messaging_ para notificar o usuário quando uma tarefa estiver prestes a vencer.
2.  **Categorias e Filtros:** Adicionar um sistema de etiquetas (tags) para filtrar tarefas por contexto (ex: Trabalho, Pessoal, Estudos).
3.  **Busca Textual:** Implementar uma barra de pesquisa para localizar tarefas específicas pelo título.
4.  **Testes Automatizados:** Adicionar testes unitários (para os Controllers e Models) e testes de widget para garantir a estabilidade do código a longo prazo.
5.  **Modo Escuro (Dark Mode):** Implementar tema escuro nativo utilizando o gerenciamento de temas do GetX.

## 👨‍💻 Autor

**[Linkedin](https://www.linkedin.com/in/heitorhidalgo/)**

**[GitHub](https://github.com/heitorhidalgo)**
