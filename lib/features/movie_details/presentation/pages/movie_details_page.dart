import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qemma_task/core/di/injector.dart';
import 'package:qemma_task/core/ui/app_theme/app_theme.dart';
import 'package:qemma_task/core/ui/shared_widgets/app_snackbar.dart';
import 'package:qemma_task/core/ui/shared_widgets/image_widget.dart';
import 'package:qemma_task/core/ui/strings_manager/strings_manager.dart';
import 'package:qemma_task/features/movie_details/data/models/movie_details_model.dart';
import 'package:qemma_task/features/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:qemma_task/features/movie_details/presentation/widgets/movie_details_skeleton.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injector().movieDetailsCubit
        ..fetchMovieDetails(movieId: movieId),
      child: BlocConsumer<MovieDetailsCubit, MovieDetailsState>(
        listener: (context, state) {
          if (state.isError) {
            showSnackBar(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state.isLoading ) {
            return const MovieDetailsSkeleton();
          }

         final movie=state.movie;

         if(movie==null){
          return Center(
            child: Text("No Data Found!",
            style: AppTheme.theme.textTheme.bodyLarge,),
          );
         }

          return _buildDetailsView(movie: movie);
        },
      ),
    );
  }

  

  Widget _buildDetailsView({
    required MovieDetailsModel movie
  }) {

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPosterSection(movie),
            const SizedBox(height: 16),
            _buildTitleSection(movie),
            const SizedBox(height: 8),
            _buildReleaseDateSection(movie),
            const SizedBox(height: 8),
            _buildRatingSection(movie),
            if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTaglineSection(movie),
            ],
            const SizedBox(height: 16),
            _buildOverviewSection(movie),
            if (movie.genres.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildGenresSection(movie),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPosterSection(MovieDetailsModel movie) {

    return Center(
      child: Hero(
        tag: 'moviePoster-$movieId',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ImageWidget(imageUrl: movie.image),
        ),
      ),
    );
  }

  Widget _buildTitleSection(dynamic movie) {
    return Text(
      movie.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildReleaseDateSection(dynamic movie) {
    return Text(
      '${StringsManager.releaseLabel}: ${movie.releaseDate ?? StringsManager.unknownDate}',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildRatingSection(dynamic movie) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 24),
        const SizedBox(width: 4),
        Text(
          '${movie.voteAverage?.toStringAsFixed(1) ?? '0.0'} '
          '(${movie.voteCount ?? 0} ${StringsManager.votesLabel})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTaglineSection(dynamic movie) {
    return Text(
      '"${movie.tagline!}"',
      style: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildOverviewSection(dynamic movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          StringsManager.overviewLabel,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.overview ?? StringsManager.noOverview,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildGenresSection(MovieDetailsModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          StringsManager.genresLabel,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.genres
              .map<Widget>(
                (genre) => Chip(
                  label: Text(genre),
                  backgroundColor: Colors.blueGrey[100],
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

 
}