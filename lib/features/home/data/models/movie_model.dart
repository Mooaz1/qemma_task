import 'package:qemma_task/core/ui/app_endpoints/app_endpoints.dart';

class MovieModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final double rating;
  final String? image;
  MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    required this.rating,
    this.image,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;
    final imageUrl = posterPath != null
        ? '${AppEndpoints.imageBaseUrl}$posterPath'
        : null; 

    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: posterPath,
      releaseDate: json['release_date'],
      rating: (json['vote_average'] ?? 0).toDouble(),
      image: imageUrl,
    );
  }
}
