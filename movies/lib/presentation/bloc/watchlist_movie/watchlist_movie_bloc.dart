import 'dart:async';

import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';



class WatchListMovieBloc extends Bloc<WatchListMovieEvent, WatchListMovieState> {
  final GetWatchlistMovies _getWatchlistMovie;
  final GetWatchListStatusMovie _getWatchListStatus;
  final RemoveWatchlistMovie _removeWatchlist;
  final SaveWatchlistMovie _saveWatchlist;

  WatchListMovieBloc(this._getWatchlistMovie, this._getWatchListStatus,
      this._removeWatchlist, this._saveWatchlist)
      : super(WatchListMovieInitial()) {
    on<OnWatchListMovie>(_onWatchListMovie);
    on<WatchListMovieStatus>(_onWatchListMovieStatus);
    on<WatchListMovieAdd>(_onWatchListMovieAdd);
    on<WatchListMovieRemove>(_onWatchListMovieRemove);
  }

  FutureOr<void> _onWatchListMovie(
      OnWatchListMovie event, Emitter<WatchListMovieState> emit) async {
    emit(WatchListMovieLoading());
    final result = await _getWatchlistMovie.execute();
    result.fold((failure) {
      emit(WatchListMovieError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(WatchListMovieEmpty())
          : emit(WatchListMovieHasData(success));
    });
  }

  FutureOr<void> _onWatchListMovieStatus(
      WatchListMovieStatus event, Emitter<WatchListMovieState> emit) async {
    final id = event.id;
    final result = await _getWatchListStatus.execute(id);
    emit(WatchListMovieIsAdded(result));
  }

  FutureOr<void> _onWatchListMovieAdd(
      WatchListMovieAdd event, Emitter<WatchListMovieState> emit) async {
    final Movie = event.movieDetail;
    final result = await _saveWatchlist.execute(Movie);
    result.fold((failure) {
      emit(WatchListMovieError(failure.message));
    }, (success) {
      emit(WatchListMovieMessage(success));
    });
  }

  FutureOr<void> _onWatchListMovieRemove(
      WatchListMovieRemove event, Emitter<WatchListMovieState> emit) async {
    final Movie = event.movieDetail;
    final result = await _removeWatchlist.execute(Movie);

    result.fold((failure) {
      emit(WatchListMovieError(failure.message));
    }, (success) {
      emit(WatchListMovieMessage(success));
    });
  }
}