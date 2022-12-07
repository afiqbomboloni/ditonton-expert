import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:about/about.dart';
import 'package:movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movies/presentation/pages/get_now_playing_movie.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/widgets/drawer_page.dart';
import 'package:search/presentation/pages/search_page_movie.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:movies/presentation/bloc/get_now_playing_movie/get_now_playing_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home-movie';
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () {
          context.read<GetNowPlayingMovieBloc>().add(OnGetNowPlayingMovie());
          context.read<PopularMovieBloc>().add(OnPopularMovie());
          context.read<TopRatedMovieBloc>().add(OnTopRatedMovieEvent());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageMovie.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () =>
                    Navigator.pushNamed(context, GetNowPlayingMoviePage.ROUTE_NAME),
              ),
              BlocBuilder<GetNowPlayingMovieBloc, GetNowPlayingMovieState>(
                  builder: (context, state) {
                if (state is GetNowPlayingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetNowPlayingHasData) {
                  return MovieList(state.result);
                } else {
                  return const Text("Gagal Menampilkan");
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMovieBloc, PopularMovieState>(
                  builder: (context, state) {
                if (state is PopularMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularMovieHasData) {
                  return MovieList(state.result);
                } else {
                  return const Text("Gagal Menampilkan");
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
                  builder: (context, state) {
                if (state is TopRatedMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedMovieHasData) {
                  return MovieList(state.result);
                } else {
                  return const Text("Gagal Menampilkan");
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
