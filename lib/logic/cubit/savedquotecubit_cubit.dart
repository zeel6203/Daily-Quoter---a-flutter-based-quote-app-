import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/datamodel.dart';
import '../sqlite/databasehelper.dart';

part 'savedquotecubit_state.dart';

class SavedquotecubitCubit extends Cubit<SavedquoteState> {
  SavedquotecubitCubit() : super(SavedquotecubitInitial()){
    fetchfromdb();
  }
  
  Future<void> fetchfromdb({String? texttofind=""}) async {
    try {
      // texttofind="";

      print("run 1");
      final dbhelper = DatabaseHelper.instance;
      print("run 2");
      List<datamodel> results = await dbhelper.fetchSavedQuotes(texttofind:texttofind);
      print("run 3");
      if(results.length!=0) {
        emit(SavedLoaded(results));
      }
      else{
        emit(Empty());
      }
    }catch(ex){
      emit(Error());
    }
  }

  del(String id) async{
    try{
      final dbhelper = DatabaseHelper.instance;
      await dbhelper.delete(id);
      fetchfromdb();

    }catch(ex){
      emit(Error());

    }

  }

  // update()
}
