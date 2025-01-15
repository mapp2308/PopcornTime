// Este archivo es el punto de entrada principal de la aplicación popcorntime.
// Se encarga de cargar las configuraciones iniciales y luego inicia la aplicación.

import 'package:flutter/material.dart';
import 'package:popcorntime/config/router/app_router.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:popcorntime/config/theme/app_theme.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Función main() que se ejecuta al iniciar la aplicación.
// La palabra clave async se usa para ejecutar operaciones asíncronas como cargar el archivo .env.
Future<void> main() async {
  await dotenv.load(fileName: '.env'); // Carga el archivo .env que contiene las variables de entorno.

  runApp(
    const ProviderScope(child: MainApp()) 
  );
}

// Clase MainApp que define la estructura de la aplicación.
// Es el widget principal que contiene la configuración global de la app.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // Configura el enrutador de la aplicación usando el objeto appRouter.
      debugShowCheckedModeBanner: false, // Desactiva el banner de depuración que aparece en la esquina superior derecha en modo de desarrollo.
      theme: AppTheme().getTheme(), // Aplica el tema visual definido en la clase AppTheme.
    );
  }
}
