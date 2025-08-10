# Flutter State Management Lab — Pomodinho

> Laboratório comparativo de **gerências de estado** no Flutter, mantendo a mesma base de **Clean Architecture**. A ideia central: **a biblioteca não define o projeto** — a **arquitetura** e a **clareza de responsabilidades** tornam as mudanças simples e seguras.

---

## Motivação

Em quase toda comunidade de Flutter surge o dilema:  
**“BLoC é melhor que MobX?” “GetX ou Riverpod?”** …e dezenas de variações.

Este repositório demonstra que:

- Com **Clean Architecture** sólida, trocar a **camada de estado** é majoritariamente **mecânico**.  
- Mantemos o **ThemeController com `ValueNotifier`** (nativo) em todas as variações, provando que **misturar nativos com libs** é viável quando **bem delimitado**.  
- Domínio, casos de uso, repositórios e persistência **não mudam** ao alternar a gerência de estado.

---

## O App (paridade funcional entre branches)

**Pomodinho** é um Pomodoro minimalista com a mesma UX em todas as branches:

- **Start / Pause / Reset**  
- Alternância **Foco ↔ Pausa** ao concluir ciclo  
- **Sessões concluídas** (incrementa ao terminar Foco)  
- **Ajustes persistentes** (minutos foco/pausa via `SharedPreferences`)  
- **Progresso** e **tempo `mm:ss`** em tempo real  
- **Tema claro/escuro** com `ValueNotifier` (nativo)

---

## Branches

| Branch            | Gerência de estado                         | Observável/Builder principal         |
|-------------------|--------------------------------------------|--------------------------------------|
| `main`            | `ChangeNotifier` + `ValueNotifier` (nativo)| `AnimatedBuilder`                    |
| `state/provider`  | Provider + ChangeNotifier                  | `ChangeNotifierProvider` / `watch`   |
| `state/cubit`     | Cubit (flutter_bloc)                       | `BlocProvider` / `BlocBuilder`       |
| `state/bloc`      | Bloc (events + states)                     | `BlocProvider` / `BlocBuilder`       |
| `state/riverpod`  | StateNotifier (flutter_riverpod)           | `ProviderScope` / `ConsumerWidget`   |
| `state/getx`      | GetX (Rx + `Obx`)                          | `GetMaterialApp` / `Obx`             |
| `state/mobx`      | MobX (`Store`)                             | `Observer`                           |

> **DI**: usamos **GetIt** como contêiner de injeção em todas as branches (inclusive GetX/MobX).  
> **Tema**: `ThemeController` com `ValueNotifier` é mantido em todas.

---

## Arquitetura (Clean) e organização

```text
lib/
  app/
    app.dart
    theme/app_theme.dart           # ThemeController (ValueNotifier) + temas
    di/locator.dart                # GetIt (DI)
  core/
    utils/ticker.dart              # Stream periódico (1s)
    utils/time_formatter.dart      # "mm:ss"
  data/
    datasources/local/prefs_datasource.dart   # SharedPreferences
    models/pomodoro_settings_model.dart
    repositories/settings_repository_impl.dart
  domain/
    entities/pomodoro_settings.dart
    repositories/settings_repository.dart
    usecases/load_settings.dart
    usecases/save_settings.dart
  features/pomodoro/
    presentation/
      pages/pomodoro_page.dart
      state/
        controller_contract.dart   # Contrato comum (IPomodoroController)
        ...                        # Implementação específica por branch
  main.dart
```

### Contrato de Estado (fixo entre branches)

`IPomodoroController` expõe:

- **Estados**: `remainingSeconds`, `workMinutes`, `breakMinutes`, `isRunning`, `phase`, `sessionsDone`, `progress`  
- **Ações**: `init`, `start`, `pause`, `reset`, `updateSettings`

Cada branch implementa o contrato conforme sua lib (ou nativo).

---

## Requisitos

- Flutter **>= 3.3.0**  
- Dart SDK compatível com o `environment` do projeto  
- iOS/Android/Web conforme SDK do Flutter instalado

---

## Como executar

### 1) Clonar e instalar dependências
```bash
git clone https://github.com/HamzeJihad/flutter-state-management-lab.git
cd flutter-state-management-lab
flutter pub get
```

### 2) Selecionar uma branch
```bash
git checkout main              # baseline nativo
# ou:
git checkout state/provider
git checkout state/cubit
git checkout state/bloc
git checkout state/riverpod
git checkout state/getx
git checkout state/mobx
```

### 3) MobX (apenas em `state/mobx`)
```bash
dart run build_runner build --delete-conflicting-outputs
# ou:
dart run build_runner watch --delete-conflicting-outputs
```

### 4) Rodar o app
```bash
flutter run
```

---

## Como comparar as gerências

Avalie com base em:

- **Boilerplate** (linhas e arquivos necessários)  
- **Ergonomia** (facilidade de atualizar estado/derivar dados)  
- **Testabilidade** (mocks, fakes, controle do ticker)  
- **Observabilidade** (logs de eventos/estados no Bloc)  
- **Aderência** ao time/stack do seu projeto

> O objetivo não é “eleger uma vencedora”, e sim evidenciar que **com base arquitetural forte** qualquer opção se torna viável.

---

## Decisões de design

- **Clean Architecture** acima de tudo: Domínio e Dados **inalterados** entre branches.  
- **Tema com `ValueNotifier`**: nativo por escolha — comprova que “misturar” é seguro quando bem isolado.  
- **GetIt como DI**: inicialização previsível e padronizada, facilitando comparação.  
- **Ticker** em `core`: facilita testes e substituição.

---

## Contribuição

PRs são bem-vindos para:

- Ajustes de documentação  
- Adição de testes  
- Melhorias de ergonomia por branch (sem alterar o escopo funcional)

