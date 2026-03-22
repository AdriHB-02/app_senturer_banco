# Plan de Implementación: SENTURER Banco App

## Descripción General

Este plan implementa la aplicación móvil Flutter v3 para SENTURER, un banco digital de resiliencia. La aplicación incluye persistencia local con SQLite, navegación tipo Flyout, splash screen animado y una página de inicio con resumen financiero. La arquitectura sigue un patrón en tres capas (Core, Data, Presentation) con separación clara de responsabilidades.

## Tareas

- [ ] 1. Configurar estructura del proyecto y dependencias
  - Verificar que Flutter v3 está instalado y configurado
  - Agregar dependencias en pubspec.yaml: sqflite, path, url_launcher
  - Agregar dev_dependencies: mockito, build_runner, sqflite_common_ffi
  - Crear estructura de carpetas según diseño (core/, data/, presentation/)
  - Configurar assets en pubspec.yaml (images/, icons/)
  - _Requisitos: Todos (estructura base)_

- [ ] 2. Implementar capa Core - Constantes y Configuración
  - [ ] 2.1 Crear archivo de constantes de colores (app_colors.dart)
    - Definir colores primarios, secundarios y de marca SENTURER
    - _Requisitos: 3.3, 6.3_
  
  - [ ] 2.2 Crear archivo de constantes de strings (app_strings.dart)
    - Definir textos de la aplicación (títulos, mensajes, labels)
    - Incluir versión de la app y copyright
    - _Requisitos: 6.2, 6.3_
  
  - [ ] 2.3 Crear archivo de constantes de assets (app_assets.dart)
    - Definir rutas de imágenes (logo, fondos, iconos)
    - _Requisitos: 1.1, 1.2, 2.2, 3.1, 3.2, 4.4_

- [ ] 3. Implementar capa Core - Tema
  - [ ] 3.1 Crear AppTheme con configuración de Material Design
    - Definir ThemeData con colores de marca
    - Configurar estilos de texto, botones y componentes
    - _Requisitos: Todos (apariencia visual)_

- [ ] 4. Implementar capa Core - Base de Datos
  - [ ] 4.1 Crear DatabaseHelper singleton
    - Implementar patrón singleton con lazy initialization
    - Implementar método get database con inicialización diferida
    - Configurar nombre de archivo: senturer_banco.db
    - _Requisitos: 8.1_
  
  - [ ] 4.2 Crear migración inicial v1_initial.dart
    - Crear tabla usuarios con todos los campos y restricciones
    - Crear tabla cuentas con FK a usuarios y restricciones CHECK
    - Crear tabla transacciones con FK a cuentas y restricciones CHECK
    - Crear índices: idx_cuentas_usuario_id, idx_transacciones_cuenta_id, idx_transacciones_fecha, idx_usuarios_email
    - _Requisitos: 8.2_
  
  - [ ] 4.3 Implementar métodos _onCreate y _onUpgrade en DatabaseHelper
    - Ejecutar migración v1 en _onCreate
    - Preparar sistema de versiones para migraciones futuras
    - _Requisitos: 8.5_
  
  - [ ]* 4.4 Escribir property test para confirmación de operaciones de escritura
    - **Property 9: Confirmación de operaciones de escritura**
    - **Valida: Requisitos 8.3**
  
  - [ ]* 4.5 Escribir property test para manejo de errores en base de datos
    - **Property 10: Manejo de errores en operaciones de base de datos**
    - **Valida: Requisitos 8.4**

- [ ] 5. Implementar capa Data - Modelos
  - [ ] 5.1 Crear modelo Usuario (usuario_model.dart)
    - Definir clase Usuario con todos los campos
    - Implementar método toMap() para serialización
    - Implementar factory Usuario.fromMap() para deserialización
    - _Requisitos: 8.2_
  
  - [ ] 5.2 Crear modelo Cuenta (cuenta_model.dart)
    - Definir clase Cuenta con todos los campos
    - Implementar método toMap() para serialización
    - Implementar factory Cuenta.fromMap() para deserialización
    - _Requisitos: 8.2_
  
  - [ ] 5.3 Crear modelo Transaccion (transaccion_model.dart)
    - Definir clase Transaccion con todos los campos
    - Implementar método toMap() para serialización
    - Implementar factory Transaccion.fromMap() para deserialización
    - _Requisitos: 8.2_
  
  - [ ]* 5.4 Escribir unit tests para modelos
    - Test de serialización/deserialización para cada modelo
    - Test de validación de campos requeridos
    - _Requisitos: 8.2_

- [ ] 6. Implementar capa Data - Repositorios
  - [ ] 6.1 Crear UsuarioRepository
    - Implementar insertar(Usuario) con manejo de errores
    - Implementar obtenerPorId(int)
    - Implementar obtenerPorEmail(String)
    - Implementar obtenerTodos()
    - Implementar actualizar(Usuario)
    - Implementar eliminar(int)
    - _Requisitos: 8.3, 8.4_
  
  - [ ] 6.2 Crear CuentaRepository
    - Implementar insertar(Cuenta) con manejo de errores
    - Implementar obtenerPorId(int)
    - Implementar obtenerPorUsuario(int)
    - Implementar obtenerPorNumeroCuenta(String)
    - Implementar obtenerSaldoTotal(int) para sumar saldos de un usuario
    - Implementar actualizar(Cuenta)
    - Implementar eliminar(int)
    - _Requisitos: 7.2, 8.3, 8.4_
  
  - [ ] 6.3 Crear TransaccionRepository
    - Implementar insertar(Transaccion) con manejo de errores
    - Implementar obtenerPorId(int)
    - Implementar obtenerPorCuenta(int, limite opcional)
    - Implementar obtenerUltimas(int usuarioId, int limite) para HomePage
    - Implementar actualizar(Transaccion)
    - Implementar eliminar(int)
    - _Requisitos: 7.4, 8.3, 8.4_
  
  - [ ]* 6.4 Escribir property test para round-trip de datos
    - **Property 11: Round-trip de datos de Transacción**
    - **Valida: Requisitos 8.6**
  
  - [ ]* 6.5 Escribir unit tests para repositorios
    - Test de operaciones CRUD para cada repositorio
    - Test de manejo de errores (violación UNIQUE, FK, etc.)
    - Test de consultas con límites
    - _Requisitos: 8.3, 8.4_

- [ ] 7. Checkpoint - Verificar capa de datos
  - Asegurarse de que todos los tests de base de datos y repositorios pasan
  - Preguntar al usuario si hay dudas o ajustes necesarios

- [ ] 8. Implementar capa Core - Router
  - [ ] 8.1 Crear AppRouter con rutas nombradas
    - Definir constantes de rutas: splash ('/'), home, cuentas, transferencias, perfil
    - Implementar getRoutes() que retorna Map<String, WidgetBuilder>
    - _Requisitos: 4.2_
  
  - [ ] 8.2 Crear FlyoutItemConfig para configuración de items del menú
    - Definir clase con: title, route, icon, tabs opcional
    - Implementar getFlyoutItems() en AppRouter con lista de items
    - _Requisitos: 4.1, 4.3_

- [ ] 9. Implementar navegación - FlyoutMenu y componentes
  - [ ] 9.1 Crear FlyoutHeader
    - Implementar Container con altura mínima de 200px
    - Mostrar imagen de fondo desde AppAssets.flyoutBackground
    - Implementar fallback a color primario si falla carga de imagen
    - Centrar logo de SENTURER
    - _Requisitos: 3.1, 3.2, 3.3_
  
  - [ ] 9.2 Crear FlyoutItem
    - Implementar ListTile con icono, título y estado selected
    - Implementar onTap que cierra drawer y navega a ruta
    - Resaltar visualmente cuando isActive es true
    - _Requisitos: 4.2, 4.4, 4.5_
  
  - [ ] 9.3 Crear FlyoutFooter
    - Mostrar versión de la app desde AppConstants
    - Mostrar texto de copyright
    - _Requisitos: 6.1, 6.2, 6.3_
  
  - [ ] 9.4 Crear FlyoutMenu principal
    - Implementar Drawer con Column: FlyoutHeader, ListView de items, FlyoutFooter
    - Generar FlyoutItems automáticamente desde AppRouter.getFlyoutItems()
    - Detectar ruta activa para resaltar item correspondiente
    - Agregar MenuItem para "Salir" que cierra la app
    - Agregar MenuItem para "Visitar Web" que abre URL externa con url_launcher
    - Implementar manejo de error si no se puede abrir URL
    - _Requisitos: 4.1, 4.2, 4.5, 5.1, 5.2, 5.3, 5.4, 5.5_
  
  - [ ]* 9.5 Escribir property test para generación automática de FlyoutItems
    - **Property 3: Generación automática de FlyoutItems**
    - **Valida: Requisitos 4.1**
  
  - [ ]* 9.6 Escribir property test para cierre y navegación de FlyoutItem
    - **Property 4: Cierre y navegación al seleccionar FlyoutItem**
    - **Valida: Requisitos 4.2**
  
  - [ ]* 9.7 Escribir property test para renderizado de Tabs
    - **Property 5: Renderizado de Tabs en FlyoutItem**
    - **Valida: Requisitos 4.3**
  
  - [ ]* 9.8 Escribir property test para resaltado de item activo
    - **Property 6: Resaltado de FlyoutItem activo**
    - **Valida: Requisitos 4.5**
  
  - [ ]* 9.9 Escribir widget tests para componentes de navegación
    - Test de FlyoutHeader: altura mínima, fallback de imagen
    - Test de FlyoutFooter: versión y copyright visibles
    - Test de MenuItem: salir y abrir URL
    - _Requisitos: 3.2, 3.3, 5.1, 5.2, 5.3, 5.4, 5.5, 6.1, 6.2, 6.3_

- [ ] 10. Implementar SplashScreen
  - [ ] 10.1 Crear SplashScreen con animación
    - Implementar StatefulWidget con initState que llama _navigateToHome()
    - Mostrar Container con imagen de fondo desde AppAssets.splashBackground
    - Centrar logo de SENTURER
    - Implementar delay de 2 segundos antes de navegar
    - Implementar navegación a HomePage con pushReplacementNamed
    - Implementar reintento tras 500ms si falla la navegación
    - _Requisitos: 2.1, 2.2, 2.3, 2.4_
  
  - [ ]* 10.2 Escribir property test para duración del SplashScreen
    - **Property 1: Duración del SplashScreen**
    - **Valida: Requisitos 2.1**
  
  - [ ]* 10.3 Escribir property test para navegación automática
    - **Property 2: Navegación automática desde SplashScreen**
    - **Valida: Requisitos 2.3**
  
  - [ ]* 10.4 Escribir widget test para SplashScreen
    - Test de reintento de navegación tras fallo
    - _Requisitos: 2.4_

- [ ] 11. Implementar HomePage
  - [ ] 11.1 Crear HomePage con estructura básica
    - Implementar StatefulWidget con estado para saldo y transacciones
    - Agregar AppBar con título "SENTURER" y drawer: FlyoutMenu
    - Implementar initState que llama _cargarDatos()
    - Mostrar CircularProgressIndicator mientras _isLoading es true
    - _Requisitos: 7.1_
  
  - [ ] 11.2 Implementar método _cargarDatos()
    - Obtener saldo total usando CuentaRepository.obtenerSaldoTotal()
    - Obtener últimas 5 transacciones usando TransaccionRepository.obtenerUltimas()
    - Actualizar estado con setState
    - Manejar errores con try-catch
    - _Requisitos: 7.2, 7.4_
  
  - [ ] 11.3 Implementar widget _buildSaldoCard()
    - Mostrar Card con resumen del saldo total
    - Formatear saldo con símbolo de moneda
    - _Requisitos: 7.2_
  
  - [ ] 11.4 Implementar widget _buildAccesosRapidos()
    - Crear fila o grid con botones para: Cuentas, Transferencias, Perfil
    - Implementar onTap que navega a la sección correspondiente
    - _Requisitos: 7.3, 7.5_
  
  - [ ] 11.5 Implementar widget _buildUltimasTransacciones()
    - Mostrar lista de las últimas transacciones (máximo 5)
    - Mostrar tipo, monto, descripción y fecha de cada transacción
    - _Requisitos: 7.4_
  
  - [ ] 11.6 Implementar widget _buildEmptyState()
    - Mostrar mensaje informativo cuando no hay datos disponibles
    - _Requisitos: 7.6_
  
  - [ ]* 11.7 Escribir property test para límite de transacciones
    - **Property 7: Límite de transacciones en HomePage**
    - **Valida: Requisitos 7.4**
  
  - [ ]* 11.8 Escribir property test para navegación desde accesos rápidos
    - **Property 8: Navegación desde accesos rápidos**
    - **Valida: Requisitos 7.5**
  
  - [ ]* 11.9 Escribir widget tests para HomePage
    - Test de resumen de saldo visible
    - Test de accesos rápidos visibles
    - Test de estado vacío cuando no hay datos
    - _Requisitos: 7.2, 7.3, 7.6_

- [ ] 12. Checkpoint - Verificar pantallas principales
  - Asegurarse de que SplashScreen y HomePage funcionan correctamente
  - Verificar que la navegación entre pantallas funciona
  - Preguntar al usuario si hay ajustes necesarios

- [ ] 13. Crear pantallas placeholder para navegación completa
  - [ ] 13.1 Crear CuentasPage con TabBar
    - Implementar DefaultTabController con 2 tabs: "Mis Cuentas", "Movimientos"
    - Crear contenido placeholder para cada tab
    - _Requisitos: 4.3_
  
  - [ ] 13.2 Crear TransferenciasPage placeholder
    - Implementar Scaffold básico con AppBar y drawer
    - Agregar contenido placeholder
    - _Requisitos: 7.3_
  
  - [ ] 13.3 Crear PerfilPage placeholder
    - Implementar Scaffold básico con AppBar y drawer
    - Agregar contenido placeholder
    - _Requisitos: 7.3_

- [ ] 14. Configurar assets e iconos de la aplicación
  - [ ] 14.1 Agregar imágenes a carpeta assets/images/
    - Agregar logo_senturer.png
    - Agregar flyout_background.png
    - Agregar splash_background.png
    - _Requisitos: 2.2, 3.1, 4.4_
  
  - [ ] 14.2 Configurar icono de la aplicación
    - Agregar app_icon.png a assets/icons/
    - Configurar iconos para Android (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
    - Configurar iconos para iOS (todos los tamaños requeridos)
    - _Requisitos: 1.1, 1.2_
  
  - [ ] 14.3 Implementar fallback para icono
    - Verificar que si el icono no carga, se muestra el icono de Flutter por defecto
    - _Requisitos: 1.3_

- [ ] 15. Implementar archivo principal app.dart y main.dart
  - [ ] 15.1 Crear app.dart con MaterialApp
    - Configurar theme usando AppTheme
    - Configurar initialRoute: AppRouter.splash
    - Configurar routes usando AppRouter.getRoutes()
    - _Requisitos: Todos (punto de entrada)_
  
  - [ ] 15.2 Crear main.dart
    - Implementar función main() que ejecuta runApp()
    - Inicializar WidgetsFlutterBinding si es necesario
    - _Requisitos: Todos (punto de entrada)_

- [ ] 16. Implementar manejo de errores y logging
  - [ ] 16.1 Crear clase DatabaseException
    - Definir excepción personalizada con mensaje y detalles
    - _Requisitos: 8.4_
  
  - [ ] 16.2 Crear clase AppLogger
    - Implementar métodos estáticos: error(), warning(), info()
    - Usar debugPrint para logging
    - _Requisitos: 8.4_
  
  - [ ] 16.3 Implementar manejo de errores en repositorios
    - Capturar excepciones de SQLite y transformar a DatabaseException
    - Agregar mensajes descriptivos para violaciones UNIQUE, FK, CHECK
    - _Requisitos: 8.4_

- [ ] 17. Checkpoint final - Verificar integración completa
  - Ejecutar flutter test para verificar que todos los tests pasan
  - Ejecutar la aplicación en emulador/dispositivo
  - Verificar flujo completo: SplashScreen → HomePage → FlyoutMenu → Navegación
  - Verificar que la base de datos se crea correctamente
  - Preguntar al usuario si hay problemas o ajustes finales

- [ ] 18. Optimizaciones y refinamiento
  - [ ] 18.1 Optimizar consultas de base de datos
    - Verificar que los índices están funcionando correctamente
    - Implementar transacciones para operaciones múltiples si es necesario
    - _Requisitos: 8.3_
  
  - [ ] 18.2 Optimizar rendimiento de UI
    - Usar ListView.builder para listas largas
    - Verificar que FutureBuilder se usa correctamente en HomePage
    - _Requisitos: 7.4_
  
  - [ ]* 18.3 Ejecutar tests de cobertura
    - Ejecutar flutter test --coverage
    - Verificar que la cobertura de unit tests es >= 80%
    - _Requisitos: Todos_

## Notas

- Las tareas marcadas con `*` son opcionales y pueden omitirse para un MVP más rápido
- Cada tarea referencia los requisitos específicos que valida para trazabilidad
- Los checkpoints aseguran validación incremental del progreso
- Los property tests validan las 11 propiedades de correctitud del diseño
- Los unit tests y widget tests validan ejemplos específicos y casos borde
- La implementación sigue la arquitectura en tres capas definida en el diseño
