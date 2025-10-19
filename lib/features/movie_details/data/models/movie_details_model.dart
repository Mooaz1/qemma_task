import 'package:qemma_task/core/ui/app_endpoints/app_endpoints.dart';

class MovieDetailsModel {
  final int id;
  final String title;
  final String? releaseDate;
  final double rating;
  final int voteCount;
  final String? overview;
  final String? posterPath;
  final List<String> genres;
  final double? voteAverage;
  final String? tagline;
  final String? image; 

  MovieDetailsModel({
    required this.id,
    required this.title,
    this.releaseDate,
    required this.rating,
    required this.voteCount,
    this.overview,
    this.posterPath,
    this.genres = const [],
    this.voteAverage,
    this.tagline,
    this.image,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;
    final imageUrl = posterPath != null
        ? '${AppEndpoints.imageBaseUrl}$posterPath'
        : null;

    return MovieDetailsModel(
      id: json['id'],
      title: json['title'] ?? '',
      releaseDate: json['release_date'],
      rating: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      overview: json['overview'],
      posterPath: posterPath,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      tagline: json['tagline'],
      genres: (json['genres'] as List?)
              ?.map((genre) => genre['name'].toString())
              .toList() ??
          [],
      image: imageUrl,
    );
  }
}
