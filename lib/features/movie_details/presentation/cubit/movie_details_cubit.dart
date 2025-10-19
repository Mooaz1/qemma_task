import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:qemma_task/features/movie_details/data/models/movie_details_model.dart';
import 'package:qemma_task/features/movie_details/data/repo/movie_details_repo.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final MovieDetailsRepo _repository;

  MovieDetailsCubit(this._repository)
      : super(const MovieDetailsState(status: MovieDetailsStatus.initial));

  Future<void> fetchMovieDetails({required int movieId}) async {
    emit(state.copyWith(status: MovieDetailsStatus.loading));

    try {
      final details = await _repository.getMovieDetails(movieId: movieId);
      emit(state.copyWith(
        status: MovieDetailsStatus.loaded,
        movie: details,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieDetailsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
