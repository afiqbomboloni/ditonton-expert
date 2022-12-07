import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/core.dart';
import 'package:core/presentation/widgets/scrollable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  const TvDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(OnTvDetail(widget.id));
      context.read<TvRecommendationsBloc>().add(OnTvRecommendations(widget.id));
      context.read<WatchListTvBloc>().add(WatchListTvStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTvShowAddedToWatchlist = context.select<WatchListTvBloc, bool>(
        (bloc) => (bloc.state is WatchListTvIsAdded)
            ? (bloc.state as WatchListTvIsAdded).isAdded
            : false);
    
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            if (state is TvDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvDetailHasData) {
              final tv = state.result;
              return ContentDetail(tvDetail: tv, isAddedWatchlist: isTvShowAddedToWatchlist);
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
  final TvDetail tvDetail;
  bool isAddedWatchlist;

  ContentDetail({required this.tvDetail, required this.isAddedWatchlist});

  @override
  State<ContentDetail> createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  @override
  Widget build(BuildContext context) {
    const String addMessage = 'Add to watchlist';
    const String removeMessage = 'Remove from watchlist';
    return ScrollableSheet(
      background: "$BASE_IMAGE_URL${widget.tvDetail.posterPath}",
        scrollableContents: [
          Text(
            widget.tvDetail.name,
            style: kHeading5,
    ),
    ElevatedButton(
      onPressed: () async{
        if (!widget.isAddedWatchlist) {
           context
                    .read<WatchListTvBloc>()
                    .add(WatchListTvAdd(widget.tvDetail));
          } else {
            context
                    .read<WatchListTvBloc>()
                    .add(WatchListTvRemove(widget.tvDetail));
          }
            final state = BlocProvider.of<WatchListTvBloc>(context).state;
            String message= '';

            if (state is WatchListTvIsAdded){
              final isAdded = state.isAdded;
              message = isAdded == false ? addMessage : removeMessage;
              } else {
                message = !widget.isAddedWatchlist ? addMessage : removeMessage;
              }


              if(message == addMessage || message == removeMessage) {
                ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
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
                ?  Icon(Icons.check)
                :  Icon(Icons.add),
                 SizedBox(width: 5.0,),
                 Text('Watchlist'),
                 SizedBox(width: 3.0,),
                ],
                ),
              ),
                Text(
                  _showGenres(widget.tvDetail.genres),
                ),
                Text(
                _showEpisodes(widget.tvDetail.numberOfEpisodes),
                ),
                Row(
                  children: [
                  RatingBarIndicator(
                  rating: widget.tvDetail.voteAverage / 2,
                  itemCount: 5,
                  itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: kMikadoYellow,
                  ),
                  itemSize: 24,
                ),
                  Text('${widget.tvDetail.voteAverage}')
                ],
              ),
                const SizedBox(height: 16),
                  Text(
                  'Overview',
                  style: kHeading6,
                ),
                  Text(widget.tvDetail.overview.isNotEmpty
                ? widget.tvDetail.overview
                : "-"),
                const SizedBox(height: 16),
                  Text(
                  'Recommendations',
                  style: kHeading6,
                ),
                BlocBuilder<TvRecommendationsBloc, TvRecommendationsState>(
                  builder: (context, state) {
                    if (state is TvRecommendationsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                        );
                        } else if (state is TvRecommendationsError) {
                          return Text((state as TvRecommendationsError).message);
                        } else if (state is TvRecommendationsHasData) {
                          final tvRecommendations = state.result;
                          return Container(
                            margin: const EdgeInsets.only(top:8.0),
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final tv = tvRecommendations[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                 child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      TvDetailPage.ROUTE_NAME,
                                      arguments: tv.id,
                                  );
                               },
                               child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                               ),
                               child: CachedNetworkImage(
                                  imageUrl:
                                  'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
                          itemCount: tvRecommendations.length,
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

  String _showEpisodes(int episodes) {
    final int hours = episodes ~/ 60;
    final int minutes = episodes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

