import 'package:core/core.dart';
import 'package:tv_series/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularTvBloc>().add(OnPopularTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context,state) {
            if (state is PopularTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvPopular = data[index];
                  return TvCard(tvPopular);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as PopularTvError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
