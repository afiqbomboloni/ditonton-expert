import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv_series/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv_series/presentation/pages/get_now_playing_tv.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_page.dart';
import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:core/presentation/widgets/drawer_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_page.dart';
// import 'package:tv_series/presentation/pages/watchlist_tv_page.dart';
import 'package:tv_series/presentation/bloc/get_now_playing_tv/get_now_playing_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv';
  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () {
          context.read<GetNowPlayingTvBloc>().add(OnGetNowPlayingTv());
          context.read<PopularTvBloc>().add(OnPopularTv());
          context.read<TopRatedTvBloc>().add(OnTopRatedTvEvent());
        }
        
        
        );
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
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
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
                title: 'On Air',
                onTap: () =>
                    Navigator.pushNamed(context, GetNowPlayingTvPage.ROUTE_NAME),
              ),
              BlocBuilder<GetNowPlayingTvBloc, GetNowPlayingTvState>(
                  builder: (context, state) {
                if (state is GetNowPlayingTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetNowPlayingTvHasData) {
                  return TvList(state.result);
                } else {
                  return const Text("Gagal Menampilkan");
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvBloc, PopularTvState>(
                  builder: (context, state) {
                if (state is PopularTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvHasData) {
                  return TvList(state.result);
                } else {
                  return const Text("Gagal Menampilkan");
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                  builder: (context, state) {
                if (state is TopRatedTvLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvHasData) {
                  return TvList(state.result);
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

class TvList extends StatelessWidget {
  final List<Tv> tvSeries;

  TvList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
