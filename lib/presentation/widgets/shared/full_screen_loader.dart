import 'package:flutter/material.dart';

// Este widget (`FullScreenLoader`) muestra una pantalla de carga en el centro de la pantalla.
// - Muestra un `CircularProgressIndicator` con mensajes dinámicos de carga.
// - Usa un `Stream` para cambiar los mensajes de estado cada 1.2 segundos.
// - Se detiene después de mostrar todos los mensajes disponibles.

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  /// Genera un flujo de mensajes que se emiten periódicamente
  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas', // Mensaje 1
      'Comprando palomitas de maíz', // Mensaje 2
      'Cargando populares', // Mensaje 3
      'Esto está tardando más de lo esperado :(', // Mensaje 4
    ];

    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step]; // Devuelve el mensaje correspondiente al paso actual
    }).take(messages.length); // Se detiene después de recorrer todos los mensajes
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos
        children: [
          const Text('Espere por favor'), // Mensaje de espera inicial
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2), // Indicador de carga
          const SizedBox(height: 10),

          // Muestra mensajes de carga dinámicos con StreamBuilder
          StreamBuilder(
            stream: getLoadingMessages(), // Usa el Stream de mensajes
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Cargando...'); // Mensaje por defecto

              return Text(snapshot.data!); // Muestra el mensaje emitido por el Stream
            },
          ),
        ],
      ),
    );
  }
}
