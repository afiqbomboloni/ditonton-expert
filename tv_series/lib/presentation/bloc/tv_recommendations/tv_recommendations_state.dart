part of 'tv_recommendations_bloc.dart';

abstract class TvRecommendationsState extends Equatable {}

class TvRecommendationsEmpty extends TvRecommendationsState {
  @override
  List<Object?> get props => [];
}

class TvRecommendationsLoading extends TvRecommendationsState {
  @override
  List<Object?> get props => [];
}

class TvRecommendationsError extends TvRecommendationsState {
  final String message;

  TvRecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvRecommendationsHasData extends TvRecommendationsState {
  final List<Tv> result;

  TvRecommendationsHasData(this.result);

  @override
  List<Object?> get props => [result];
}