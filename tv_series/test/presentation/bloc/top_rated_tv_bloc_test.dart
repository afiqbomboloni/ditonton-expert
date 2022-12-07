import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper_tv.mocks.dart';

void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvBloc topRatedTvBloc;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  test('the initial state should be empty', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTvEvent()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
      return OnTopRatedTvEvent().props;
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTvEvent()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (bloc) => TopRatedTvLoading(),
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Right([]));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(OnTopRatedTvEvent()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvEmpty(),
    ],
  );
}