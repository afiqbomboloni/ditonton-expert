import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv.dart';

part 'top_rated_tv_event.dart';

part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvEmpty()) {
    on<OnTopRatedTvEvent>(_onTopRatedTvEvent);
  }

  FutureOr<void> _onTopRatedTvEvent(
      OnTopRatedTvEvent event, Emitter<TopRatedTvState> emit) async {
    emit(TopRatedTvLoading());
    final result = await _getTopRatedTv.execute();

    result.fold((failure) {
      emit(TopRatedTvError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(TopRatedTvEmpty())
          : emit(TopRatedTvHasData(success));
    });
  }
}