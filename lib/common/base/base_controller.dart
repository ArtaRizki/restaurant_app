import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BaseController {
  SharedPreferences? _preferences;
  Future<SharedPreferences?> preferences() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<String?> getToken() async {
    return (await preferences())!.getString('token');
  }

  Future<Response> get(String url,
      {Map? headers, Map<String, String?>? query}) async {
    Map<String, String> h = <String, String>{};
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer $token');
    if (headers != null) h.addAll(headers as Map<String, String>);

    final uri = Uri.parse(url);
    final queryUri = Uri.https(uri.authority, uri.path, query);

    log("==== PARAMETERS ====");
    log("URL : $url");
    log("QUERY : $queryUri");
    Response response = await http.get(queryUri, headers: h);
    log("RESPONSE GET $url : ${response.body}");
    log("====================");

    return response;
  }

  Future<Response> post(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? body,
      List<http.MultipartFile>? files}) async {
    Map<String, String> h = <String, String>{};
    h.putIfAbsent('Connection', () => 'Keep-Alive');
    h.putIfAbsent('accept', () => 'application/json');
    var token = await getToken();
    if (token != null) h.putIfAbsent('Authorization', () => 'Bearer $token');
    if (headers != null) h.addAll(headers);

    if (files == null) {
      log("==== PARAMETERS ====");
      log("URL : $url");
      log("BODY : $body");
      Response response = await http.post(Uri.parse(url),
          headers: h, body: body, encoding: Encoding.getByName("utf-8"));
      log("RESPONSE POST $url : ${response.body}");
      log("====================");
      return response;
    } else {
      var req = http.MultipartRequest("POST", Uri.parse(url));
      h.putIfAbsent("Content-Type", () => 'multipart/form-data');
      req.headers.addAll(h);
      if (body != null) {
        req.fields
            .addAll(body.map((key, value) => MapEntry(key, value.toString())));
      }
      req.files.addAll(files);
      log("==== PARAMETERS ====");
      log("URL : $url");
      log("BODY : $body");
      Response response = await http.Response.fromStream(await req.send());
      log("RESPONSE POST FILE $url : ${response.body}");
      log("====================");
      return response;
    }
  }
}
