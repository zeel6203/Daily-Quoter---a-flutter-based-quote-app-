part of 'savedquotecubit_cubit.dart';

@immutable
abstract class SavedquoteState {}

class SavedquotecubitInitial extends SavedquoteState {}

class SavedLoading extends SavedquoteState {}

class SavedLoaded extends SavedquoteState {
  List<datamodel>? saveddata;
  SavedLoaded(this.saveddata);
}
class Empty extends SavedquoteState {}
class Error extends SavedquoteState {}

