import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper_tv.mocks.dart';

void main() {
  late MockGetTvRecommendations mockGetTvRecommendations;
  late TvRecommendationsBloc tvRecommendationsBloc;

  const testId = 2;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvRecommendationsBloc = TvRecommendationsBloc(mockGetTvRecommendations);
  });

  test('the initial state should be empty', () {
    expect(tvRecommendationsBloc.state, TvRecommendationsEmpty());
  });

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'should emit Loading state and then HasData state when data successfully',
    build: () {
      when(mockGetTvRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testTvList));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnTvRecommendations(testId)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendations.execute(testId));
      return OnTvRecommendations(testId).props;
    },
  );

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetTvRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnTvRecommendations(testId)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsError('Server Failure'),
    ],
    verify: (bloc) => TvRecommendationsLoading(),
  );

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'should emit Loading state and then Empty state when the get data is empty',
    build: () {
      when(mockGetTvRecommendations.execute(testId)).thenAnswer((_) async => const Right([]));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(OnTvRecommendations(testId)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsEmpty(),
    ],
  );
}