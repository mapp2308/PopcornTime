import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    '/por-ver', // Ruta de por ver
  ];

  // Lista de íconos seleccionados y no seleccionados
  final List<IconData> _selectedIcons = [
    Icons.home, // Ícono seleccionado para "Inicio"
    Icons.label, // Ícono seleccionado para "Géneros"
    Icons.favorite, // Ícono seleccionado para "Favoritos"
    Icons.visibility, // Ícono seleccionado para "Por ver"
  ];

  final List<IconData> _unselectedIcons = [
    Icons.home_outlined, // Ícono no seleccionado para "Inicio"
    Icons.label_outline, // Ícono no seleccionado para "Géneros"
    Icons.favorite_outline, // Ícono no seleccionado para "Favoritos"
    Icons.visibility_outlined, // Ícono no seleccionado para "Por ver"
  ];

  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Detecta la ruta actual y actualiza el índice del BottomNavigationBar
    final String currentLocation = GoRouter.of(context).location;

    // Busca el índice correspondiente a la ruta actual
    final int index = _routes.indexOf(currentLocation);

    if (index >= 0) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      context.go(_routes[index]); // Navega a la ruta seleccionada
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      items: List.generate(_routes.length, (index) {
        return BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == index
                ? _selectedIcons[index]
                : _unselectedIcons[index],
          ),
          label: index == 0
              ? 'Inicio'
              : index == 1
                  ? 'Géneros'
                  : index == 2
                      ? 'Favoritos'
                      : 'Por ver',
        );
      }),
    );
  }
}
