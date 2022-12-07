import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper_tv.mocks.dart';

void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchListTvBloc watchListTvBloc;

  setUp(() {
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockSaveWatchlist = MockSaveWatchlist();
    watchListTvBloc = WatchListTvBloc(
        mockGetWatchlistTv,
        mockGetWatchListStatus,
        mockRemoveWatchlist,
        mockSaveWatchlist);
  });

  test('the initial state should be Initial state', () {
    expect(watchListTvBloc.state, WatchListTvInitial());
  });

  group('get watchlist tv shows test cases', () {
    blocTest<WatchListTvBloc, WatchListTvState>(
      'should emit Loading state and then HasData state when watchlist data successfully retrieved',
      build: () {
        when(mockGetWatchlistTv.execute()).thenAnswer((_) async => Right(testTvList));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(OnWatchListTv()),
      expect: () => [
        WatchListTvLoading(),
        WatchListTvHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
        return OnWatchListTv().props;
      },
    );

    blocTest<WatchListTvBloc, WatchListTvState>(
      'should emit Loading state and then Error state when watchlist data failed to retrieved',
      build: () {
        when(mockGetWatchlistTv.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(OnWatchListTv()),
      expect: () => [
        WatchListTvLoading(),
        WatchListTvError('Server Failure'),
      ],
      verify: (bloc) => WatchListTvLoading(),
    );

    blocTest<WatchListTvBloc, WatchListTvState>(
      'should emit Loading state and then Empty state when the retrieved watchlist data is empty',
      build: () {
        when(mockGetWatchlistTv.execute()).thenAnswer((_) async => const Right([]));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(OnWatchListTv()),
      expect: () => [
        WatchListTvLoading(),
        WatchListTvEmpty(),
      ],
    );
  },
  );


  group('get watchlist status test cases', () {
    blocTest<WatchListTvBloc, WatchListTvState>(
      'should be true when the watchlist status is also true',
      build: () {
        when(mockGetWatchListStatus.execute(testTvDetail.id)).thenAnswer((_) async => true);
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(WatchListTvStatus(testTvDetail.id)),
      expect: () => [
        WatchListTvIsAdded(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        return WatchListTvStatus(testTvDetail.id).props;
      },
    );

    blocTest<WatchListTvBloc, WatchListTvState>(
      'should be false when the watchlist status is also false',
      build: () {
        when(mockGetWatchListStatus.execute(testTvDetail.id)).thenAnswer((_) async => false);
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(WatchListTvStatus(testTvDetail.id)),
      expect: () => [
        WatchListTvIsAdded(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        return WatchListTvStatus(testTvDetail.id).props;
      },
    );
  },
  );


  group('add and remove watchlist test cases', () {
    blocTest<WatchListTvBloc, WatchListTvState>(
      'should update watchlist status when adding watchlist succeeded',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => const Right(addMessage));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(WatchListTvAdd(testTvDetail)),
      expect: () => [
        WatchListTvMessage(addMessage),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvDetail));
        return WatchListTvAdd(testTvDetail).props;
      },
    );

    blocTest<WatchListTvBloc, WatchListTvState>(
      'should throw failure message status when adding watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(WatchListTvAdd(testTvDetail)),
      expect: () => [WatchListTvError('can\'t add data to watchlist'),],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvDetail));
        return WatchListTvAdd(testTvDetail).props;
      },
    );

    blocTest<WatchListTvBloc, WatchListTvState>(
      'should update watchlist status when removing watchlist succeeded',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer((_) async => const Right(removeMessage));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(WatchListTvRemove(testTvDetail)),
      expect: () => [WatchListTvMessage(removeMessage),],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
        return WatchListTvRemove(testTvDetail).props;
      },
    );

    blocTest<WatchListTvBloc, WatchListTvState>(
      'should throw failure message status when removing watchlist failed',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchListTvBloc;
      },
      act: (bloc) => bloc.add(WatchListTvRemove(testTvDetail)),
      expect: () => [
        WatchListTvError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
        return WatchListTvRemove(testTvDetail).props;
      },
    );
  },
  );

}