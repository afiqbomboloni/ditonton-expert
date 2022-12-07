import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:mockito/annotations.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_series/domain/usecases/get_popular_tv.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  GetTvDetail,
  GetPopularTv,
  GetNowPlayingTv,
  GetTopRatedTv,
  GetTvRecommendations,
  GetWatchlistTv,
  GetWatchListStatus,
  RemoveWatchlist,
  SaveWatchlist,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
