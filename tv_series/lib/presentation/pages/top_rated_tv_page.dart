import 'package:core/core.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TopRatedTvBloc>().add(OnTopRatedTvEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvTopRated = data[index];
                  return TvCard(tvTopRated);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as TopRatedTvError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
