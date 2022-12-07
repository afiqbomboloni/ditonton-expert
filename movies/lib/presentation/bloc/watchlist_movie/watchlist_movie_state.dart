part of 'watchlist_movie_bloc.dart';

abstract class WatchListMovieState extends Equatable {}

class WatchListMovieInitial extends WatchListMovieState {
  @override
  List<Object?> get props => [];
}

class WatchListMovieEmpty extends WatchListMovieState {
  @override
  List<Object?> get props => [];
}

class WatchListMovieLoading extends WatchListMovieState {
  @override
  List<Object?> get props => [];
}

class WatchListMovieError extends WatchListMovieState {
  final String message;

  WatchListMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchListMovieHasData extends WatchListMovieState {
  final List<Movie> result;

  WatchListMovieHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class WatchListMovieIsAdded extends WatchListMovieState {
  final bool isAdded;

  WatchListMovieIsAdded(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class WatchListMovieMessage extends WatchListMovieState {
  final String message;

  WatchListMovieMessage(this.message);

  @override
  List<Object?> get props => [message];
}