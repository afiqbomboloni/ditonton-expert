import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/get_now_playing_movie/get_now_playing_movie_bloc.dart';
import '../../dummy_data/dummy_objects_movie.dart';

import '../../helpers/test_helper_movie.mocks.dart';
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovie;
  late GetNowPlayingMovieBloc getNowPlayingMovieBloc;

  setUp(() {
    mockGetNowPlayingMovie = MockGetNowPlayingMovies();
    getNowPlayingMovieBloc = GetNowPlayingMovieBloc(mockGetNowPlayingMovie);
  });

  test('the initial state should be empty', () {
    expect(getNowPlayingMovieBloc.state, GetNowPlayingEmpty());
  });

  blocTest<GetNowPlayingMovieBloc, GetNowPlayingMovieState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return getNowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(OnGetNowPlayingMovie()),
    expect: () => [
      GetNowPlayingLoading(),
      GetNowPlayingHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovie.execute());
      return OnGetNowPlayingMovie().props;
    },
  );

  blocTest<GetNowPlayingMovieBloc, GetNowPlayingMovieState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getNowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(OnGetNowPlayingMovie()),
    expect: () => [
      GetNowPlayingLoading(),
      GetNowPlayingError('Server Failure'),
    ],
    verify: (bloc) => GetNowPlayingLoading(),
  );

  blocTest<GetNowPlayingMovieBloc, GetNowPlayingMovieState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => const Right([]));
      return getNowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(OnGetNowPlayingMovie()),
    expect: () => [
      GetNowPlayingLoading(),
      GetNowPlayingEmpty(),
    ],
  );
}