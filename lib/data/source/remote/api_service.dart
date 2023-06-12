import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/source/local/user_data.dart';
import 'package:story_app/data/source/remote/logger_interceptor.dart';
import 'package:story_app/utils/constants.dart';

class ApiService {
  final interceptedClient = InterceptedClient.build(
    interceptors: [
      LoggerInterceptor(),
    ],
  );
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String userDataJson = prefs.getString(Constants.userData) ?? "";
    UserData userData = UserData.fromJson(json.decode(userDataJson));
    return userData.userToken ?? "";
  }

  Future<http.Response> postRegister(
      String name, String email, String password) async {
    Uri url = Uri.parse("$_baseUrl/register");
    return await interceptedClient.post(
      url,
      body: <String, String>{
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }

  Future<http.Response> postLogin(String email, String password) async {
    Uri url = Uri.parse("$_baseUrl/login");
    return await interceptedClient.post(
      url,
      body: <String, String>{
        "email": email,
        "password": password,
      },
    );
  }

  Future<http.Response> getAllStories(int page, int size) async {
    String? token;

    try {
      token = await getToken();
    } catch (e) {
      log("Failed get token from preference : $e");
    }

    Uri url = Uri.parse("$_baseUrl/stories");

    return await interceptedClient.get(
      url,
      headers: <String, String>{"Authorization": "Bearer $token"},
      params: <String, int>{
        "page": page,
        "size": size,
      },
    );
  }

  Future<http.StreamedResponse> postStory(
      File imageFile, String description) async {
    String? token;

    try {
      token = await getToken();
    } catch (e) {
      log("Failed get token from preference : $e");
    }

    final request =
        http.MultipartRequest("POST", Uri.parse("$_baseUrl/stories"));

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
      "photo",
      imageFile.path, // adjust to the type of image file uploaded
    );

    // add header authorization
    request.headers["Authorization"] = "Bearer $token";

    // add file image
    request.files.add(multipartFile);

    // add description
    request.fields["description"] = description;

    // send request to server
    return await request.send();
  }
}
