import 'dart:async';

import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';



class WatchListTvBloc extends Bloc<WatchListTvEvent, WatchListTvState> {
  final GetWatchlistTv _getWatchlistTv;
  final GetWatchListStatus _getWatchListStatus;
  final RemoveWatchlist _removeWatchlist;
  final SaveWatchlist _saveWatchlist;

  WatchListTvBloc( this._getWatchlistTv, this._getWatchListStatus,
      this._removeWatchlist, this._saveWatchlist)
      : super(WatchListTvInitial()) {
    on<OnWatchListTv>(_onWatchListTv);
    on<WatchListTvStatus>(_onWatchListTvStatus);
    on<WatchListTvAdd>(_onWatchListTvAdd);
    on<WatchListTvRemove>(_onWatchListTvRemove);
  }

  FutureOr<void> _onWatchListTv(
      OnWatchListTv event, Emitter<WatchListTvState> emit) async {
    emit(WatchListTvLoading());
    final result = await _getWatchlistTv.execute();
    result.fold((failure) {
      emit(WatchListTvError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(WatchListTvEmpty())
          : emit(WatchListTvHasData(success));
    });
  }

  FutureOr<void> _onWatchListTvStatus(
      WatchListTvStatus event, Emitter<WatchListTvState> emit) async {
    final id = event.id;
    final result = await _getWatchListStatus.execute(id);
    emit(WatchListTvIsAdded(result));
  }

  FutureOr<void> _onWatchListTvAdd(
      WatchListTvAdd event, Emitter<WatchListTvState> emit) async {
    final tv = event.tvDetail;
    final result = await _saveWatchlist.execute(tv);
    result.fold((failure) {
      emit(WatchListTvError(failure.message));
    }, (success) {
      emit(WatchListTvMessage(success));
    });
  }

  // void _onWatchListTvAdd(WatchListTvAdd tv, Emitter<WatchListTvState> emitter) async {
  //   emitter(WatchListTvLoading());
  //   final result = await _saveWatchlist.execute(tv.tvDetail);

  //   result.fold(
  //     (failure) => emitter(WatchListTvError(failure.message)),
  //     (success) => emitter(WatchListTvHasData(result))
  //     );
  // }

  FutureOr<void> _onWatchListTvRemove(
      WatchListTvRemove event, Emitter<WatchListTvState> emit) async {
    final tv = event.tvDetail;
    final result = await _removeWatchlist.execute(tv);

    result.fold((failure) {
      emit(WatchListTvError(failure.message));
    }, (success) {
      emit(WatchListTvMessage(success));
    });
  }
}