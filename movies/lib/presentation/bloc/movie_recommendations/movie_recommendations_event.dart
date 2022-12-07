part of 'movie_recommendations_bloc.dart';

abstract class MovieRecommendationsEvent extends Equatable {}

class OnMovieRecommendations extends MovieRecommendationsEvent {
  final int id;

  OnMovieRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}