import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:qemma_task/features/home/data/models/movie_model.dart';
import 'package:qemma_task/features/home/data/repo/movie_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _repository;
  int _currentPage = 1;

  static const int _maxPages = 2;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> fetchMovies({bool refresh = false}) async {
    if (state.isSearching || state.isLoading) return;
    if (_currentPage > _maxPages && !refresh) return;

    _emitLoadingState(refresh);

    try {
      final movies = await _repository.getPopularMovies(page: _currentPage);
      final updatedMovies = refresh ? movies : [...state.movies, ...movies];
      final reachedEnd = _currentPage >= _maxPages;

      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          movies: updatedMovies,
          hasReachedEnd: reachedEnd,
        ),
      );

      if (_currentPage < _maxPages) _currentPage++;
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

    Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty && !state.isSearching) {
      emit(state.copyWith(isSearching: true));
      return;
    }

    if (query.trim().isEmpty && state.isSearching) {
      _resetToPopularMovies();
      return;
    }

    emit(
      state.copyWith(
        status: HomeStateStatus.loading,
        movies: [],
        isSearching: true,
      ),
    );

    try {
      final results = await _repository.searchMovies(query: query);
      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          movies: results,
          hasReachedEnd: true,
          isSearching: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _emitLoadingState(bool refresh) {
    if (refresh) {
      _currentPage = 1;
      emit(
        state.copyWith(
          status: HomeStateStatus.loading,
          movies: [],
          hasReachedEnd: false,
          isSearching: false,
        ),
      );
    } else {
      emit(state.copyWith(status: HomeStateStatus.loading));
    }
  }

  void _resetToPopularMovies() {
    emit(state.copyWith(isSearching: false));
    fetchMovies(refresh: true);
  }
}
