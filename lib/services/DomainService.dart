import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmobile/services/model/ServerTask.dart';

class DomainService {
  final String base = ':8081/api/v1/';
  final String urlBase = "http://192.168.100.185:8081/api/v1/";
  final dio = Dio();

  Future<String> getDynamicIp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString("serverIP");
    if (ip != null) {
      String uri = "http://$ip$base";
      return uri;
    } else {
      String uri = urlBase;
      return uri;
    }
  }

  Future<Response?> insertServerTask(TaskServer data, String token) async {
    final String url = await getDynamicIp();
    String uri = "${url}tasks";

    try {
      final response = await dio.post(uri,
          data: data.toJson(),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }));
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 201) {
        return Response(
          data: e.response?.data,
          headers: e.response?.headers,
          requestOptions: e.requestOptions,
          statusCode: 201,
        );
      }
      print(e);
    }
    return null;
  }

  Future<Response?> updateServerTask(TaskServer data, String token) async {
    final String url = await getDynamicIp();
    String uri = "${url}tasks/${data.id}";
    print(data.id);
    try {
      final response = await dio.put(uri,
          data: data.toJson(),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }));
      print(response.data);
      print(response.statusCode);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Response(
          data: [],
          headers: e.response?.headers,
          requestOptions: e.requestOptions,
          statusCode: 404,
        );
      }
      print(e);
    }
    return null;
  }

  Future<Response?> deleteServerTask(TaskServer data, String token) async {
    final String url = await getDynamicIp();
    String uri = "${url}tasks/${data.id!}";
    print("in server delete");
    print(data.toString());
    try {
      final response = await dio.delete(uri,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }));
      print(response.data);
      print(response.statusCode);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 201) {
        return Response(
          data: [],
          headers: e.response?.headers,
          requestOptions: e.requestOptions,
          statusCode: 201,
        );
      }
      print(e);
    }
    return null;
  }

  Future getServerTask(String token) async {
    final String url = await getDynamicIp();
    String uri = "${url}tasks";
    try {
      final response = await dio.get(uri,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }));
    } on DioException catch (e) {
      print(e);
    }
    return null;
  }

  Future<Response?> register(String username, String password) async {
    final String url = await getDynamicIp();
    String uri = "${url}authentication/sign-up";
    try {
      final response = await dio
          .post(uri, data: {'username': username, 'password': password});
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 201) {
        return Response(
          data: e.response?.data,
          headers: e.response?.headers,
          requestOptions: e.requestOptions,
          statusCode: 201,
        );
      }
      print(e);
    }
    return null;
  }

  Future<Response?> getToken(String username, String password) async {
    final String url = await getDynamicIp();
    String uri = "${url}authentication/sign-in";
    try {
      final response = await dio
          .post(uri, data: {'username': username, 'password': password});
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Response(
          data: {'Unauthorized access'},
          headers: e.response?.headers,
          requestOptions: e.requestOptions,
          statusCode: 401,
        );
      }
      print(e);
      //if(e == DioException.badResponse(statusCode: 401, requestOptions: requestOptions, response: dt))
    }
    return null;
  }
}
