import 'package:core/core.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchListMovieBloc>().add(OnWatchListMovie()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchListMovieBloc>().add(OnWatchListMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
        BlocBuilder<WatchListMovieBloc, WatchListMovieState>(
          builder: (context,state) {
            if (state is WatchListMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchListMovieHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data[index];
                  return MovieCard(movie);
                },
                itemCount: data.length,
              );
            } else if (state is WatchListMovieEmpty) {
              return const Center(
                child: Text("Watchlist kamu masih kosong nich"),
              );
            }else {
              return Center(
                key: Key('error_message'),
                child: Text('Error Kakak'),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
