// register_screen.dart
import 'package:flutter/material.dart';
import 'package:popcorntime/config/helpers/database_helper.dart';
import 'package:popcorntime/domain/entities/user.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              TextField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String nombre = _nombreController.text;
                  String apellido = _apellidoController.text;
                  String password = _passwordController.text;
                  String direccion = _direccionController.text;
                  String telefono = _telefonoController.text;

                  if (nombre.isNotEmpty &&
                      apellido.isNotEmpty &&
                      password.isNotEmpty &&
                      direccion.isNotEmpty &&
                      telefono.isNotEmpty) {
                    User newUser = User(
                      nombre: nombre,
                      apellido: apellido,
                      contrasena: password,
                      direccion: direccion,
                      telefono: telefono,
                    );

                    await _dbHelper.registerUser(newUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario registrado con éxito!')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, complete todos los campos')),
                    );
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
