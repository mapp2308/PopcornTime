import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart'; // Librería para el carrusel de imágenes
import 'package:animate_do/animate_do.dart'; // Librería para animaciones
import 'package:popcorntime/domain/entities/movie.dart'; // Entidad Movie
import 'package:popcorntime/presentation/screens/screens.dart'; // Pantallas de la aplicación

// Este widget (`MoviesSlideshow`) muestra un carrusel de películas con desplazamiento automático.
// - Utiliza `Swiper` para mostrar imágenes de películas en un pase de diapositivas.
// - Cada imagen es interactiva y redirige a la pantalla de detalles de la película al hacer clic.
// - `DotSwiperPaginationBuilder` maneja la paginación con indicadores visuales.
// - Se usa `FadeIn` para animar la carga de imágenes.
// - `_Slide` encapsula la visualización de cada imagen con bordes redondeados y sombra.

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies; // Lista de películas a mostrar en el carrusel

  const MoviesSlideshow({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme; // Obtiene el esquema de colores del tema actual

    return SizedBox(
      height: 210, // Altura del carrusel
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8, // Controla el ancho de cada imagen en la vista
        scale: 0.9, // Reduce ligeramente el tamaño de las imágenes no activas
        autoplay: true, // Activa el desplazamiento automático
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0), // Ajusta la posición de la paginación
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary, // Color de los puntos activos
            color: colors.secondary, // Color de los puntos inactivos
          ),
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(movie: movies[index]), // Construye cada diapositiva con una película
      ),
    );
  }
}

// Widget privado que representa una diapositiva del carrusel
class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20), // Bordes redondeados para la imagen
      boxShadow: const [
        BoxShadow(
          color: Colors.black45, // Sombra para dar efecto de elevación
          blurRadius: 10, // Difuminado de la sombra
          offset: Offset(0, 10), // Desplazamiento de la sombra
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        // Navega a la pantalla de detalles de la película al hacer clic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieScreen(movieId: movie.id.toString()),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30), // Espaciado inferior para la diapositiva
        child: DecoratedBox(
          decoration: decoration, // Aplica la sombra y bordes redondeados
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Aplica el borde redondeado a la imagen
            child: Image.network(
              movie.backdropPath, // URL de la imagen de fondo de la película
              fit: BoxFit.cover, // Ajusta la imagen para que cubra completamente el espacio
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black12), // Muestra un fondo gris mientras carga la imagen
                  );
                }
                return FadeIn(child: child); // Aplica animación al mostrar la imagen
              },
            ),
          ),
        ),
      ),
    );
  }
}
