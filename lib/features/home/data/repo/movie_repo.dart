
import 'dart:convert';
import 'dart:developer';

import 'package:qemma_task/core/ui/app_endpoints/app_endpoints.dart';
import 'package:qemma_task/features/home/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

abstract class HomeRepo {
  Future<List<MovieModel>> getPopularMovies({
    required int page
  });
   Future<List<MovieModel>> searchMovies({
    required String query
   });
}

class HomeRepoImpl implements HomeRepo {
  final http.Client client;

  HomeRepoImpl({required this.client});

  @override
  Future<List<MovieModel>> getPopularMovies({
    required int page,
  }) async {
    final url = Uri.parse('${AppEndpoints.popularMovies}?api_key=${AppEndpoints.apiKey}&page=$page');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      log('Failed to load movies (status: ${response.body})');
      throw Exception('Failed to load movies (status: ${response.statusCode})');
    }
  }

  @override
Future<List<MovieModel>> searchMovies({required String query}) async {
  final url = Uri.parse(
    '${AppEndpoints.searchMovies}?api_key=${AppEndpoints.apiKey}&query=$query',
  );

  final response = await client.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List results = data['results'];
    return results.map((e) => MovieModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to search movies');
  }
}
}