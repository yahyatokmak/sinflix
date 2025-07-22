import 'movie.dart';
import '../../core/services/logger_service.dart';

class MovieListResponse {
  final List<Movie> movies;
  final Pagination pagination;

  MovieListResponse({required this.movies, required this.pagination});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final moviesList = json['movies'];
      if (moviesList == null || moviesList is! List) {
        throw Exception(
          'Movies field null veya list değil: ${moviesList.runtimeType}',
        );
      }

      final paginationData = json['pagination'];
      if (paginationData == null || paginationData is! Map<String, dynamic>) {
        throw Exception(
          'Pagination field null veya map değil: ${paginationData.runtimeType}',
        );
      }

      final movies = moviesList.map((item) {
        if (item is! Map<String, dynamic>) {
          throw Exception('Movie item map değil: ${item.runtimeType}');
        }
        return Movie.fromJson(item);
      }).toList();

      return MovieListResponse(
        movies: movies,
        pagination: Pagination.fromJson(paginationData),
      );
    } catch (e, stackTrace) {
      LoggerService.error('MovieListResponse fromJson parsing failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.map((movie) => movie.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Pagination {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  Pagination({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    try {
      return Pagination(
        totalCount: (json['totalCount'] is int)
            ? json['totalCount'] as int
            : int.parse(json['totalCount'].toString()),
        perPage: (json['perPage'] is int)
            ? json['perPage'] as int
            : int.parse(json['perPage'].toString()),
        maxPage: (json['maxPage'] is int)
            ? json['maxPage'] as int
            : int.parse(json['maxPage'].toString()),
        currentPage: (json['currentPage'] is int)
            ? json['currentPage'] as int
            : int.parse(json['currentPage'].toString()),
      );
    } catch (e, stackTrace) {
      LoggerService.error('Pagination fromJson parsing failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'perPage': perPage,
      'maxPage': maxPage,
      'currentPage': currentPage,
    };
  }
}
