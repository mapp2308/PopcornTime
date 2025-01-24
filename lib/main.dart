import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popcorntime/config/router/app_router.dart';
import 'package:popcorntime/config/theme/app_theme.dart'; // Importa Riverpod

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env antes de inicializar la aplicación
  await dotenv.load(fileName: ".env");

  // Crear el GoRouter
  final router = await createAppRouter();

  runApp(
    ProviderScope(
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Popcorn Time',
      theme: AppTheme().getTheme(),
      routerConfig: router,
    );
  }
}