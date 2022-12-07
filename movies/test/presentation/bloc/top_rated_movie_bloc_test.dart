import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import '../../dummy_data/dummy_objects_movie.dart';
import '../../helpers/test_helper_movie.mocks.dart';

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovie;
  late TopRatedMovieBloc topRatedMovieBloc;

  setUp(() {
    mockGetTopRatedMovie = MockGetTopRatedMovies();
    topRatedMovieBloc = TopRatedMovieBloc(mockGetTopRatedMovie);
  });

  test('the initial state should be empty', () {
    expect(topRatedMovieBloc.state, TopRatedMovieEmpty());
  });

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(mockGetTopRatedMovie.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedMovieEvent()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovie.execute());
      return OnTopRatedMovieEvent().props;
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(mockGetTopRatedMovie.execute())
          .thenAnswer((_) async => const Right([]));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedMovieEvent()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieEmpty(),
    ],
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetTopRatedMovie.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedMovieEvent()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieError('Server Failure'),
    ],
    verify: (bloc) => TopRatedMovieLoading(),
  );

  
}