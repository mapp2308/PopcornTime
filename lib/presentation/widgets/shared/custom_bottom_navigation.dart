import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Manejo de rutas con GoRouter

// Este widget (`CustomBottomNavigation`) implementa una barra de navegación inferior con cuatro secciones:
// - Inicio (`/`)
// - Géneros (`/generos`)
// - Favoritos (`/favoritos`)
// - Por ver (`/por-ver`)
// - Se actualiza dinámicamente para resaltar la pestaña activa en función de la ruta actual.
// - Utiliza `GoRouter` para la navegación entre páginas.

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  // Define las rutas asociadas a cada índice del BottomNavigationBar
  final List<String> _routes = [
    '/', // Ruta de inicio
    '/generos', // Ruta de géneros
    '/favoritos', // Ruta de favoritos
    '/por-ver', // Ruta de películas por ver
  ];

  // Íconos cuando están seleccionados
  final List<IconData> _selectedIcons = [
    Icons.home, // Ícono seleccionado para "Inicio"
    Icons.label, // Ícono seleccionado para "Géneros"
    Icons.favorite, // Ícono seleccionado para "Favoritos"
    Icons.visibility, // Ícono seleccionado para "Por ver"
  ];

  // Íconos cuando NO están seleccionados
  final List<IconData> _unselectedIcons = [
    Icons.home_outlined, // Ícono no seleccionado para "Inicio"
    Icons.label_outline, // Ícono no seleccionado para "Géneros"
    Icons.favorite_outline, // Ícono no seleccionado para "Favoritos"
    Icons.visibility_outlined, // Ícono no seleccionado para "Por ver"
  ];

  int _currentIndex = 0; // Índice de la pestaña activa

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Detecta la ruta actual y actualiza el índice del BottomNavigationBar
    final String currentLocation = GoRouter.of(context).location;

    // Busca el índice correspondiente a la ruta actual
    final int index = _routes.indexOf(currentLocation);

    if (index >= 0) {
      setState(() {
        _currentIndex = index; // Actualiza la pestaña activa
      });
    }
  }

  // Método que maneja la navegación cuando el usuario selecciona una pestaña
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      context.go(_routes[index]); // Cambia de pantalla usando GoRouter
      setState(() {
        _currentIndex = index; // Actualiza la pestaña activa
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Establece la pestaña activa
      onTap: _onItemTapped, // Maneja los taps en las pestañas
      elevation: 0, // Elimina la sombra del BottomNavigationBar
      type: BottomNavigationBarType.fixed, // Mantiene los iconos en su lugar incluso con más de 3 opciones
      items: List.generate(_routes.length, (index) {
        return BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == index
                ? _selectedIcons[index] // Muestra el icono activo si la pestaña está seleccionada
                : _unselectedIcons[index], // Muestra el icono inactivo si la pestaña NO está seleccionada
          ),
          label: index == 0
              ? 'Inicio'
              : index == 1
                  ? 'Géneros'
                  : index == 2
                      ? 'Favoritos'
                      : 'Por ver', // Etiqueta de la pestaña
        );
      }),
    );
  }
}
