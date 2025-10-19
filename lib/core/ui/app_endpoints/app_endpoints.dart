import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEndpoints {
   static const String _baseUrl = 'https://api.themoviedb.org/3';
   static const String popularMovies='$_baseUrl/movie/popular';
   static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
   static const String movieDetails='$_baseUrl/movie/';
   static const String searchMovies='$_baseUrl/search/movie';
    static String get apiKey {
    final key = dotenv.env['TMDB_API_KEY'] ?? '';
    assert(key.isNotEmpty, '❗ TMDB_API_KEY must be set in .env');
    return key;
  }
}