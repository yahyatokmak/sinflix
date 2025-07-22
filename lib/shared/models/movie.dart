import '../../core/services/logger_service.dart';

class Movie {
  final String? mongoId;
  final String id;
  final String title;
  final String year;
  final String? rated;
  final String? released;
  final String? runtime;
  final String genre;
  final String? director;
  final String? writer;
  final String? actors;
  final String? plot;
  final String? language;
  final String? country;
  final String? awards;
  final String poster;
  final String? metascore;
  final String imdbRating;
  final String? imdbVotes;
  final String? imdbID;
  final String? type;
  final String? response;
  final List<String>? images;
  final bool comingSoon;
  final bool isFavorite;

  Movie({
    this.mongoId,
    this.id = '',
    this.title = '',
    this.year = '',
    this.rated,
    this.released,
    this.runtime,
    this.genre = '',
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.poster = '',
    this.metascore,
    this.imdbRating = '0.0',
    this.imdbVotes,
    this.imdbID,
    this.type,
    this.response,
    this.images,
    this.comingSoon = false,
    this.isFavorite = false,
  });

  static String _convertToHttps(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    try {
      return Movie(
        mongoId: json['_id']?.toString(),
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        title: json['Title']?.toString() ?? 'Bilinmeyen Film',
        year: json['Year']?.toString() ?? '',
        rated: json['Rated']?.toString(),
        released: json['Released']?.toString(),
        runtime: json['Runtime']?.toString(),
        genre: json['Genre']?.toString() ?? 'Bilinmeyen Kategori',
        director: json['Director']?.toString(),
        writer: json['Writer']?.toString(),
        actors: json['Actors']?.toString(),
        plot: json['Plot']?.toString(),
        language: json['Language']?.toString(),
        country: json['Country']?.toString(),
        awards: json['Awards']?.toString(),
        poster: _convertToHttps(json['Poster']?.toString() ?? ''),
        metascore: json['Metascore']?.toString(),
        imdbRating: json['imdbRating']?.toString() ?? '0.0',
        imdbVotes: json['imdbVotes']?.toString(),
        imdbID: json['imdbID']?.toString(),
        type: json['Type']?.toString(),
        response: json['Response']?.toString(),
        images: json['Images'] != null && json['Images'] is List
            ? (json['Images'] as List).map((e) => e.toString()).toList()
            : null,
        comingSoon: json['ComingSoon'] == true,
        isFavorite: json['isFavorite'] == true,
      );
    } catch (e, stackTrace) {
      LoggerService.error('Movie fromJson parsing failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': mongoId,
      'id': id,
      'Title': title,
      'Year': year,
      'Rated': rated,
      'Released': released,
      'Runtime': runtime,
      'Genre': genre,
      'Director': director,
      'Writer': writer,
      'Actors': actors,
      'Plot': plot,
      'Language': language,
      'Country': country,
      'Awards': awards,
      'Poster': poster,
      'Metascore': metascore,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
      'imdbID': imdbID,
      'Type': type,
      'Response': response,
      'Images': images,
      'ComingSoon': comingSoon,
      'isFavorite': isFavorite,
    };
  }

  Movie copyWith({bool? isFavorite}) {
    return Movie(
      mongoId: mongoId,
      id: id,
      title: title,
      year: year,
      rated: rated,
      released: released,
      runtime: runtime,
      genre: genre,
      director: director,
      writer: writer,
      actors: actors,
      plot: plot,
      language: language,
      country: country,
      awards: awards,
      poster: poster,
      metascore: metascore,
      imdbRating: imdbRating,
      imdbVotes: imdbVotes,
      imdbID: imdbID,
      type: type,
      response: response,
      images: images,
      comingSoon: comingSoon,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
