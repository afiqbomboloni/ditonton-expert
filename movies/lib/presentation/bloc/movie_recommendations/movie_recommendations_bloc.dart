import 'dart:async';

import 'package:core/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_recommendations_state.dart';
part 'movie_recommendations_event.dart';



class MovieRecommendationsBloc extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationsBloc(this._getMovieRecommendations): super(MovieRecommendationsEmpty()) {on<OnMovieRecommendations>(_onMovieRecommendations);}

  FutureOr<void> _onMovieRecommendations(
      OnMovieRecommendations event, Emitter<MovieRecommendationsState> emit) async {
    final id = event.id;

    emit(MovieRecommendationsLoading());
    final result = await _getMovieRecommendations.execute(id);

    result.fold((failure) {
      emit(MovieRecommendationsError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(MovieRecommendationsEmpty())
          : emit(MovieRecommendationsHasData(success));
    });
  }
}