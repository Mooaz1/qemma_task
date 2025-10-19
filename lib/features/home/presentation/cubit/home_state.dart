part of 'home_cubit.dart';

enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

@immutable
class HomeState {
  final HomeStateStatus status;
  final List<MovieModel> movies;
  final bool hasReachedEnd;
  final String? errorMessage;
  final bool isSearching;

  const HomeState({
    this.status = HomeStateStatus.initial,
    this.movies = const [],
    this.hasReachedEnd = false,
    this.errorMessage,
    this.isSearching = false,
  });

  bool get isInitial => status == HomeStateStatus.initial;
  bool get isLoading => status == HomeStateStatus.loading;
  bool get isLoaded => status == HomeStateStatus.loaded;
  bool get isError => status == HomeStateStatus.error;

  HomeState copyWith({
    HomeStateStatus? status,
    List<MovieModel>? movies,
    bool? hasReachedEnd,
    String? errorMessage,
    bool? isSearching,
  }) {
    return HomeState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage ?? this.errorMessage,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}