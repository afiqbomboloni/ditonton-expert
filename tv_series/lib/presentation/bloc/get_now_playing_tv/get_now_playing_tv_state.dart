part of 'get_now_playing_tv_bloc.dart';

abstract class GetNowPlayingTvState extends Equatable {}

class GetNowPlayingTvEmpty extends GetNowPlayingTvState {
  @override
  List<Object?> get props => [];
}

class GetNowPlayingTvLoading extends GetNowPlayingTvState {
  @override
  List<Object?> get props => [];
}

class GetNowPlayingTvError extends GetNowPlayingTvState {
  final String message;

  GetNowPlayingTvError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetNowPlayingTvHasData extends GetNowPlayingTvState {
  final List<Tv> result;

  GetNowPlayingTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}