import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

/// Skeleton loading widget for movie details screen
class MovieDetailsSkeleton extends StatelessWidget {
  const MovieDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSkeletonBox(width: 120, height: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster skeleton
            Center(
              child: _buildSkeletonBox(
                width: 270,
                height: 400,
                borderRadius: 16,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title skeleton
            _buildSkeletonBox(
              width: double.infinity,
              height: 24,
              borderRadius: 4,
            ),
            const SizedBox(height: 8),
            
            // Release date skeleton
            _buildSkeletonBox(
              width: 150,
              height: 16,
              borderRadius: 4,
            ),
            const SizedBox(height: 8),
            
            // Rating skeleton
            Row(
              children: [
                _buildSkeletonBox(
                  width: 24,
                  height: 24,
                  borderRadius: 12,
                ),
                const SizedBox(width: 8),
                _buildSkeletonBox(
                  width: 120,
                  height: 16,
                  borderRadius: 4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tagline skeleton
            _buildSkeletonBox(
              width: 200,
              height: 16,
              borderRadius: 4,
            ),
            const SizedBox(height: 16),
            
            // Overview label skeleton
            _buildSkeletonBox(
              width: 100,
              height: 20,
              borderRadius: 4,
            ),
            const SizedBox(height: 8),
            
            // Overview text skeleton (multiple lines)
            ..._buildMultiLineSkeletons(lineCount: 5),
            
            const SizedBox(height: 16),
            
            // Genres label skeleton
            _buildSkeletonBox(
              width: 80,
              height: 20,
              borderRadius: 4,
            ),
            const SizedBox(height: 8),
            
            // Genres chips skeleton
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                3,
                (index) => _buildSkeletonBox(
                  width: 80,
                  height: 32,
                  borderRadius: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ).redacted(
      context: context,
      redact: true,
      configuration: RedactedConfiguration(
        animationDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  Widget _buildSkeletonBox({
    required double width,
    required double height,
    double borderRadius = 0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  List<Widget> _buildMultiLineSkeletons({required int lineCount}) {
    return List.generate(
      lineCount,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _buildSkeletonBox(
          width: index == lineCount - 1 ? 200 : double.infinity,
          height: 14,
          borderRadius: 4,
        ),
      ),
    );
  }
}