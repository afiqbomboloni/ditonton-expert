import 'dart:async';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/get_popular_tv.dart';

part 'popular_tv_state.dart';
part 'popular_tv_event.dart';


class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvEmpty()) {
    on<OnPopularTv>(_onPopulartV);
  }

  FutureOr<void> _onPopulartV(
      OnPopularTv event, Emitter<PopularTvState> emit) async {
    emit(PopularTvLoading());
    final result = await _getPopularTv.execute();

    result.fold((failure) {
      emit(PopularTvError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(PopularTvEmpty())
          : emit(PopularTvHasData(success));
    });
  }
}