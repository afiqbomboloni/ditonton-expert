import 'package:core/core.dart';
import 'package:core/data/datasources/db/database_helper_movie.dart';
import 'package:core/data/models/movie_table.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getWatchlistMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelperMovie databaseHelperMovie;

  MovieLocalDataSourceImpl({required this.databaseHelperMovie});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      await databaseHelperMovie.insertWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      await databaseHelperMovie.removeWatchlist(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final result = await databaseHelperMovie.getMovieById(id);
    if (result != null) {
      return MovieTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() async {
    final result = await databaseHelperMovie.getWatchlistMovies();
    return result.map((data) => MovieTable.fromMap(data)).toList();
  }
}
