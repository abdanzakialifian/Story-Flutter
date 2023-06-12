import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/data/source/remote/api_service.dart';
import 'package:story_app/data/source/remote/response/login_response.dart';
import 'package:story_app/data/source/remote/response/base_response.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';

class RemoteDataSource {
  ApiService apiService = ApiService();

  Future<BaseResponse> postRegister(
      String name, String email, String password) async {
    try {
      http.Response response =
          await apiService.postRegister(name, email, password);
      return baseResponseFromJson(response.body);
    } catch (e) {
      return throw Exception("Exception to load data");
    }
  }

  Future<LoginResponse> postLogin(String email, String password) async {
    try {
      http.Response response = await apiService.postLogin(email, password);
      return loginResponseFromJson(response.body);
    } catch (e) {
      return throw Exception("Exception to load data");
    }
  }

  Future<StoriesResponse> getAllStories(int page, int size) async {
    try {
      http.Response response = await apiService.getAllStories(page, size);
      return storiesResponseFromJson(response.body);
    } catch (e) {
      return throw Exception("Exception to load data");
    }
  }

  Future<BaseResponse> postStory(File imageFile, String description) async {
    try {
      http.StreamedResponse streamedResponse =
          await apiService.postStory(imageFile, description);
      http.Response response = await http.Response.fromStream(streamedResponse);
      return baseResponseFromJson(response.body);
    } catch (e) {
      return throw ("Exception to load data");
    }
  }
}
