part of 'watchlist_tv_bloc.dart';

abstract class WatchListTvState extends Equatable {}

class WatchListTvInitial extends WatchListTvState {
  @override
  List<Object?> get props => [];
}

class WatchListTvEmpty extends WatchListTvState {
  @override
  List<Object?> get props => [];
}

class WatchListTvLoading extends WatchListTvState {
  @override
  List<Object?> get props => [];
}

class WatchListTvError extends WatchListTvState {
  final String message;

  WatchListTvError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchListTvHasData extends WatchListTvState {
  final List<Tv> result;

  WatchListTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class WatchListTvIsAdded extends WatchListTvState {
  final bool isAdded;

  WatchListTvIsAdded(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class WatchListTvMessage extends WatchListTvState {
  final String message;

  WatchListTvMessage(this.message);

  @override
  List<Object?> get props => [message];
}