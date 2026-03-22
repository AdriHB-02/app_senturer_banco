# SENTURER - App Bancaria Digital

Aplicación móvil del banco digital **SENTURER**, desarrollada en Flutter para proporcionar servicios bancarios accesibles y seguros.

---

## Requisitos Previos

### 1. Instalar Flutter SDK

**Windows:**
1. Descarga Flutter SDK desde [flutter.dev](https://docs.flutter.dev/get-started/install/windows)
2. Descomprime el archivo `.zip` en una ubicación sin espacios ni caracteres especiales (ej: `C:\flutter`)
3. Agrega Flutter al PATH:
   - Ve a **Panel de Control > Sistema > Configuración avanzada del sistema > Variables de entorno**
   - En "Variables del sistema", busca `Path` y haz clic en **Editar**
   - Agrega la ruta `C:\flutter\bin`
4. Abre una terminal y ejecuta:
   ```bash
   flutter doctor
   ```

**macOS:**
```bash
brew install flutter
flutter doctor
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install flutter
flutter doctor
```

### 2. Instalar Android Studio / Configurar emulador

Para ejecutar la app necesitas un dispositivo o emulador:

**Con Android Studio:**
1. Descarga [Android Studio](https://developer.android.com/studio)
2. Durante la instalación, marca "Android SDK"
3. Crea un emulador: **Tools > Device Manager > Create Device**
4. Selecciona un dispositivo (Pixel 5 recomendado) y una imagen del sistema (API 30+)

**Solo con Flutter CLI:**
```bash
flutter config --no-analytics
flutter doctor --android-licenses
flutter doctor
```

### 3. Verificar instalación

```bash
flutter --version
flutter doctor -v
```

---

## Instalación del Proyecto

1. **Clona o descarga el proyecto**
   ```bash
   git clone <url-del-repositorio>
   cd app_senturer_banco
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Configura assets (íconos)**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

---

## Ejecutar la Aplicación

### Modo Desarrollo (Debug)

```bash
flutter run
```

Si tienes múltiples dispositivos:
```bash
flutter devices                    # Lista dispositivos disponibles
flutter run -d <device-id>          # Ejecuta en dispositivo específico
flutter run -d emulator-5554         # Ejemplo con emulador
```

### Modo Release (Producción)

**Android APK:**
```bash
flutter build apk --release
```
El APK se genera en: `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```
> Requiere macOS con Xcode configurado.

---

## Arquitectura del Proyecto

El proyecto sigue una **arquitectura en capas** para mantener el código organizado y mantenible:

```
lib/
├── core/                    # Configuración central
│   ├── constants/          # Constantes globales (colores, strings)
│   ├── database/           # Helper de SQLite (Singleton)
│   ├── router/             # Named routes centralizadas
│   └── theme/              # Tema de la app (colores, tipografías)
│
├── data/                   # Capa de datos
│   ├── models/             # Modelos de datos
│   └── repositories/       # Repositorios (acceso a datos)
│
├── presentation/           # Capa de presentación (UI)
│   ├── cuentas/            # Módulo de cuentas
│   ├── home/               # Pantalla principal
│   ├── navigation/         # Navegación y drawer
│   ├── perfil/             # Perfil del usuario
│   ├── splash/             # Pantalla de carga
│   ├── transferencias/     # Módulo de transferencias
│   └── widgets/            # Widgets reutilizables
│
├── app.dart                # Configuración principal de la app
└── main.dart               # Punto de entrada
```

### Reglas de Arquitectura

- **Separación de capas:** UI en `presentation/`, lógica de datos en `data/`, configuración en `core/`
- **Un widget por archivo:** Cada widget vive en su propio archivo
- **Singleton para DatabaseHelper:** Acceso único a la base de datos SQLite
- **Named routes centralizadas:** Rutas definidas en `core/router/`
- **Manejo de estados:** Siempre manejar estados de error y vacío en la UI
- **Drawer nativo:** Menú lateral usando el Drawer integrado de Flutter (sin librerías de terceros)

---

## Tecnologías y Dependencias

| Dependencia | Propósito |
|-------------|-----------|
| `sqflite` | Base de datos SQLite local |
| `path_provider` | Acceso a directorios del sistema |
| `path` | Manejo de rutas de archivos |
| `url_launcher` | Abrir URLs externas |
| `package_info_plus` | Información de la app |

---

## Estructura de Carpetas Android/iOS

```
android/          # Proyecto Android nativo
ios/              # Proyecto iOS nativo
assets/
├── images/       # Imágenes (logo)
└── icons/        # Íconos de la app
```

---

## Comandos Útiles

```bash
flutter clean              # Limpia build cache
flutter pub get            # Actualiza dependencias
flutter analyze            # Analiza código Dart
flutter test               # Ejecuta pruebas
flutter build apk          # Build debug APK
flutter build apk --release # Build release APK
```

---

## Solución de Problemas

**Error: Flutter SDK not found**
```bash
# Verifica que flutter esté en PATH
echo $PATH
flutter doctor
```

**Error: Android license not accepted**
```bash
flutter doctor --android-licenses
```

**Error: No devices available**
```bash
# Inicia el emulador desde Android Studio
# O lista dispositivos
flutter devices
```

---

## Información del Proyecto

- **Nombre:** SENTURER
- **Tipo:** App bancaria digital
- **Versión:** 1.0.0
- **Framework:** Flutter 3.x
- **Base de datos:** SQLite (sqflite)

---

## Licencia

Este proyecto es propiedad de SENTURER. Todos los derechos reservados.
