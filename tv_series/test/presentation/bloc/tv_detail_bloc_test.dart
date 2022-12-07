import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper_tv.mocks.dart';
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc tvDetailBloc;

  const testId = 1;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(mockGetTvDetail);
  });

  test('the initial state should be empty', () {
    expect(tvDetailBloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetTvDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(OnTvDetail(testId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailError('Server Failure'),
    ],
    verify: (bloc) => TvDetailLoading(),
  );


    blocTest<TvDetailBloc, TvDetailState>(
    'should emit Loading state and then HasData state when data successfully',
    build: () {
      when(mockGetTvDetail.execute(testId))
          .thenAnswer((_) async => Right(testTvDetail));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(OnTvDetail(testId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(testTvDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(testId));
      return OnTvDetail(testId).props;
    },
  );
}

