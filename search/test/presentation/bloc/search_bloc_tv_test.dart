import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import '../../dummy_data/dummy_objects_tv.dart';

import 'package:dartz/dartz.dart';

import 'search_bloc_tv_test.mocks.dart';
@GenerateMocks([SearchTv])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;
 
  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  test('initial state should be empty', () {
  expect(searchTvBloc.state, SearchTvEmpty());
});

final tQuery = 'money heist';
 
blocTest<SearchTvBloc, SearchTvState>(
  'Should emit [Loading, HasData] when data is gotten successfully',
  build: () {
    when(mockSearchTv.execute(tQuery))
        .thenAnswer((_) async => Right(testTvList));
    return searchTvBloc;
  },
  act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    SearchTvLoading(),
    SearchTvHasData(testTvList),
  ],
  verify: (bloc) {
    verify(mockSearchTv.execute(tQuery));
  },
);

blocTest<SearchTvBloc, SearchTvState>(
  'Should emit [Loading, Error] when get search is unsuccessful',
  build: () {
    when(mockSearchTv.execute(tQuery))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    return searchTvBloc;
  },
  act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    SearchTvLoading(),
    SearchTvError('Server Failure'),
  ],
  verify: (bloc) {
    verify(mockSearchTv.execute(tQuery));
  },
);
}