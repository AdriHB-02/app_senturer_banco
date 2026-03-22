# Documento de Requisitos

## Introducción

SENTURER es una aplicación móvil Flutter v3 para el banco digital "SENTURER", definido como un "Banco de Resiliencia Digital". No opera bajo la estructura de un banco tradicional, sino como una entidad tecnológica con licencia bancaria, con enfoque en banca digital y presencia nativa en dispositivos móviles. La aplicación utiliza SQLite para persistencia local de datos y ofrece una experiencia de usuario moderna con navegación tipo Flyout, splash screen y página de inicio como pantalla principal.

---

## Glosario

- **App**: La aplicación móvil Flutter de SENTURER.
- **SplashScreen**: Pantalla de presentación que se muestra al iniciar la App antes de cargar la interfaz principal.
- **FlyoutMenu**: Menú lateral deslizante (drawer) que contiene la navegación principal de la App.
- **FlyoutHeader**: Sección superior del FlyoutMenu que muestra el logo de SENTURER como fondo.
- **FlyoutItem**: Elemento de navegación dentro del FlyoutMenu que puede incluir imagen de fondo y generar automáticamente una barra de menú con soporte para Tabs.
- **FlyoutFooter**: Sección inferior del FlyoutMenu con acciones secundarias.
- **MenuItem**: Elemento de acción dentro del FlyoutMenu para salir de la App o navegar a una URL externa.
- **HomePage**: Página principal de la App, mostrada tras el SplashScreen.
- **Database**: Capa de persistencia local implementada con SQLite.
- **Usuario**: Persona que utiliza la App en su dispositivo móvil.
- **AppIcon**: Icono de la aplicación visible en el launcher del dispositivo.

---

## Estructura de Carpetas del Proyecto

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_assets.dart
│   ├── database/
│   │   ├── database_helper.dart
│   │   └── migrations/
│   │       └── v1_initial.dart
│   ├── router/
│   │   └── app_router.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   ├── usuario_model.dart
│   │   ├── cuenta_model.dart
│   │   └── transaccion_model.dart
│   └── repositories/
│       ├── usuario_repository.dart
│       ├── cuenta_repository.dart
│       └── transaccion_repository.dart
├── presentation/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── home/
│   │   └── home_page.dart
│   ├── cuentas/
│   │   └── cuentas_page.dart
│   ├── transferencias/
│   │   └── transferencias_page.dart
│   ├── perfil/
│   │   └── perfil_page.dart
│   ├── navigation/
│   │   ├── flyout_menu.dart
│   │   ├── flyout_header.dart
│   │   ├── flyout_item.dart
│   │   └── flyout_footer.dart
│   └── widgets/
│       └── common_widgets.dart
assets/
├── images/
│   └──logo_senturer.png
└── icons/
    └── app_icon.png
```

---

## Modelo de Datos

### Entidades Principales

#### Usuario
| Campo         | Tipo    | Descripción                        |
|---------------|---------|------------------------------------|
| id            | INTEGER | Clave primaria autoincremental     |
| nombre        | TEXT    | Nombre completo del usuario        |
| email         | TEXT    | Correo electrónico (único)         |
| telefono      | TEXT    | Número de teléfono                 |
| fecha_registro| TEXT    | Fecha de registro (ISO 8601)       |
| activo        | INTEGER | Estado activo (1) o inactivo (0)   |

#### Cuenta
| Campo         | Tipo    | Descripción                              |
|---------------|---------|------------------------------------------|
| id            | INTEGER | Clave primaria autoincremental           |
| usuario_id    | INTEGER | FK → Usuario.id                          |
| numero_cuenta | TEXT    | Número de cuenta (único)                 |
| tipo          | TEXT    | Tipo: 'ahorro', 'corriente', 'digital'   |
| saldo         | REAL    | Saldo disponible                         |
| moneda        | TEXT    | Código de moneda (ej. 'USD', 'EUR')      |
| fecha_apertura| TEXT    | Fecha de apertura (ISO 8601)             |
| activa        | INTEGER | Estado activa (1) o inactiva (0)         |

#### Transaccion
| Campo         | Tipo    | Descripción                                        |
|---------------|---------|----------------------------------------------------|
| id            | INTEGER | Clave primaria autoincremental                     |
| cuenta_id     | INTEGER | FK → Cuenta.id                                     |
| tipo          | TEXT    | Tipo: 'deposito', 'retiro', 'transferencia'        |
| monto         | REAL    | Monto de la transacción                            |
| descripcion   | TEXT    | Descripción o referencia                           |
| fecha         | TEXT    | Fecha y hora (ISO 8601)                            |
| estado        | TEXT    | Estado: 'pendiente', 'completada', 'fallida'       |

### Relaciones
- Un **Usuario** puede tener múltiples **Cuentas** (1:N)
- Una **Cuenta** puede tener múltiples **Transacciones** (1:N)

---

## Diagrama de Flujo del Usuario

```
[Inicio de App]
      │
      ▼
[SplashScreen]
  (2-3 segundos, logo animado)
      │
      ▼
[HomePage]  ◄────────────────────────────────┐
  (Pantalla principal)                        │
      │                                       │
      ├── [Toca ícono de menú / swipe]        │
      │         │                             │
      │         ▼                             │
      │   [FlyoutMenu se abre]                │
      │         │                             │
      │         ├── [FlyoutHeader]            │
      │         │   (Logo SENTURER)           │
      │         │                             │
      │         ├── [FlyoutItem: Inicio] ─────┘
      │         │
      │         ├── [FlyoutItem: Cuentas]
      │         │         │
      │         │         ▼
      │         │   [Página Cuentas con Tabs]
      │         │   Tab 1: Mis Cuentas
      │         │   Tab 2: Movimientos
      │         │
      │         ├── [FlyoutItem: Transferencias]
      │         │
      │         ├── [FlyoutItem: Perfil]
      │         │
      │         ├── [MenuItem: Visitar Web] ──► [Abre URL externa]
      │         │
      │         ├── [MenuItem: Salir] ─────────► [Cierra la App]
      │         │
      │         └── [FlyoutFooter]
      │             (Versión / Info legal)
      │
      └── [Contenido de HomePage]
          - Resumen de saldo
          - Accesos rápidos
          - Últimas transacciones
```

---

## Decisiones de Diseño

### 1. Arquitectura en Capas (Presentation / Data / Core)
Se separa la lógica de presentación, acceso a datos y utilidades del núcleo. Esto permite escalar la app sin acoplar la UI a la base de datos, facilita pruebas unitarias y mantiene el código organizado conforme crece el proyecto.

### 2. SQLite con DatabaseHelper Singleton
Se usa `sqflite` con un helper singleton para gestionar la conexión a la base de datos. Garantiza una única instancia activa, evita condiciones de carrera y centraliza las migraciones de esquema en un solo lugar.

### 3. FlyoutMenu como Drawer nativo de Flutter
Se implementa el menú lateral usando el `Drawer` nativo de Flutter en lugar de librerías externas. Reduce dependencias, aprovecha el comportamiento estándar de Material Design y facilita la personalización del header, items, footer y fondos de imagen.

### 4. Navegación con Named Routes (AppRouter)
Se centraliza la navegación en un `AppRouter` con rutas nombradas. Desacopla la navegación de los widgets, permite deep linking futuro y hace que los flujos de pantalla sean fáciles de auditar y modificar.

### 5. SplashScreen nativa + Flutter SplashScreen
Se combina la splash screen nativa del sistema operativo (configurada en Android/iOS) con una pantalla Flutter animada. Esto elimina la pantalla en blanco al inicio y permite mostrar animaciones del logo SENTURER antes de cargar la HomePage.

---

## Requisitos

### Requisito 1: Icono de la Aplicación

**User Story:** Como usuario, quiero ver el icono oficial de SENTURER en el launcher de mi dispositivo, para identificar fácilmente la aplicación.

#### Criterios de Aceptación

1. THE App SHALL mostrar el icono de SENTURER en el launcher del dispositivo en resoluciones hdpi, mdpi, xhdpi, xxhdpi y xxxhdpi para Android.
2. THE App SHALL mostrar el icono de SENTURER en el launcher del dispositivo en todos los tamaños requeridos por iOS (20pt, 29pt, 40pt, 60pt, 76pt, 83.5pt, 1024pt).
3. IF el icono no puede cargarse desde los assets, THEN THE App SHALL mostrar el icono de Flutter por defecto como fallback.

---

### Requisito 2: Splash Screen

**User Story:** Como usuario, quiero ver una pantalla de presentación animada al abrir la App, para tener una experiencia de inicio profesional y reconocer la marca SENTURER.

#### Criterios de Aceptación

1. WHEN el usuario abre la App, THE SplashScreen SHALL mostrarse durante un mínimo de 2 segundos y un máximo de 3 segundos antes de navegar a la HomePage.
2. WHILE la SplashScreen está activa, THE SplashScreen SHALL mostrar el logo de SENTURER centrado sobre un fondo de imagen o color de marca.
3. WHEN el tiempo de presentación finaliza, THE SplashScreen SHALL navegar automáticamente a la HomePage sin intervención del usuario.
4. IF la navegación a la HomePage falla, THEN THE SplashScreen SHALL reintentar la navegación una vez tras 500ms.

---

### Requisito 3: Menú Flyout — Header

**User Story:** Como usuario, quiero ver el logo de SENTURER en la parte superior del menú lateral, para reconocer la identidad de la aplicación al navegar.

#### Criterios de Aceptación

1. WHEN el FlyoutMenu está abierto, THE FlyoutHeader SHALL mostrar el logo de SENTURER como imagen de fondo.
2. THE FlyoutHeader SHALL ocupar al menos 200 píxeles de altura dentro del FlyoutMenu.
3. IF la imagen de fondo del FlyoutHeader no puede cargarse, THEN THE FlyoutHeader SHALL mostrar el color primario de la marca como fondo alternativo.

---

### Requisito 4: Menú Flyout — Items de Navegación

**User Story:** Como usuario, quiero ver los elementos de navegación en el menú lateral con imágenes de fondo, para identificar visualmente cada sección de la App.

#### Criterios de Aceptación

1. THE FlyoutMenu SHALL generar automáticamente los FlyoutItems a partir de una lista de configuración de rutas definida en AppRouter.
2. WHEN el usuario selecciona un FlyoutItem, THE FlyoutMenu SHALL cerrar el drawer y navegar a la página correspondiente.
3. WHERE un FlyoutItem tiene Tabs configurados, THE FlyoutItem SHALL renderizar la página destino con una barra de Tabs en la parte superior.
4. THE FlyoutItem SHALL mostrar una imagen de fondo o ícono representativo junto al texto de la sección.
5. WHILE el usuario está en una página, THE FlyoutItem correspondiente SHALL mostrarse visualmente resaltado (estado activo) en el FlyoutMenu.

---

### Requisito 5: Menú Flyout — MenuItem de Acción

**User Story:** Como usuario, quiero tener acceso a acciones especiales desde el menú lateral, como salir de la App o visitar el sitio web de SENTURER.

#### Criterios de Aceptación

1. THE FlyoutMenu SHALL incluir un MenuItem para cerrar la App.
2. WHEN el usuario selecciona el MenuItem de salir, THE App SHALL cerrarse completamente.
3. THE FlyoutMenu SHALL incluir un MenuItem para abrir el sitio web oficial de SENTURER.
4. WHEN el usuario selecciona el MenuItem de sitio web, THE App SHALL abrir la URL en el navegador externo del dispositivo.
5. IF el dispositivo no puede abrir la URL externa, THEN THE App SHALL mostrar un mensaje de error indicando que no fue posible abrir el enlace.

---

### Requisito 6: Menú Flyout — Footer

**User Story:** Como usuario, quiero ver información secundaria en la parte inferior del menú lateral, para conocer la versión de la App y datos legales básicos.

#### Criterios de Aceptación

1. WHEN el FlyoutMenu está abierto, THE FlyoutFooter SHALL mostrarse en la parte inferior del drawer.
2. THE FlyoutFooter SHALL mostrar la versión actual de la App.
3. THE FlyoutFooter SHALL mostrar el texto de copyright o aviso legal de SENTURER.

---

### Requisito 7: Página de Inicio (HomePage)

**User Story:** Como usuario, quiero ver una página de inicio con información relevante de mi cuenta al abrir la App, para tener acceso rápido a mis datos financieros principales.

#### Criterios de Aceptación

1. WHEN el usuario llega a la HomePage, THE HomePage SHALL mostrarse como la pantalla principal de la App tras el SplashScreen.
2. THE HomePage SHALL mostrar un resumen del saldo total disponible del usuario.
3. THE HomePage SHALL mostrar accesos rápidos a las secciones principales (Cuentas, Transferencias, Perfil).
4. THE HomePage SHALL mostrar las últimas 5 transacciones del usuario.
5. WHEN el usuario pulsa un acceso rápido, THE HomePage SHALL navegar a la sección correspondiente.
6. IF no hay datos disponibles en la Database, THEN THE HomePage SHALL mostrar un estado vacío con un mensaje informativo.

---

### Requisito 8: Persistencia de Datos con SQLite

**User Story:** Como usuario, quiero que mis datos financieros se almacenen localmente en el dispositivo, para acceder a ellos sin necesidad de conexión a internet.

#### Criterios de Aceptación

1. THE Database SHALL inicializarse automáticamente al arrancar la App si no existe previamente.
2. THE Database SHALL crear las tablas Usuario, Cuenta y Transaccion en la primera ejecución.
3. WHEN se realiza una operación de escritura en la Database, THE Database SHALL confirmar la operación antes de retornar el resultado.
4. IF una operación de escritura en la Database falla, THEN THE Database SHALL lanzar una excepción con un mensaje descriptivo del error.
5. THE Database SHALL soportar migraciones de esquema incrementales mediante un sistema de versiones.
6. FOR ALL registros de Transaccion insertados y luego consultados, THE Database SHALL retornar los mismos datos sin pérdida de información (propiedad de round-trip).
