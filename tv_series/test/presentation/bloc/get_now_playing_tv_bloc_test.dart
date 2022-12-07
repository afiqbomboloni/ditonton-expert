import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/get_now_playing_movie/get_now_playing_movie_bloc.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_series/presentation/bloc/get_now_playing_tv/get_now_playing_tv_bloc.dart';
import '../../dummy_data/dummy_objects_tv.dart';

import '../../helpers/test_helper_tv.mocks.dart';
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late GetNowPlayingTvBloc getNowPlayingTvBloc;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    getNowPlayingTvBloc = GetNowPlayingTvBloc(mockGetNowPlayingTv);
  });

  test('the initial state should be empty', () {
    expect(getNowPlayingTvBloc.state, GetNowPlayingTvEmpty());
  });

  blocTest<GetNowPlayingTvBloc, GetNowPlayingTvState>(
    'should emit Loading state and then HasData state when data successfully fetched',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return getNowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(OnGetNowPlayingTv()),
    expect: () => [
      GetNowPlayingTvLoading(),
      GetNowPlayingTvHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTv.execute());
      return OnGetNowPlayingTv().props;
    },
  );

  blocTest<GetNowPlayingTvBloc, GetNowPlayingTvState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getNowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(OnGetNowPlayingTv()),
    expect: () => [
      GetNowPlayingTvLoading(),
      GetNowPlayingTvError('Server Failure'),
    ],
    verify: (bloc) => GetNowPlayingTvLoading(),
  );

  blocTest<GetNowPlayingTvBloc, GetNowPlayingTvState>(
    'should emit Loading state and then Empty state when the retrieved data is empty',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => const Right([]));
      return getNowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(OnGetNowPlayingTv()),
    expect: () => [
      GetNowPlayingTvLoading(),
      GetNowPlayingTvEmpty(),
    ],
  );
}