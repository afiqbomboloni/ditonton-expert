import 'package:core/core.dart';
import 'package:tv_series/presentation/bloc/get_now_playing_tv/get_now_playing_tv_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class GetNowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/get-now-playing-tv';

  @override
  _GetNowPlayingTvPageState createState() => _GetNowPlayingTvPageState();
}

class _GetNowPlayingTvPageState extends State<GetNowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<GetNowPlayingTvBloc>().add(OnGetNowPlayingTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On Air'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetNowPlayingTvBloc, GetNowPlayingTvState>(
          builder: (context, state) {
            if (state is GetNowPlayingTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetNowPlayingTvHasData) {
              final data  = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvNowPlaying = data[index];
                  return TvCard(tvNowPlaying);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as GetNowPlayingTvError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
