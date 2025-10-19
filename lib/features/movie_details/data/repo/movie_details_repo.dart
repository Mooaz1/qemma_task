import 'dart:convert';

import 'package:qemma_task/core/ui/app_endpoints/app_endpoints.dart';
import 'package:qemma_task/features/movie_details/data/models/movie_details_model.dart';

import 'package:http/http.dart' as http;

abstract class MovieDetailsRepo {
  Future<MovieDetailsModel> getMovieDetails({
    required int movieId,
  });
}

class MovieDetailsRepoImpl implements MovieDetailsRepo {
  final http.Client client;

  MovieDetailsRepoImpl(this.client);

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    final url = Uri.parse(
        '${AppEndpoints.movieDetails}$movieId?api_key=${AppEndpoints.apiKey}');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}