import 'package:flutter/material.dart';
import 'package:qemma_task/core/ui/app_theme/app_theme.dart';
import 'package:qemma_task/features/home/data/models/movie_model.dart';
import 'package:qemma_task/features/home/presentation/widgets/movie_item.dart';
import 'package:redacted/redacted.dart';

class MoviesGridBody extends StatelessWidget {
  final bool isLoading;
  final bool hasReachedEnd;
  final List<MovieModel> movies;
  final VoidCallback onRefresh;
  final ScrollController scrollController;

  const MoviesGridBody({
    super.key,
    required this.isLoading,
    required this.hasReachedEnd,
    required this.movies,
    required this.onRefresh,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSkeletonGrid();
    }

    if (movies.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh(),
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

    return _buildMovieGrid();
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
      itemBuilder: (context, index) => _buildSkeletonItem(context: context),
    );
  }

  Widget _buildSkeletonItem({
    required BuildContext context,
  }) {
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

  Widget _buildMovieGrid() {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65,
        ),
        itemCount: movies.length + (hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) => _buildGridItem(context, index),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    if (index >= movies.length) {
      return _buildSkeletonItem(context: context);
    }

    return MovieItem(movie: movies[index]);
  }
}