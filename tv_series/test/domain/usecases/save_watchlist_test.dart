import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper_tv.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlist(mockTvRepository);
  });

  test('should save Tv to the repository', () async {
    // arrange
    when(mockTvRepository.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockTvRepository.saveWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
