import 'dart:async';

import 'package:core/domain/entities/tv.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_recommendations_state.dart';
part 'tv_recommendations_event.dart';



class TvRecommendationsBloc extends Bloc<TvRecommendationsEvent, TvRecommendationsState> {
  final GetTvRecommendations _getTvRecommendations;

  TvRecommendationsBloc(this._getTvRecommendations): super(TvRecommendationsEmpty()) {on<OnTvRecommendations>(_onTvRecommendations);}

  FutureOr<void> _onTvRecommendations(
      OnTvRecommendations event, Emitter<TvRecommendationsState> emit) async {
    final id = event.id;

    emit(TvRecommendationsLoading());
    final result = await _getTvRecommendations.execute(id);

    result.fold((failure) {
      emit(TvRecommendationsError(failure.message));
    }, (success) {
      success.isEmpty
          ? emit(TvRecommendationsEmpty())
          : emit(TvRecommendationsHasData(success));
    });
  }
}