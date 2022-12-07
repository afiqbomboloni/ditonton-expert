import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import '../../dummy_data/dummy_objects_movie.dart';
import '../../helpers/test_helper_movie.mocks.dart';

void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsBloc movieRecommendationsBloc;

  const testId = 2;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  test('the initial state should be empty', () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit Loading state and then HasData state when data successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnMovieRecommendations(testId)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsHasData(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(testId));
      return OnMovieRecommendations(testId).props;
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnMovieRecommendations(testId)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsError('Server Failure'),
    ],
    verify: (bloc) => MovieRecommendationsLoading(),
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit Loading state and then Empty state when the get data is empty',
    build: () {
      when(mockGetMovieRecommendations.execute(testId)).thenAnswer((_) async => const Right([]));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnMovieRecommendations(testId)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsEmpty(),
    ],
  );
}