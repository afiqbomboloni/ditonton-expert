import 'package:core/utils/constants.dart';
import 'package:core/core.dart';
import 'package:core/utils/utils.dart';
import 'package:about/about.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:core/presentation/widgets/tab_pager.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_page.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_page.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/get_now_playing_tv/get_now_playing_tv_bloc.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:search/presentation/pages/search_page_movie.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:tv_series/presentation/pages/get_now_playing_tv.dart';
import 'package:movies/presentation/pages/get_now_playing_movie.dart';
import 'package:movies/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movies/presentation/bloc/get_now_playing_movie/get_now_playing_movie_bloc.dart';
import 'package:movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
        create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<GetNowPlayingTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchListTvBloc>(),
        ),
        // Movie
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<GetNowPlayingMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchListMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeTvPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvPage());
            case PopularTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());
            case TopRatedTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case GetNowPlayingTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => GetNowPlayingTvPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchPageMovie.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageMovie());
            case WatchlistTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            // movie
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case GetNowPlayingMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => GetNowPlayingMoviePage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case TabPager.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TabPager());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
