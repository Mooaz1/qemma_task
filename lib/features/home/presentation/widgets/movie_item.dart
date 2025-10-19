import 'package:flutter/material.dart';
import 'package:qemma_task/core/ui/app_theme/app_theme.dart';
import 'package:qemma_task/core/ui/shared_widgets/image_widget.dart';
import 'package:qemma_task/features/home/data/models/movie_model.dart';
import 'package:qemma_task/features/movie_details/presentation/pages/movie_details_page.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child:ImageWidget(imageUrl: movie.image)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.theme.textTheme.bodyMedium,
                  ),
                  Text(
                    movie.releaseDate != null
                        ? movie.releaseDate!.split('-')[0]
                        : 'Unknown',
                    style: AppTheme.theme.textTheme.bodySmall,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toStringAsFixed(1),
                      ),
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
