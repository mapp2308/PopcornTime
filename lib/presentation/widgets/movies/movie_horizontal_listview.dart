import 'package:popcorntime/config/helpers/human_formats.dart'; // Formateador de números para mostrar valores amigables
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Librería para animaciones
import 'package:popcorntime/domain/entities/movie.dart'; // Entidad Movie
import 'package:go_router/go_router.dart'; // Navegación con GoRouter

// Este widget (`MovieHorizontalListview`) muestra una lista horizontal de películas con desplazamiento.
// - Utiliza `ListView.builder` para cargar dinámicamente las películas en una lista horizontal.
// - Implementa paginación detectando el final del scroll con `ScrollController`.
// - Muestra la imagen de la película, su título, calificación y popularidad.
// - Usa `FadeInRight` y `FadeIn` para animaciones de entrada.
// - Al hacer tap en una película, navega a la pantalla de detalles usando `GoRouter`.

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies; // Lista de películas a mostrar
  final String? title; // Título opcional de la sección
  final String? subTitle; // Subtítulo opcional
  final VoidCallback? loadNextPage; // Callback para cargar la siguiente página de películas

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title, 
    this.subTitle,
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController(); // Controlador del scroll para detectar el final

  @override
  void initState() {
    super.initState();
    
    // Escucha los movimientos del scroll para cargar más películas cuando se acerca al final
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose(); // Limpia el controlador cuando el widget se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350, // Altura del contenedor principal
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle), // Muestra título y subtítulo si están definidos

          // Lista horizontal de películas
          Expanded(
            child: ListView.builder(
              controller: scrollController, // Controlador del scroll
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal, // Scroll horizontal
              physics: const BouncingScrollPhysics(), // Efecto de rebote al llegar al final
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index])); // Animación al aparecer cada película
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget que representa cada película en la lista
class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8), // Espaciado entre tarjetas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Imagen de la película
          SizedBox(
            width: 150, // Ancho de la imagen
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Bordes redondeados
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)), // Muestra un loader mientras carga la imagen
                    );
                  }
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'), // Navega a la pantalla de detalles de la película
                    child: FadeIn(child: child), // Aplica animación al mostrar la imagen
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          //* Título de la película
          SizedBox(
            width: 150, // Asegura que el texto no se expanda más de lo necesario
            child: Text(
              movie.title,
              maxLines: 2, // Limita a dos líneas
              style: textStyles.titleSmall,
            ),
          ),

          //* Calificación y popularidad
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800), // Ícono de calificación
                const SizedBox(width: 3),
                Text('${movie.voteAverage}', style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade800)), // Puntuación de la película
                const Spacer(),
                Text(HumanFormats.number(movie.popularity), style: textStyles.bodySmall), // Popularidad formateada
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar el título y subtítulo de la lista de películas
class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle), // Muestra el título si está definido

          const Spacer(),

          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {}, // Botón sin funcionalidad por ahora
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}
