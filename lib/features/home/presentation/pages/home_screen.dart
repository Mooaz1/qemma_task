import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qemma_task/core/di/injector.dart';
import 'package:qemma_task/core/ui/app_theme/app_theme.dart';
import 'package:qemma_task/core/ui/shared_widgets/app_snackbar.dart';
import 'package:qemma_task/features/home/data/models/movie_model.dart';
import 'package:qemma_task/features/home/presentation/cubit/home_cubit.dart';
import 'package:qemma_task/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:qemma_task/features/home/presentation/widgets/movie_item.dart';
import 'package:redacted/redacted.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _cubit = Injector().homeCubit;

    // Initialize data and listeners
    _cubit.fetchMovies();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_shouldLoadMore()) {
        _cubit.fetchMovies();
      }
    });
  }

  bool _shouldLoadMore() {
    final position = _scrollController.position;
    return position.pixels >= position.maxScrollExtent - 200 &&
        !_cubit.state.hasReachedEnd &&
        _cubit.state.isLoaded;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _cubit.searchMovies('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.isError) {
            showSnackBar(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: HomeAppBar(
              isSearching: state.isSearching,
              searchController: _searchController,
              onSearchToggle: () => _cubit.searchMovies(''),
              onClearSearch: _clearSearch,
              onSearchChanged: (query) => _cubit.searchMovies(query),
            ),  
            body: _buildBody(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    final state = _cubit.state;
    if (state.isLoading) {
      return _buildSkeletonGrid();
    }
    final movies = state.movies;
    if (movies.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => _cubit.fetchMovies(refresh: true),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No movies found',
                  style: AppTheme.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    final hasReachedEnd = state.hasReachedEnd;

    return _buildMovieGrid(movies: movies, hasReachedEnd: hasReachedEnd);
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(width: double.infinity, color: Colors.grey[300])
                .redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration: const Duration(milliseconds: 800),
                  ),
                ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ).redacted(
                    context: context,
                    redact: true,
                    configuration: RedactedConfiguration(
                      animationDuration: const Duration(milliseconds: 800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ).redacted(
                    context: context,
                    redact: true,
                    configuration: RedactedConfiguration(
                      animationDuration: const Duration(milliseconds: 800),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid({
    required List<MovieModel> movies,
    required bool hasReachedEnd,
  }) {
    return RefreshIndicator(
      onRefresh: () async => _cubit.fetchMovies(refresh: true),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65,
        ),
        itemCount: movies.length + (hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) =>
            _buildGridItem(movies: movies, index: index),
      ),
    );
  }

  Widget _buildGridItem({
    required List<MovieModel> movies,
    required int index,
  }) {
    if (index >= movies.length) {
      return _buildSkeletonItem();
    }

    return MovieItem(movie: movies[index]);
  }
}
