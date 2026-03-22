# SENTURER — Instrucciones para la IA

## Proyecto
App móvil Flutter para el banco digital SENTURER. Flutter v3, SQLite con sqflite, 
Material Design con Drawer nativo.

## Reglas de código
- Dart con null safety siempre activado
- Arquitectura en capas: presentation / data / core (nunca mezclar)
- Singleton para DatabaseHelper
- Named routes centralizadas en AppRouter
- Comentarios en español
- Un widget por archivo

## Restricciones
- No usar librerías de terceros para el menú lateral (solo Drawer nativo de Flutter)
- No mezclar lógica de UI con lógica de base de datos
- Siempre manejar el caso de error y el estado vacío en la UI

## Referencia del proyecto
El documento de requisitos oficial está en REQUIREMENTS.MD.
Antes de implementar cualquier feature, verifica los criterios de aceptación del requisito correspondiente.