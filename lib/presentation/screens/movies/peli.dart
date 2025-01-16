import 'package:flutter/material.dart';
import 'package:popcorntime/domain/entities/user.dart';

class MovieListApp extends StatelessWidget {
  final User currentUser;

  const MovieListApp({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieListScreen(currentUser: currentUser),
    );
  }
}

class MovieListScreen extends StatelessWidget {
  final User currentUser;

  const MovieListScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Favoritas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentUser.peliculasFavoritas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(currentUser.peliculasFavoritas[index]),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Por Ver:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentUser.peliculasPorVer.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(currentUser.peliculasPorVer[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}