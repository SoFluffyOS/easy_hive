# Easy Hive

[Easy Hive](https://pub.dev/packages/easy_hive) is wrapper of [Hive](https://pub.dev/packages/hive) database for
easier & simpler usage.

## Outline 📋

- [Features](#features-)
- [Installation](#installation-)
- [Usage](#usage-)
- [Advanced Usage](#advanced-usage-)

## Features 🎁

| Easy                | 🦊  |
|---------------------|-----|
| 🔐 Encryption       | ✅   |
| 🐢 Lazy loading     | ✅   |
| 🔑 Enum key support | ✅   |
| 🎧 Listenable       | ✅   |

## Installation 💻

Add `easy_hive` to your `pubspec.yaml`:

```yaml

dependencies:

  easy_hive: ^1.0.1+2

```

Install it:

```sh

flutter pub get

```

## Usage 📖

You can either define your boxes as _Singleton_ classes **or** use a service locator like [
_get_it_](https://pub.dev/packages/get_it).

### 1. Define box keys 🔑

```dart
enum Settings {
  key, // Use as box key. You can use a String constant instead.

  /// Other keys below...
  themeMode,
  counter,
}
```

### 1. Define a box 📦

```dart

import 'package:easy_hive/easy_hive.dart';

class SettingsBox extends EasyBox {
  @override
  String get boxKey => Settings.key.toString();

  /// Singleton.
  static final SettingsBox _instance = SettingsBox._();

  factory SettingsBox() => _instance;

  SettingsBox._();
}

```

<details>
<summary>Or to use with get_it</summary>

```dart

import 'package:easy_hive/easy_hive.dart';

class SettingsBox extends EasyBox {
  @override
  String get boxKey => Settings.key.toString();
}

```

</details>

### 2. Initialize box 🚀

```dart

import 'package:easy_hive/easy_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await SettingsBox().init();

  // runApp...
}

```

<details>
<summary>Or to use with get_it</summary>

```dart

import 'package:easy_hive/easy_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final settingsBox = SettingsBox();
  await settingsBox.init();
  GetIt.I.registerSingleton<SettingsBox>(settingsBox);

  // runApp...
}

```

</details>

### 3. Define getter & setter for your data 💄

```dart
extension GeneralSettingsExtension on SettingsBox {
  ThemeMode get themeMode {
    final index = get(
      Settings.themeMode,
      defaultValue: 0,
    );
    return ThemeMode.values[index];
  }

  set themeMode(ThemeMode value) => put(Settings.themeMode, value.index);

  int get counter => get(Settings.counter, defaultValue: 0);

  set counter(int value) => put(Settings.counter, value);
}
```

### 4. Use it anywhere 🔥

```dart
  Text(
    'You have pushed: ${SettingsBox().counter} times.',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
  FilledButton(
    onPressed: () {
      SettingsBox().counter++;
    },
    child: Text('Increment'),
  ),
  FilledButton(
    onPressed: () {
      SettingsBox().themeMode = ThemeMode.dark;
    },
    child: Text('Dark Theme'),
  ),
```

<details>
<summary>Or to use with get_it</summary>

```dart
  Text(
    'Count: ${GetIt.I<SettingsBox>().counter}',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
```

</details>

## Advanced Usage 😈

### Enable encryption 🔐

#### 1. Install [easy_hive_encryption](https://pub.dev/packages/easy_hive_encryption):

#### 2. Add `EncryptionMixin` to your box class:

```dart
class SettingsBox extends EasyBox with EncryptionMixin {
  @override
  String get boxKey => Settings.key.toString();

  /// Override encryption key name (optional).
  @override
  String get encryptionKeyName => "your-own-key-name";
}
```

#### 3. Follow [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)'s guide for specific platform setup.

### Enable lazy loading 🐢

#### 1. Add `LazyMixin` to your box class:

```dart
class SettingsBox extends EasyBox with LazyMixin {
  @override
  String get boxKey => Settings.key.toString();
}
```

#### 2. Use `await` to `get` your value:

```dart
extension GeneralSettingsExtension on SettingsBox {
  Future<ThemeMode> getThemeMode() async {
    final index = await get(
      Settings.themeMode,
      defaultValue: 0,
    );
    return ThemeMode.values[index];
  }
}
```

### Listen to value changes 🎧

#### Recommended: Use `RefreshableBox` + [provider](https://pub.dev/packages/provider):

#### 1. Extends `RefreshableBox` instead of `EasyBox`:

```dart
class SettingsBox extends RefreshableBox {
  @override
  String get boxKey => Settings.key.toString();
}
```

#### 2. Use it as a provider:

```dart
  ChangeNotifierProvider(
    create: (_) => SettingsBox(),
    child: SomeWidget(),
  ),
```

```dart
// Inside SomeWidget.
Text(
  'You have pushed: '
  '${context.select((SettingsBox _) => _.counter)} times.',
),
```

For more info, see [provider](https://pub.dev/packages/provider) package.

---

#### Or if you don't want `RefreshableBox`:

#### Just use `ValueListenableBuilder` to listen to changes.

```dart
ValueListenableBuilder(
  valueListenable: [
    Settings.counter,
  ].of(SettingsBox()),
  builder: (context, _, __) {
    return Text(
      '${SettingsBox().counter}',
    );
  },
),
```

## Happy Coding 🦊

Made with ❤️ by [Simon Pham](https://github.com/simonpham)
