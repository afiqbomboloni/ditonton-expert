import 'package:core/core.dart';
import 'package:movies/presentation/bloc/get_now_playing_movie/get_now_playing_movie_bloc.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNowPlayingMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/get-now-playing-movie';

  @override
  _GetNowPlayingMoviePageState createState() => _GetNowPlayingMoviePageState();
}

class _GetNowPlayingMoviePageState extends State<GetNowPlayingMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<GetNowPlayingMovieBloc>().add(OnGetNowPlayingMovie()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
        BlocBuilder<GetNowPlayingMovieBloc, GetNowPlayingMovieState>(
          builder: (context, state) {
            if (state is GetNowPlayingLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetNowPlayingHasData) {
              final data  = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as GetNowPlayingError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
