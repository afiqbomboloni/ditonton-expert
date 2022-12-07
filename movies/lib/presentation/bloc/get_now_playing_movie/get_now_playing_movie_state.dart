part of 'get_now_playing_movie_bloc.dart';

abstract class GetNowPlayingMovieState extends Equatable {}

class GetNowPlayingEmpty extends GetNowPlayingMovieState {
  @override
  List<Object?> get props => [];
}

class GetNowPlayingLoading extends GetNowPlayingMovieState {
  @override
  List<Object?> get props => [];
}

class GetNowPlayingError extends GetNowPlayingMovieState {
  final String message;

  GetNowPlayingError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetNowPlayingHasData extends GetNowPlayingMovieState {
  final List<Movie> result;

  GetNowPlayingHasData(this.result);

  @override
  List<Object?> get props => [result];
}