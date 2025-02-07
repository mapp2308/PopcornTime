import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Librería para la navegación
import 'package:popcorntime/config/helpers/database_helper.dart'; // Base de datos local
import 'package:popcorntime/presentation/screens/screens.dart'; // Importa pantallas de la aplicación

// Esta pantalla (`LoginScreen`) permite a los usuarios iniciar sesión en la aplicación.
// - Utiliza `TextField` para capturar el nombre de usuario y la contraseña.
// - Usa `FutureBuilder` para asegurarse de que todos los usuarios están deslogueados antes de mostrar la pantalla.
// - Se almacena el estado de sesión en la base de datos local (`SQLite`).
// - Si las credenciales son correctas, se redirige a la pantalla principal (`context.go('/')`).
// - Permite navegar a la pantalla de registro (`RegisterScreen`).

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(); // Controlador del campo usuario
  final TextEditingController _passwordController = TextEditingController(); // Controlador del campo contraseña
  final DatabaseHelper dbHelper = DatabaseHelper(); // Instancia para interactuar con la base de datos

  LoginScreen({super.key});

  /// Establece a `false` el estado de sesión de todos los usuarios en la base de datos.
  Future<void> updateAllUsersToLoggedOut() async {
    final db = await dbHelper.database;
    await db.rawUpdate('UPDATE users SET isLogueado = 0');
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return FutureBuilder(
      future: updateAllUsersToLoggedOut(), // Asegura que todos los usuarios estén deslogueados antes de cargar la pantalla
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Muestra un indicador de carga mientras se actualiza el estado de sesión
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            centerTitle: true,
          ),
          body: SingleChildScrollView( // Evita el error de desbordamiento cuando el teclado aparece
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30), // Redondea los bordes de la imagen
                      child: Image.asset(
                        'assets/CAP.png', // Imagen del logo
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenido a Popcorn Time',
                      style: textStyles.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Campo de entrada para el nombre de usuario
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo de entrada para la contraseña
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true, // Oculta la contraseña
                    ),
                    const SizedBox(height: 20),

                    // Botón de inicio de sesión
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        final username = _usernameController.text;
                        final password = _passwordController.text;

                        final user = await dbHelper.loginUser(username, password); // Verifica las credenciales
                        if (user != null) {
                          user.isLogueado = true;
                          await dbHelper.updateUser(user); // Actualiza el estado del usuario en la base de datos
                          context.go('/'); // Redirige a la pantalla principal
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Usuario o contraseña incorrectos',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Iniciar sesión'),
                    ),
                    const SizedBox(height: 20),

                    // Botón para navegar a la pantalla de registro
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(), // Redirige a la pantalla de registro
                          ),
                        );
                      },
                      child: Text(
                        '¿No tienes una cuenta? Regístrate aquí',
                        style: textStyles.bodyLarge?.copyWith(
                          color: const Color.fromARGB(255, 255, 217, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
