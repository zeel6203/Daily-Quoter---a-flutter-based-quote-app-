

import 'package:api_to_sql/data/models/datamodel.dart';
import 'package:api_to_sql/data/repositary/apis/api.dart';
import 'package:dio/dio.dart';

class PostRepository{
  API api = API();

  Future<datamodel> fetchdata() async {
    try {
      Response response = await api.sendrequest.get("/random");
      var json = response.data;
      return datamodel.fromJson(json);

    } catch (ex) {
      throw ex;
      // TODO
    }

  }
}