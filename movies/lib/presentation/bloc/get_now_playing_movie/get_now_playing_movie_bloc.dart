import 'dart:async';

import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';

part 'get_now_playing_movie_state.dart';
part 'get_now_playing_movie_event.dart';


class GetNowPlayingMovieBloc extends Bloc<GetNowPlayingMovieEvent, GetNowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  GetNowPlayingMovieBloc(this._getNowPlayingMovies) : super(GetNowPlayingEmpty()) {
    on<OnGetNowPlayingMovie>(_onGetNowPlayingMovie);
  }

  FutureOr<void> _onGetNowPlayingMovie(
      OnGetNowPlayingMovie event, Emitter<GetNowPlayingMovieState> emit) async {
    emit(GetNowPlayingLoading());
    final result = await _getNowPlayingMovies.execute();

    result.fold((failure) {
      emit(GetNowPlayingError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(GetNowPlayingEmpty())
          : emit(GetNowPlayingHasData(success));
    });
  }
}