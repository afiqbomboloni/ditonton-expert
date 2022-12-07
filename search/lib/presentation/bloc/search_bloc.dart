

import 'package:search/domain/usecases/search_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/movie.dart';


EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchEmpty()) {
  on<OnQueryChangedMovie>((event, emit) async {
    final query = event.query;
 
    emit(SearchLoading());
    final result = await _searchMovies.execute(query);
 
    result.fold(
      (failure) {
        emit(SearchError(failure.message));
      },
      (data) {
        emit(SearchHasData(data));
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

class OnQueryChangedMovie extends SearchEvent {
  final String query;
  OnQueryChangedMovie(this.query);

  @override
  List<Object> get props => [query];
}


abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState{}

class SearchLoading extends SearchState{}

class SearchError extends SearchState{
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [];


}

class SearchHasData extends SearchState{
  final List<Movie> result;

  SearchHasData(this.result);


  @override
  List<Object> get props => [result];
}