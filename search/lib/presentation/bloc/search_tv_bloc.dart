

import 'package:search/domain/usecases/search_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/tv.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchTvBloc extends Bloc<SearchEvent, SearchTvState> {
  final SearchTv _searchTv;

  SearchTvBloc(this._searchTv) : super(SearchTvEmpty()) {
  on<OnQueryChanged>((event, emit) async {
    final query = event.query;
 
    emit(SearchTvLoading());
    final result = await _searchTv.execute(query);
 
    result.fold(
      (failure) {
        emit(SearchTvError(failure.message));
      },
      (data) {
        emit(SearchTvHasData(data));
      },
    );
  }, transformer: debounce(const Duration(milliseconds: 500)));
}


 
}

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchEvent {
  final String query;
  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object> get props => [];
}

class SearchTvEmpty extends SearchTvState{}

class SearchTvLoading extends SearchTvState{}

class SearchTvError extends SearchTvState{
  final String message;

  SearchTvError(this.message);

  @override
  List<Object> get props => [];


}

class SearchTvHasData extends SearchTvState{
  final List<Tv> result;

  SearchTvHasData(this.result);


  @override
  List<Object> get props => [result];
}