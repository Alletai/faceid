# CityLabSecurity — Flutter + Bootstrap (Mobile)

Sistema mobile de monitoramento e identificação facial (layout **pixel-perfect** a partir das telas anexas), preparado para integração futura com **Firebase** e backend via **Dio**.  
Este repositório entrega **layout, navegação, estados simulados e paginação**, sem lógica de IA/streaming/hardware.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Stack Técnica](#stack-técnica)
- [Pré-requisitos](#pré-requisitos)
- [Como criar o projeto e instalar dependências](#como-criar-o-projeto-e-instalar-dependências)
- [Executar](#executar)
---

## Visão Geral

- App mobile em **Flutter** com visual inspirado nas telas anexas (tema escuro azul + acentos ciano).
- **Sem IA/streaming real**: apenas placeholders e fluxos de UI.
- **Pronto para escalar**: Riverpod, go_router, Dio, paginação, stubs do Firebase e repositórios.

---

## Stack Técnica

- **Flutter** (canal estável atual)
- **Dart**
- **UI/Layout**
  - `flutter_bootstrap_widgets` (grid/utilitários Bootstrap)
  - `bootstrap_icons` (ícones)
- **Navegação**: `go_router`
- **Estado**: `flutter_riverpod`
- **HTTP**: `dio`
- **Paginação**: `infinite_scroll_pagination`
- **Firebase (stubs)**: `firebase_core`, `cloud_firestore`
- **Modelos/Serialização (preparado)**: `freezed_annotation`, `json_annotation` (+ `build_runner`, `freezed`, `json_serializable` dev)

---

## Pré-requisitos

- Flutter SDK instalado e configurado (`flutter doctor` OK).
- Android SDK / Xcode conforme plataforma alvo.
- Dispositivo/emulador disponível.

---

## Como criar o projeto e instalar dependências

> Execute exatamente estes comandos:

```bash
flutter create faceid_monitor
cd faceid_monitor
flutter pub get
```

## Como rodar o projeto

```bash
flutter run
```
