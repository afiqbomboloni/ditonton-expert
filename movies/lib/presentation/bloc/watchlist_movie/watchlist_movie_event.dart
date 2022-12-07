part of 'watchlist_movie_bloc.dart';

abstract class WatchListMovieEvent extends Equatable {}

class OnWatchListMovie extends WatchListMovieEvent {
  @override
  List<Object?> get props => [];
}

class WatchListMovieStatus extends WatchListMovieEvent {
  final int id;

  WatchListMovieStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class WatchListMovieAdd extends WatchListMovieEvent {
  final MovieDetail movieDetail;

  WatchListMovieAdd(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class WatchListMovieRemove extends WatchListMovieEvent {
  final MovieDetail movieDetail;

  WatchListMovieRemove(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}