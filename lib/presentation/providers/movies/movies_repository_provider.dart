import 'package:cinemapedia/infraestrucuture/datasource/moviedb_datasource.dart';
import 'package:cinemapedia/infraestrucuture/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Este repositorio es inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl( MoviedbDatasource() );
});