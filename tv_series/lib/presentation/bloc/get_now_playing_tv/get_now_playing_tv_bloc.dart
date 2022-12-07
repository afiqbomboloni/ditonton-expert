import 'dart:async';

import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv.dart';

part 'get_now_playing_tv_state.dart';
part 'get_now_playing_tv_event.dart';


class GetNowPlayingTvBloc extends Bloc<GetNowPlayingTvEvent, GetNowPlayingTvState> {
  final GetNowPlayingTv _getNowPlayingTv;

  GetNowPlayingTvBloc(this._getNowPlayingTv) : super(GetNowPlayingTvEmpty()) {
    on<OnGetNowPlayingTv>(_onGetNowPlayingTv);
  }

  FutureOr<void> _onGetNowPlayingTv(
      OnGetNowPlayingTv event, Emitter<GetNowPlayingTvState> emit) async {
    emit(GetNowPlayingTvLoading());
    final result = await _getNowPlayingTv.execute();

    result.fold((failure) {
      emit(GetNowPlayingTvError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(GetNowPlayingTvEmpty())
          : emit(GetNowPlayingTvHasData(success));
    });
  }
}