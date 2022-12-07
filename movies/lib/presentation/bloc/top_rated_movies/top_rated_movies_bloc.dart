import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_movies_event.dart';

part 'top_rated_movies_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<OnTopRatedMovieEvent>(_onTopRatedMovieEvent);
  }

  FutureOr<void> _onTopRatedMovieEvent(
      OnTopRatedMovieEvent event, Emitter<TopRatedMovieState> emit) async {
    emit(TopRatedMovieLoading());
    final result = await _getTopRatedMovies.execute();

    result.fold((failure) {
      emit(TopRatedMovieError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(TopRatedMovieEmpty())
          : emit(TopRatedMovieHasData(success));
    });
  }
}