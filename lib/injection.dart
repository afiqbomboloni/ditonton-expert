import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_series/domain/usecases/get_popular_tv.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/data/datasources/db/database_helper_movie.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:tv_series/presentation/bloc/get_now_playing_tv/get_now_playing_tv_bloc.dart';
import 'package:movies/presentation/bloc/get_now_playing_movie/get_now_playing_movie_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movies/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:core/utils/ssl_pinning.dart';

import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  ///tv bloc
  locator.registerFactory(() => GetNowPlayingTvBloc(locator()));
  locator.registerFactory(() => PopularTvBloc(locator()));
  locator.registerFactory(() => TvDetailBloc(locator(),));
  locator.registerFactory(() => TopRatedTvBloc(locator(),));
  locator.registerFactory(() => TvRecommendationsBloc(locator(),));

  locator.registerFactory(() => WatchListTvBloc(
      locator(),
      locator(),
      locator(),
      locator(),
  ));

 ///movie bloc
  locator.registerFactory(() => GetNowPlayingMovieBloc(locator()));
  locator.registerFactory(() => PopularMovieBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(locator(),));
  locator.registerFactory(() => TopRatedMovieBloc(locator(),));
  locator.registerFactory(() => MovieRecommendationsBloc(locator(),));
  

  // Watch list Movie
    locator.registerFactory(() => WatchListMovieBloc(
      locator(),
      locator(),
      locator(),
      locator(),
  ));
  locator.registerFactory(
    () => SearchTvBloc(
      locator(),
    ),
  );

   // bloc
  locator.registerFactory(
    () => SearchBloc(
      locator(),
    ),
  );


  // use case
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  // use-case-movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // repository-movie
    locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // data-source-movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelperMovie: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<DatabaseHelperMovie>(() => DatabaseHelperMovie());

  // external

  locator.registerLazySingleton(() => HttpSSLPinning.client);
}

