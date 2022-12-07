import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

import '../../dummy_data/dummy_objects_movie.dart';
import '../../helpers/test_helper_movie.mocks.dart';

void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovie;
  late MockGetWatchListStatusMovie mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;
  late WatchListMovieBloc watchListMovieBloc;

  setUp(() {
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    mockGetWatchListStatusMovie = MockGetWatchListStatusMovie();
    mockGetWatchlistMovie = MockGetWatchlistMovies();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    watchListMovieBloc = WatchListMovieBloc(
        mockGetWatchlistMovie,
        mockGetWatchListStatusMovie,
        mockRemoveWatchlistMovie,
        mockSaveWatchlistMovie);
  });

  test('the initial state should be Initial state', () {
    expect(watchListMovieBloc.state, WatchListMovieInitial());
  });

  group('get watchlist Movie shows test cases', () {
    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should emit Loading state and then HasData state when watchlist data successfully retrieved',
      build: () {
        when(mockGetWatchlistMovie.execute()).thenAnswer((_) async => Right(testMovieList));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(OnWatchListMovie()),
      expect: () => [
        WatchListMovieLoading(),
        WatchListMovieHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovie.execute());
        return OnWatchListMovie().props;
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should emit Loading state and then Error state when watchlist data failed to retrieved',
      build: () {
        when(mockGetWatchlistMovie.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(OnWatchListMovie()),
      expect: () => [
        WatchListMovieLoading(),
        WatchListMovieError('Server Failure'),
      ],
      verify: (bloc) => WatchListMovieLoading(),
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should emit Loading state and then Empty state when the retrieved watchlist data is empty',
      build: () {
        when(mockGetWatchlistMovie.execute()).thenAnswer((_) async => const Right([]));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(OnWatchListMovie()),
      expect: () => [
        WatchListMovieLoading(),
        WatchListMovieEmpty(),
      ],
    );
  },
  );


  group('get watchlist status test cases', () {
    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should be true when the watchlist status is also true',
      build: () {
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id)).thenAnswer((_) async => true);
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(WatchListMovieStatus(testMovieDetail.id)),
      expect: () => [
        WatchListMovieIsAdded(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        return WatchListMovieStatus(testMovieDetail.id).props;
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should be false when the watchlist status is also false',
      build: () {
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id)).thenAnswer((_) async => false);
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(WatchListMovieStatus(testMovieDetail.id)),
      expect: () => [
        WatchListMovieIsAdded(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        return WatchListMovieStatus(testMovieDetail.id).props;
      },
    );
  },
  );


  group('add and remove watchlist test cases', () {
    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should update watchlist status when adding watchlist succeeded',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail)).thenAnswer((_) async => const Right(addMessage));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(WatchListMovieAdd(testMovieDetail)),
      expect: () => [
        WatchListMovieMessage(addMessage),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        return WatchListMovieAdd(testMovieDetail).props;
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should update watchlist status when removing watchlist succeeded',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail)).thenAnswer((_) async => const Right(removeMessage));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(WatchListMovieRemove(testMovieDetail)),
      expect: () => [WatchListMovieMessage(removeMessage),],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        return WatchListMovieRemove(testMovieDetail).props;
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should throw failure message status when adding watchlist failed',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(WatchListMovieAdd(testMovieDetail)),
      expect: () => [WatchListMovieError('can\'t add data to watchlist'),],
      verify: (bloc) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        return WatchListMovieAdd(testMovieDetail).props;
      },
    );

    

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'should throw failure message status when removing watchlist failed',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchListMovieBloc;
      },
      act: (bloc) => bloc.add(WatchListMovieRemove(testMovieDetail)),
      expect: () => [
        WatchListMovieError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        return WatchListMovieRemove(testMovieDetail).props;
      },
    );
  },
  );

}