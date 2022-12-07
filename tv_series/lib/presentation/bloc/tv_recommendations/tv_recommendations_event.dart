part of 'tv_recommendations_bloc.dart';

abstract class TvRecommendationsEvent extends Equatable {}

class OnTvRecommendations extends TvRecommendationsEvent {
  final int id;

  OnTvRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}