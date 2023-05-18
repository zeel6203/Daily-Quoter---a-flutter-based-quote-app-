import 'package:api_to_sql/presentation/screen/savedlist.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/datamodel.dart';
import '../sqlite/databasehelper.dart';

part 'savedquotecubit_state.dart';

class SavedquotecubitCubit extends Cubit<SavedquoteState> {
  SavedquotecubitCubit() : super(SavedquotecubitInitial()){
    fetchfromdb();
  }
  
  Future<void> fetchfromdb({String? texttofind="",DateTime? start,DateTime? end,String? author,String? tag}) async {
    try {
      // texttofind="";
      authorlist=["all"];
      tagslist=["all"];


      print("run 1");
      final dbhelper = DatabaseHelper.instance;
      print("run 2");

      List<datamodel> results = await dbhelper.fetchSavedQuotes(texttofind:texttofind,end: end,start:start,author:author,tag:tag);
      List<datamodel> allresults = await dbhelper.fetchSavedQuotes();
      if (allresults != null) {
        for (var item in allresults) {
          if(authorlist.contains(item.author)){}
          else{
            authorlist.add(item.author);
          }
          for(var item1 in item.tags){
            if(tagslist.contains(item1)){}
            else{
              tagslist.add(item1);
            }
          }
        }

      }
      print("$tagslist 🟩🟩🟩🟩");
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

  update(datamodel quote) async{
    try{
      final dbhelper = DatabaseHelper.instance;
      await dbhelper.update(quote);
      fetchfromdb();
  }catch(ex){

  }
}

  // update()
}
