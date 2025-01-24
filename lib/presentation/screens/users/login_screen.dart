import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcorntime/config/helpers/database_helper.dart';
import 'package:popcorntime/presentation/screens/users/register_screen.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  LoginScreen({super.key});

  Future<void> updateAllUsersToLoggedOut() async {
    final db = await dbHelper.database;
    await db.rawUpdate('UPDATE users SET isLogueado = 0');
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return FutureBuilder(
      future: updateAllUsersToLoggedOut(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido a Popcorn Time',
                    style: textStyles.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
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
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
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

                      final user = await dbHelper.loginUser(username, password);
                      if (user != null) {
                        user.isLogueado = true;
                        await dbHelper.updateUser(user);

                        context.go('/'); // Redirige al home
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
                  TextButton(
                    onPressed: () {
                      // Navega a la pantalla de registro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
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
        );
      },
    );
  }
}