import 'package:flutter/material.dart';
import 'package:qemma_task/core/ui/app_theme/app_theme.dart';
import 'package:qemma_task/core/ui/shared_widgets/image_widget.dart';
import 'package:qemma_task/features/home/data/models/movie_model.dart';
import 'package:qemma_task/features/movie_details/presentation/pages/movie_details_page.dart';
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
    if (isLoading && movies.isEmpty) {
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

    return _buildMovieGrid(context);
  }

  // ---------------------
  // Skeleton Grid
  // ---------------------

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
                  redact: true,
                  context: context,
                  configuration:  RedactedConfiguration(
                    animationDuration: Duration(milliseconds: 800),
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
                    redact: true,
                    context: context,
                    configuration:  RedactedConfiguration(
                      animationDuration: Duration(milliseconds: 800),
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
                    redact: true,
                    context: context,
                    configuration:  RedactedConfiguration(
                      animationDuration: Duration(milliseconds: 800),
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

  // ---------------------
  // Movie Grid
  // ---------------------

  Widget _buildMovieGrid(BuildContext context) {
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
        itemBuilder: (context, index) =>
            _buildGridItem(context, movies: movies, index: index),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required List<MovieModel> movies,
    required int index,
  }) {
    if (index >= movies.length) return _buildSkeletonItem(context: context);

    final movie = movies[index];
   

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(
              movieId: movie.id,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child:ImageWidget(imageUrl: movie.image)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    movie.releaseDate != null
                        ? movie.releaseDate!.split('-')[0]
                        : 'Unknown',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
