import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod para la gestión del estado
import 'package:popcorntime/presentation/providers/providers.dart'; // Importa los proveedores de películas
import 'package:popcorntime/presentation/widgets/widgets.dart'; // Importa los widgets reutilizables

// Esta es la pantalla principal (`HomeScreen`) de la aplicación, donde se muestran las películas organizadas en diferentes categorías.
// - Usa `Riverpod` para manejar el estado de las películas (`nowPlayingMoviesProvider`, `popularMoviesProvider`, etc.).
// - Utiliza `CustomScrollView` con `SliverAppBar` y `SliverList` para mejorar el rendimiento al renderizar las películas.
// - La clase `_HomeViewState` maneja la carga inicial de películas utilizando `initState()`.
// - Se muestran películas en carrusel (`MoviesSlideshow`) y en listas horizontales (`MovieHorizontalListview`).
// - Se usa `ConsumerStatefulWidget` para permitir la actualización dinámica de la UI basada en el estado de Riverpod.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _HomeView(), // Contenido de la pantalla
      drawer: AppDrawer(), // Menú lateral
      bottomNavigationBar: const CustomBottomNavigation(), // Barra de navegación inferior
    );
  }
}

// Widget de la vista principal de la pantalla de inicio
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

// Estado de la pantalla de inicio
class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    // Carga la primera página de cada categoría de películas al iniciar la pantalla
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider); // Observa si aún se están cargando las películas
    if (initialLoading) return const FullScreenLoader(); // Muestra una pantalla de carga si los datos aún no están listos

    final slideShowMovies = ref.watch(moviesSlideshowProvider); // Películas para el carrusel
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider); // Películas en cartelera
    final popularMovies = ref.watch(popularMoviesProvider); // Películas populares
    final topRatedMovies = ref.watch(topRatedMoviesProvider); // Películas mejor valoradas
    final upcomingMovies = ref.watch(upcomingMoviesProvider); // Próximos estrenos

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true, // Permite que la barra de navegación desaparezca al hacer scroll hacia abajo
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(), // Barra superior personalizada
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  // Carrusel de películas destacadas
                  MoviesSlideshow(movies: slideShowMovies),

                  // Lista horizontal de películas en cartelera
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                  ),

                  // Lista horizontal de próximos estrenos
                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: 'Próximamente',
                    subTitle: 'En este mes',
                    loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                  ),

                  // Lista horizontal de películas populares
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares',
                    loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),

                  // Lista horizontal de películas mejor calificadas
                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: 'Mejor calificadas',
                    subTitle: 'Desde siempre',
                    loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                  ),

                  const SizedBox(height: 10),
                ],
              );
            },
            childCount: 1, // Solo se renderiza una vez para contener las listas de películas
          ),
        ),
      ],
    );
  }
}
