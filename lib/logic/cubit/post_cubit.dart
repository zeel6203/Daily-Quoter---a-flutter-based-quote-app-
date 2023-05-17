import 'package:api_to_sql/data/models/datamodel.dart';
import 'package:api_to_sql/data/repositary/post_repositary.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial()) {

    fetchdata();
  }

  Future<void> fetchdata() async {
    // await Future.delayed(Duration(seconds:2));
    emit(PostLoading());

    try {
      datamodel quote = await PostRepository().fetchdata();
      emit(PostLoaded(quote));
    }
    catch(ex) {
      emit(PostError(ex.toString()));
    }
  }


}
