
import 'package:http/http.dart' as http;
import 'package:movies_app/src/models/actors_model.dart'; 

import 'dart:convert';
import 'dart:async';

import 'package:movies_app/src/models/movies_model.dart';




class MoviesProvider {

  String _apikey   = '27020785a9cc4dd4303a0ec158aaf698';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Movie> _populares = new List();

  final _popularesStreamController = StreamController<List<Movie>>.broadcast();


  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams() {
    _popularesStreamController?.close();
  }


  Future<List<Movie>> _procesarRespuesta(Uri url) async {
    
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final peliculas = new Movies.fromJsonList(decodedData['results']);


    return peliculas.items;

  }



   Future<List<Movie>> getMovies() async {
    
      try {
        final resp = await http.get('https://api.themoviedb.org/3/movie/top_rated?api_key=27020785a9cc4dd4303a0ec158aaf698&language=en-US&page=1');
        final deco = json.decode(resp.body);

        final movie = new Movies.fromJsonList(deco['results']);
      //  print(deco['results']);
        return movie.items;
      } catch (e) {
      }

  }


  Future<List<Movie>> getPopulares() async {
    
      try {
        final resp = await http.get('https://api.themoviedb.org/3/movie/popular?api_key=27020785a9cc4dd4303a0ec158aaf698&language=en-US&page=7');
        final deco = json.decode(resp.body);

        final movie = new Movies.fromJsonList(deco['results']);
      //  print(deco['results']);
        return movie.items;
      } catch (e) {
      }

  }

  Future<List<Actor>> getCast( String peliId ) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

  }


  Future<List<Movie>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });

    return await _procesarRespuesta(url);

  }

}

