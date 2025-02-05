import 'package:flutter/material.dart';
import 'package:popcorntime/domain/entities/movie.dart'; // Importa la entidad Movie
import 'package:popcorntime/infraestrucuture/datasource/moviedb_datasource.dart'; // Fuente de datos para obtener películas desde la API
import 'package:popcorntime/presentation/screens/screens.dart'; // Importa pantallas de la aplicación
import 'package:popcorntime/presentation/widgets/widgets.dart'; // Importa widgets reutilizables como el Drawer y la barra de navegación

// Este código maneja la pantalla de géneros de películas (`GenersScreen`) y la pantalla de películas por género (`MoviesByCategoryPage`).
// - `GenersScreen`: Obtiene y muestra los géneros de películas en un `GridView`, permitiendo al usuario seleccionar un género para ver sus películas.
// - `MoviesByCategoryPage`: Obtiene y muestra las películas de un género específico en una lista vertical.
// - Se usa `FutureBuilder` para manejar la carga de datos de la API.
// - Se utilizan `Navigator.push` para navegar entre pantallas.

class GenersScreen extends StatelessWidget {
  final MoviedbDatasource moviesDatasource = MoviedbDatasource(); // Instancia del proveedor de datos para obtener géneros

  GenersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Géneros', style: textStyles.titleLarge),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: moviesDatasource.getGenres(), // Obtiene los géneros de películas desde la API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay géneros disponibles.', style: textStyles.bodyLarge), // Muestra un mensaje si no hay datos
            );
          }

          final categories = snapshot.data!; // Obtiene la lista de géneros

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Muestra los géneros en una cuadrícula de 2 columnas
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3, // Reduce la altura de las tarjetas
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    // Navega a la pantalla de películas del género seleccionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoviesByCategoryPage(
                          categoryId: category['id'] as int,
                          categoryName: category['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey.shade800, // Color de fondo de cada categoría
                    ),
                    child: Center(
                      child: Text(
                        category['name'] as String,
                        style: textStyles.titleMedium!.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      drawer: AppDrawer(), // Agrega el menú lateral de la aplicación
      bottomNavigationBar: const CustomBottomNavigation(), // Agrega la barra de navegación inferior
    );
  }
}

// Pantalla que muestra las películas de un género específico
class MoviesByCategoryPage extends StatelessWidget {
  final int categoryId; // ID del género seleccionado
  final String categoryName; // Nombre del género seleccionado
  final MoviedbDatasource moviesDatasource = MoviedbDatasource(); // Instancia del proveedor de datos

  MoviesByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas de $categoryName', style: textStyles.titleLarge), // Muestra el nombre del género en la barra de título
        centerTitle: true,
      ),
      body: FutureBuilder<List<Movie>>(
        future: moviesDatasource.getMoviesByCategory(categoryId: categoryId), // Obtiene las películas del género seleccionado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay películas disponibles en este género.', style: textStyles.bodyLarge), // Mensaje si no hay películas en el género
            );
          }

          final movies = snapshot.data!; // Obtiene la lista de películas

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return GestureDetector(
                onTap: () {
                  // Navega a la pantalla de detalles de la película seleccionada
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieScreen(
                        movieId: movie.id.toString(),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Redondea las esquinas de la imagen
                        child: Image.network(
                          movie.posterPath, // Muestra la imagen del póster de la película
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error), // Muestra un ícono de error si la imagen no carga
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: textStyles.titleMedium), // Muestra el título de la película
                            const SizedBox(height: 5),
                            Text(
                              movie.overview.length > 100
                                  ? '${movie.overview.substring(0, 100)}...' // Limita la descripción a 100 caracteres
                                  : movie.overview,
                              style: textStyles.bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.star_half_rounded, color: Colors.yellow.shade800), // Ícono de calificación
                                const SizedBox(width: 5),
                                Text(
                                  movie.voteAverage.toString(), // Muestra la calificación de la película
                                  style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
