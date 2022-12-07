import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecases/get_popular_tv.dart';
import 'package:tv_series/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper_tv.mocks.dart';


void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvBloc popularTvBloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  test('the initial state should be empty', () {
    expect(popularTvBloc.state, PopularTvEmpty());
  });

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit Loading state and then HasData state when data successfully',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(OnPopularTv()),
    expect: () => [
      PopularTvLoading(),
      PopularTvHasData(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
      return OnPopularTv().props;
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit Loading state and then Error state when data failed to fetch',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(OnPopularTv()),
    expect: () => [
      PopularTvLoading(),
      PopularTvError('Server Failure'),
    ],
    verify: (bloc) => PopularTvLoading(),
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit Loading state and then Empty state when the get data is empty',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer((_) async => const Right([]));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(OnPopularTv()),
    expect: () => [
      PopularTvLoading(),
      PopularTvEmpty(),
    ],
  );
}