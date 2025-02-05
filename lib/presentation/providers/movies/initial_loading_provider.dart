import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod para la gestión del estado
import 'movies_providers.dart'; // Importa los proveedores de películas

// Este código define un `Provider` llamado `initialLoadingProvider` que determina si la aplicación 
// aún está cargando las películas. Se basa en cuatro proveedores (`nowPlayingMoviesProvider`, 
// `popularMoviesProvider`, `topRatedMoviesProvider`, `upcomingMoviesProvider`) y devuelve `true` 
// si alguno de ellos está vacío, indicando que la carga no ha finalizado.

final initialLoadingProvider = Provider<bool>((ref) {

  // Se verifican los estados de carga de diferentes categorías de películas
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty; // Películas en cartelera
  final step2 = ref.watch(popularMoviesProvider).isEmpty; // Películas populares
  final step3 = ref.watch(topRatedMoviesProvider).isEmpty; // Películas mejor valoradas
  final step4 = ref.watch(upcomingMoviesProvider).isEmpty; // Próximos estrenos

  // Si alguna de las listas está vacía, significa que aún estamos cargando datos
  if (step1 || step2 || step3 || step4) return true;

  return false; // Si todas las listas tienen datos, la carga ha finalizado
});
