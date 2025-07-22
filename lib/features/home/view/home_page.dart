import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/widgets/blurred_heart_button.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onFavoriteChanged;

  const HomePage({super.key, this.onFavoriteChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(ApiService())..loadMovies(),
      child: HomeView(onFavoriteChanged: onFavoriteChanged),
    );
  }
}

class HomeView extends StatelessWidget {
  final VoidCallback? onFavoriteChanged;

  const HomeView({super.key, this.onFavoriteChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.hasError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.movies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (state.hasError && state.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Bir hata oluştu',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<HomeCubit>().loadMovies(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (state.movies.isEmpty) {
            return const Center(
              child: Text(
                'Film bulunamadı',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadMovies(),
            color: AppColors.primary,
            child: PageView.builder(
              controller: context.read<HomeCubit>().pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: context.read<HomeCubit>().onPageChanged,
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                return MovieFullScreenCard(
                  movie: state.movies[index],
                  onFavoriteToggle: (movieId) {
                    context.read<HomeCubit>().toggleFavorite(
                      movieId,
                      onFavoriteChanged: onFavoriteChanged,
                    );
                  },
                  isLastItem: index == state.movies.length - 1,
                  isLoadingMore: state.isLoadingMore,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MovieFullScreenCard extends StatelessWidget {
  final Movie movie;
  final Function(String) onFavoriteToggle;
  final bool isLastItem;
  final bool isLoadingMore;

  const MovieFullScreenCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
    this.isLastItem = false,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surface,
      ),
      child: Stack(
        children: [
          // Movie Poster Background
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.poster,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.movie,
                    size: 100,
                    color: AppColors.textSecondary,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),

          // Bottom gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),

          // Keşfet text at top
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              'Keşfet',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Heart icon with blur effect
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            right: 20,
            child: BlurredHeartButton(
              isFavorite: movie.isFavorite,
              onTap: () => onFavoriteToggle(movie.id),
            ),
          ),

          // Movie Info at bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Netflix logo and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'N',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Movie details
                Text(
                  '${movie.director != null ? "${movie.director} • " : ""}${movie.genre} • ${movie.year}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Plot
                if (movie.plot != null && movie.plot!.isNotEmpty)
                  Text(
                    movie.plot!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Loading indicator for pagination
          if (isLastItem && isLoadingMore)
            const Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
