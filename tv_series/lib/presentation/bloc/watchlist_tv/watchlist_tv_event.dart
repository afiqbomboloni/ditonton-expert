part of 'watchlist_tv_bloc.dart';

abstract class WatchListTvEvent extends Equatable {}

class OnWatchListTv extends WatchListTvEvent {
  @override
  List<Object?> get props => [];
}

class WatchListTvStatus extends WatchListTvEvent {
  final int id;

  WatchListTvStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class WatchListTvAdd extends WatchListTvEvent {
  final TvDetail tvDetail;

  WatchListTvAdd(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class WatchListTvRemove extends WatchListTvEvent {
  final TvDetail tvDetail;

  WatchListTvRemove(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}