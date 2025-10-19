part of 'movie_details_cubit.dart';

enum MovieDetailsStatus { initial, loading, loaded, error }

@immutable
class MovieDetailsState {
  final MovieDetailsStatus status;
  final MovieDetailsModel? movie;
  final String? errorMessage;

  const MovieDetailsState({
    this.status = MovieDetailsStatus.initial,
    this.movie,
    this.errorMessage,
  });

  bool get isInitial => status == MovieDetailsStatus.initial;
  bool get isLoading => status == MovieDetailsStatus.loading;
  bool get isLoaded => status == MovieDetailsStatus.loaded;
  bool get isError => status == MovieDetailsStatus.error;

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    MovieDetailsModel? movie,
    String? errorMessage,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
