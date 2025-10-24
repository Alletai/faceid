CityLabSecurity — Flutter + Bootstrap (Mobile)

Sistema mobile de monitoramento e identificação facial (layout pixel-perfect a partir das telas anexas), preparado para integração futura com Firebase e backend via Dio.
Este repositório entrega layout, navegação, estados simulados e paginação, sem lógica de IA/streaming/hardware.

Sumário

Visão Geral

Stack Técnica

Pré-requisitos

Como criar o projeto e instalar dependências

Executar

Estrutura de Pastas

Arquitetura e Padrões

Rotas e Navegação

Tema e Sistema Visual

Funcionalidades Implementadas

Paginação (mock)

Integração futura: Firebase

Integração futura: Backend (Dio)

Modelagem e Serialização

Qualidade de Código

Build e Distribuição

Testes (sugestão)

Checklist de Aceitação

Troubleshooting

Roadmap / TODO

Licença

Visão Geral

App mobile em Flutter com visual inspirado nas telas anexas (tema escuro azul + acentos ciano).

Sem IA/streaming real: apenas placeholders e fluxos de UI.

Pronto para escalar: Riverpod, go_router, Dio, paginação, stubs do Firebase e repositórios.

Stack Técnica

Flutter (canal estável atual)

Dart

UI/Layout

flutter_bootstrap_widgets (grid/utilitários Bootstrap)

bootstrap_icons (ícones)

Navegação: go_router

Estado: flutter_riverpod

HTTP: dio

Paginação: infinite_scroll_pagination

Firebase (stubs): firebase_core, cloud_firestore

Modelos/Serialização (preparado): freezed_annotation, json_annotation (+ build_runner, freezed, json_serializable dev)

Pré-requisitos

Flutter SDK instalado e configurado (flutter doctor OK).

Android SDK / Xcode conforme plataforma alvo.

Dispositivo/emulador disponível.

Como criar o projeto e instalar dependências

Execute exatamente estes comandos:

flutter create faceid_monitor
cd faceid_monitor

flutter pub add flutter_bootstrap_widgets bootstrap_icons go_router flutter_riverpod dio infinite_scroll_pagination firebase_core cloud_firestore freezed_annotation json_annotation
flutter pub add --dev build_runner freezed json_serializable


Crie/ajuste analysis_options.yaml:

include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    directives_ordering: true
    avoid_print: true
    unnecessary_this: true


O código-fonte abaixo deve ser colocado conforme a Estrutura de Pastas.

Executar
flutter pub get
flutter run


O app inicia no Dashboard.

A inicialização do Firebase está protegida: se não houver google-services.*, o app continua normalmente.

Estrutura de Pastas
lib/
  main.dart
  app.dart
  routes/
    app_router.dart
  theme/
    app_theme.dart
  widgets/
    app_appbar.dart
    app_drawer.dart
    app_empty_state.dart
    app_error_state.dart
    app_loading_indicator.dart
    k_spacers.dart
  features/
    dashboard/
      ui/dashboard_page.dart
      ui/widgets/camera_panel.dart
      ui/widgets/stats_row.dart
      state/dashboard_controller.dart
    logs/
      ui/logs_page.dart
      ui/widgets/log_item.dart
      state/logs_controller.dart
      data/logs_repository.dart
    capture/
      ui/capture_page.dart
      ui/widgets/capture_preview.dart
      state/capture_controller.dart
    recordings/
      ui/recordings_page.dart
      ui/widgets/recording_item.dart
      state/recordings_controller.dart
      data/recordings_repository.dart
  services/
    backend/
      api_client.dart
      firebase_stub.dart
      repositories_stub.dart

Arquitetura e Padrões

Feature-first: cada módulo (dashboard, logs, capture, recordings) agrupa UI, estado e dados.

Riverpod (StateNotifier) para controle de estado desacoplado.

Repositórios mock para dados simulados e paginação.

Widgets compartilhados em lib/widgets (loading, empty, error, appbar, drawer, spacers).

Tema único em theme/app_theme.dart.

Rotas e Navegação

go_router com rotas nomeadas:

Rota	Caminho	Tela
dashboard	/	Dashboard
logs	/logs	Logs
capture	/capture	Captura de fotos
recordings	/recordings	Gravações

Navegação principal via BottomNavigationBar (4 itens) + Drawer.

Tema e Sistema Visual

Tema escuro (scaffoldBackgroundColor azul-marinho).

Cards com cantos 14 px e cor mais clara.

Botões primários ciano (Stadium), hover/press sutil.

InputDecoration consistente para campos.

BootstrapThemeProvider configurado para grid/responsividade.

Ícones: bootstrap_icons.

Ajustes no tema: lib/theme/app_theme.dart.

Funcionalidades Implementadas
Dashboard

Saudação (“Bom dia, Olá, Usuário!”).

KPIs: identificações do dia, taxa de acerto, alertas, uptime.

Painel da câmera (placeholder 16:9) com badge LIVE, FPS simulado, Atualizar, Reconectar/Desconectar.

Ações Rápidas: Logs, Fotos, Gravações.

Logs (paginação)

Lista paginada com infinite_scroll_pagination.

Itens com hora, nível (info/warning/error), título e subtítulo.

Estados de carregando/erro/vazio.

Captura

Preview estático.

Capturar, Descartar, Salvar rascunho (limpar sessão).

Grid de miniaturas da sessão (mock).

Gravações (paginação)

Lista paginada por horário.

Item com thumb (placeholder), duração e ação Reproduzir (snack).

Paginação (mock)

Logs: features/logs/data/logs_repository.dart

fetchLogs(page, pageSize) com Future.delayed e fim de lista após N páginas.

Controlador: PagingController<int, LogEntry> em logs_controller.dart.

Gravações: features/recordings/data/recordings_repository.dart

fetchPage(page, pageSize) semelhante ao acima.

Controlador: PagingController<int, RecordingItemModel>.

Estados cobertos: carregando da primeira página, carregando nova página, erro, vazio e fim de lista.

Integração futura: Firebase

Arquivo: services/backend/firebase_stub.dart

Future<void> initFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // TODO: inserir FirebaseOptions quando disponível:
    // await Firebase.initializeApp(options: const FirebaseOptions(...));
  }
}


Passos quando houver projeto:

Adicionar google-services.json (Android) / GoogleService-Info.plist (iOS).

Se necessário, usar FirebaseOptions manuais (web/desktop).

Criar coleções (ex.: logs, recordings, captures) e substituir repositórios mock por datasources Firestore.

Integração futura: Backend (Dio)

Arquivo: services/backend/api_client.dart

ApiClient.instance.dio com LogInterceptor já ativo.

Definir baseUrl e criar datasources por feature.

Substituir repositórios mock por implementações HTTP (ou híbridas com Firestore).

Modelagem e Serialização

Pacotes configurados: freezed_annotation e json_annotation.

Para gerar modelos:

Criar arquivo *.dart com @freezed/@JsonSerializable.

Rodar:

flutter pub run build_runner build --delete-conflicting-outputs


Exemplos podem ser adicionados em features/.../models/.

Qualidade de Código

Lints: flutter_lints + regras adicionais no analysis_options.yaml.

Componentização: widgets reutilizáveis em lib/widgets.

Imutabilidade: const sempre que possível.

Sem print: use debugPrint se necessário.

Build e Distribuição

Android:

flutter build apk --release


iOS:

flutter build ipa --release


Web (opcional):

flutter build web


Configure assinaturas/plists/manifest conforme necessidade do seu ambiente.

Testes (sugestão)

Widget tests para:

Render de KPIs e CameraPanel.

Paginação (simular PagingController).

Unit tests para repositórios mock.

Exemplo boilerplate:

flutter test

Checklist de Aceitação

 Projeto compila com flutter run sem erros.

 Estrutura de pastas idêntica à definida.

 Rotas nomeadas funcionando (/, /logs, /capture, /recordings).

 Dashboard, Logs, Captura, Gravações fiéis ao layout.

 Paginação dinâmica em Logs e Gravações (mock).

 Uso de flutter_bootstrap_widgets no layout.

 Ícones via bootstrap_icons.

 Stubs para Firebase e Dio prontos.

 Lints ativos e código limpo.

 README presente (este arquivo).

Troubleshooting

1) Erro ao inicializar Firebase

Mensagem comum: “[core/no-app] No Firebase App…”.
→ Sem google-services.*, o stub ignora e segue. É esperado em desenvolvimento sem config.
→ Para integrar, adicione os arquivos nativos ou FirebaseOptions.

2) Lista não pagina

Verifique logs_controller.dart/recordings_controller.dart: _pageSize e limite de páginas mock.

Use pagingController.refresh() para reiniciar o fluxo.

3) Tema não aplica

Confirme o uso de BootstrapThemeProvider em app.dart.

Ajuste cores em theme/app_theme.dart.

4) Fonts e pixel-perfect

O projeto usa fontes do sistema. Se desejar precisão extra, adicione a família (ex.: Inter) em pubspec.yaml e ajuste textTheme.

Roadmap / TODO

 Substituir repositórios mock por Firestore/HTTP reais.

 Criar modelos freezed para Logs/Recordings/Captures.

 Player de gravações com modal/sheet e controles.

 Filtros de Logs (data, severidade, status) com UI dedicada.

 Estados extras: “offline” com banner e ação de reconectar.

 Testes unitários/widget e CI (GitHub Actions).

 Internacionalização (i18n) com flutter_localizations.

 Acessibilidade: labels semânticos e tamanhos dinâmicos.

Licença

Projeto interno/educacional. Defina a licença conforme a política da sua organização (ex.: MIT, Apache-2.0 ou proprietária).

Contato e Manutenção

Time de TI / Mobile.

Ajustes de visual: theme/app_theme.dart e widgets em lib/widgets.

Integração: services/backend/* e features/*/data/.
