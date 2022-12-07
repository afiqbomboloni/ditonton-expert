export 'package:core/core.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchListTvBloc>().add(OnWatchListTv()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchListTvBloc>().add(OnWatchListTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchListTvBloc, WatchListTvState>(
          builder: (context,state) {
            if (state is WatchListTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchListTvHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data[index];
                  return TvCard(tv);
                },
                itemCount: data.length,
              );
            } else if (state is WatchListTvEmpty) {
              return const Center(
                child: Text("Watchlist kamu masih kosong nich"),
              );
            }else {
              return Center(
                key: Key('error_message'),
                child: Text('Error Internernya kak'),
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
