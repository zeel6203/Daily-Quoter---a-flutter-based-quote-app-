part of 'post_cubit.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  datamodel? quote;
  PostLoaded(this.quote);
}

class PostError extends PostState {}