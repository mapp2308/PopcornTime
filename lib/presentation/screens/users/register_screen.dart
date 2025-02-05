import 'package:flutter/material.dart';
import 'package:popcorntime/config/helpers/database_helper.dart'; // Helper para interactuar con la base de datos local
import 'package:popcorntime/domain/entities/user.dart'; // Entidad User

// Esta pantalla (`RegisterScreen`) permite a los usuarios registrarse en la aplicación.
// - Se valida cada campo del formulario con expresiones regulares (`RegExp`).
// - Se verifica si el usuario ya existe en la base de datos antes de registrarlo.
// - Se muestra un `SnackBar` con mensajes de error en caso de fallas en la validación.
// - Al registrarse con éxito, el usuario es guardado en la base de datos y redirigido a la pantalla de inicio de sesión.

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Instancia para acceder a la base de datos

  RegisterScreen({super.key});

  /// Valida un campo usando una expresión regular y devuelve un mensaje de error si no es válido
  String? _validateField(String value, String fieldName, RegExp regex, String errorMessage) {
    if (value.isEmpty) {
      return 'El campo $fieldName no puede estar vacío';
    }
    if (!regex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permite desplazar la pantalla si el teclado cubre los campos
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crea una cuenta nueva', style: textStyles.titleLarge),
              const SizedBox(height: 20),

              // Campo de Nombre
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),

              // Campo de Apellido
              TextField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),

              // Campo de Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
              ),
              const SizedBox(height: 10),

              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true, // Oculta la contraseña
              ),
              const SizedBox(height: 10),

              // Campo de Confirmar Contraseña
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // Campo de Dirección
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.home),
                ),
              ),
              const SizedBox(height: 10),

              // Campo de Teléfono
              TextField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone, // Solo números en el teclado
              ),
              const SizedBox(height: 20),

              // Botón de Registro
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    String nombre = _nombreController.text;
                    String apellido = _apellidoController.text;
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;
                    String direccion = _direccionController.text;
                    String telefono = _telefonoController.text;

                    List<String> errors = [];

                    // Validaciones de los campos
                    if (_validateField(nombre, 'Nombre', RegExp(r'^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+(?:\s[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+)*$'), 'Nombre inválido') != null) {
                      errors.add('Nombre inválido.');
                    }
                    if (_validateField(apellido, 'Apellido', RegExp(r'^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+(?:\s[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+)*$'), 'Apellido inválido') != null) {
                      errors.add('Apellido inválido.');
                    }
                    if (_validateField(username, 'Username', RegExp(r'^[a-zA-Z0-9_]{6,}$'), 'Username inválido') != null) {
                      errors.add('Username debe tener al menos 6 caracteres y solo puede contener letras, números y _.');
                    }
                    if (_validateField(password, 'Contraseña', RegExp(r'^(?=.*[A-Za-z]{3,})(?=.*\d).+$'), 'Contraseña inválida') != null) {
                      errors.add('La contraseña debe contener al menos 3 letras y 1 número.');
                    }
                    if (password != confirmPassword) {
                      errors.add('Las contraseñas no coinciden.');
                    }
                    if (_validateField(direccion, 'Dirección', RegExp(r'^[A-Z][a-zA-Z0-9.,\-\s]+$'), 'Dirección inválida') != null) {
                      errors.add('La dirección debe empezar con mayúscula y puede contener números, puntos, comas y guiones.');
                    }
                    if (_validateField(telefono, 'Teléfono', RegExp(r'^\d{9}$'), 'Teléfono inválido') != null) {
                      errors.add('El teléfono debe tener exactamente 9 números.');
                    }

                    if (errors.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errors.join('\n'))),
                      );
                      return;
                    }

                    // Verificar si el usuario ya existe
                    if (await _dbHelper.isUsernameTaken(username)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El username ya está registrado')),
                      );
                      return;
                    }

                    // Crear usuario y guardarlo en la base de datos
                    User newUser = User(
                      nombre: nombre,
                      apellido: apellido,
                      username: username,
                      contrasena: password,
                      direccion: direccion,
                      telefono: telefono,
                    );

                    await _dbHelper.registerUser(newUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario registrado con éxito!')),
                    );
                    Navigator.pop(context); // Regresa a la pantalla de login
                  },
                  child: const Text('Registrar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
