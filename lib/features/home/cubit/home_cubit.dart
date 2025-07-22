import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiService _apiService;
  final PageController pageController = PageController();

  HomeCubit(this._apiService) : super(HomeState.initial());

  Future<void> loadMovies() async {
    emit(HomeState.loading());

    try {
      final response = await _apiService.getMovies(page: 1);

      if (response.data != null) {
        final movieList = response.data!;
        final hasReachedMax =
            movieList.pagination.currentPage >= movieList.pagination.maxPage;

        emit(
          HomeState.loaded(
            movieList.movies,
            movieList.pagination.currentPage,
            hasReachedMax,
          ),
        );
      } else {
        emit(HomeState.error('Film listesi yüklenemedi'));
      }
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> loadMoreMovies() async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(HomeState.loadingMore(state.movies, state.currentPage));

    try {
      final nextPage = state.currentPage + 1;
      final response = await _apiService.getMovies(page: nextPage);

      if (response.data != null) {
        final movieList = response.data!;
        final allMovies = [...state.movies, ...movieList.movies];
        final hasReachedMax =
            movieList.pagination.currentPage >= movieList.pagination.maxPage;

        emit(
          HomeState.loaded(
            allMovies,
            movieList.pagination.currentPage,
            hasReachedMax,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoadingMore: false,
            hasError: true,
            errorMessage: 'Daha fazla film yüklenemedi',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          hasError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> toggleFavorite(
    String movieId, {
    Function()? onFavoriteChanged,
  }) async {
    try {
      await _apiService.toggleMovieFavorite(movieId);

      final updatedMovies = state.movies.map((movie) {
        if (movie.id == movieId) {
          return movie.copyWith(isFavorite: !movie.isFavorite);
        }
        return movie;
      }).toList();

      emit(state.copyWith(movies: updatedMovies));

      onFavoriteChanged?.call();
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: 'Favori işlemi başarısız: ${e.toString()}',
        ),
      );
    }
  }

  void onPageChanged(int index) {
    if (index >= state.movies.length - 2 &&
        !state.hasReachedMax &&
        !state.isLoadingMore) {
      loadMoreMovies();
    }
  }

  void resetState() {
    emit(HomeState.initial());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
