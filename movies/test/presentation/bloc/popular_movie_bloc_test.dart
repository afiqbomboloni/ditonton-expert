import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import '../../dummy_data/dummy_objects_movie.dart';
import '../../helpers/test_helper_movie.mocks.dart';


void main() {
  late MockGetPopularMovies mockGetPopularMovie;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovie = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovie);
  });

  test('the initial state should be empty', () {
    expect(popularMovieBloc.state, PopularMovieEmpty());
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit Loading state and then HasData state when data successfully',
    build: () {
      when(mockGetPopularMovie.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(OnPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovie.execute());
      return OnPopularMovie().props;
    },
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetPopularMovie.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(OnPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieError('Server Failure'),
    ],
    verify: (bloc) => PopularMovieLoading(),
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit Loading state and then Empty state when the get data is empty',
    build: () {
      when(mockGetPopularMovie.execute()).thenAnswer((_) async => const Right([]));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(OnPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieEmpty(),
    ],
  );
}