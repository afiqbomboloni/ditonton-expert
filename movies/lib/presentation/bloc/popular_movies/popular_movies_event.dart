part of 'popular_movies_bloc.dart';

abstract class PopularMovieEvent extends Equatable{}

class OnPopularMovie extends PopularMovieEvent {
  @override
  List<Object?> get props => [];
}