import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:movies/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/widgets/scrollable.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-movie';

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(OnMovieDetail(widget.id));
      context.read<MovieRecommendationsBloc>().add(OnMovieRecommendations(widget.id));
      context.read<WatchListMovieBloc>().add(WatchListMovieStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMovieShowAddedToWatchlist = context.select<WatchListMovieBloc, bool>(
        (bloc) => (bloc.state is WatchListMovieIsAdded)
            ? (bloc.state as WatchListMovieIsAdded).isAdded
            : false);
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieDetailHasData) {
              final movie = state.result;
              return ContentDetail(movieDetail: movie, isAddedWatchlist: isMovieShowAddedToWatchlist);
            } else {
              return const Center(
                child: Text("Failed"),
              );
            }
          },
        ),
      ),
    );
  }
}

class ContentDetail extends StatefulWidget {
  final MovieDetail movieDetail;
  bool isAddedWatchlist;

  ContentDetail({required this.movieDetail, required this.isAddedWatchlist});

  @override
  State<ContentDetail> createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  @override
  Widget build(BuildContext context) {
    const String notifAdd = 'Add to watchlist';
    const String notifRemove = 'Remove from watchlist';
    return ScrollableSheet(
      background: "$BASE_IMAGE_URL${widget.movieDetail.posterPath}",
        scrollableContents: [
          Text(
            widget.movieDetail.title,
            style: kHeading5,
    ),
    ElevatedButton(
      onPressed: () async {
        if (!widget.isAddedWatchlist) {
          context.read<WatchListMovieBloc>().add(WatchListMovieAdd(widget.movieDetail));
          } else {
            context.read<WatchListMovieBloc>().add(WatchListMovieRemove(widget.movieDetail));
          }
            final state = BlocProvider.of<WatchListMovieBloc>(context).state;
            String message= '';
            if (state is WatchListMovieIsAdded){
              final isAdded = state.isAdded;
              message = isAdded == false ? notifAdd : notifRemove;
              } else {
                message = !widget.isAddedWatchlist ? notifAdd : notifRemove;
              }
              if(message == notifAdd || message == notifRemove) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(message),
                    );
                    });
              }
              setState(() {
                widget.isAddedWatchlist = !widget.isAddedWatchlist;
              });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                widget.isAddedWatchlist
                ? const Icon(Icons.check): const Icon(Icons.add),
                const Text('Watchlist'),
                ],
                ),
              ),
                Text(
                  _showGenres(widget.movieDetail.genres),
                ),
                Text(
                _showDuration(widget.movieDetail.runtime),
                ),
                Row(
                  children: [
                  RatingBarIndicator(
                  rating: widget.movieDetail.voteAverage / 2,
                  itemCount: 5,
                  itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: kMikadoYellow,
                  ),
                  itemSize: 24,
                ),
                  Text('${widget.movieDetail.voteAverage}')
                ],
              ),
                const SizedBox(height: 16),
                  Text(
                  'Overview',
                  style: kHeading6,
                ),
                  Text(widget.movieDetail.overview.isNotEmpty
                ? widget.movieDetail.overview
                : "-"),
                const SizedBox(height: 16),
                  Text(
                  'Recommendations',
                  style: kHeading6,
                ),
                BlocBuilder<MovieRecommendationsBloc, MovieRecommendationsState>(
                  builder: (context, state) {
                    if (state is MovieRecommendationsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                        );
                        } else if (state is MovieRecommendationsError) {
                          return Text((state as MovieRecommendationsError).message);
                        } else if (state is MovieRecommendationsHasData) {
                          final movieRecommendations = state.result;
                          return Container(
                            margin: const EdgeInsets.only(top:8.0),
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final movie = movieRecommendations[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                 child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      MovieDetailPage.ROUTE_NAME,
                                      arguments: movie.id,
                                  );
                               },
                               child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                               ),
                               child: CachedNetworkImage(
                                  imageUrl:
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  placeholder: (context, url) =>
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                  child: Center(
                                    child:
                                      CircularProgressIndicator(),
                                   ),
                                  ),
                                  errorWidget:
                                  (context, url, error) =>
                                  const Icon(Icons.error),
                               ),
                              ),
                            ),
                           );
                          },
                          itemCount: movieRecommendations.length,
                          ),
                        );
                        } else {
                          return Container(child: Text('Tidak Ada Rekomendasi Film'),);
                        }
                      },
                    ),
                  ]);
  }
  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
