import 'package:http/http.dart' as http;
import 'package:qemma_task/features/home/data/repo/movie_repo.dart';
import 'package:qemma_task/features/home/presentation/cubit/home_cubit.dart';
import 'package:qemma_task/features/movie_details/data/repo/movie_details_repo.dart';
import 'package:qemma_task/features/movie_details/presentation/cubit/movie_details_cubit.dart';

class Injector {
  final _flyweightMap = <Type, dynamic>{};
  static final _singleton = Injector._internal();

  Injector._internal();
  factory Injector() => _singleton;

  // //===================[Home_Cubit]===================
  HomeCubit get homeCubit => HomeCubit(homeRepository);
  HomeRepo get homeRepository =>
      _flyweightMap[HomeRepo] ??= HomeRepoImpl(client: http.Client());

      // //===================[MovieDetails_Cubit]===================
      MovieDetailsCubit get movieDetailsCubit => MovieDetailsCubit(movieDetailsRepository);
      MovieDetailsRepo get movieDetailsRepository =>
          _flyweightMap[MovieDetailsRepo] ??= MovieDetailsRepoImpl( http.Client());
}