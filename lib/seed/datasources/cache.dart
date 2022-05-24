import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'files.dart';

class CacheAPI {

  saveData(String name, dynamic data) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String type = "";

    if(data is Map<String, dynamic>) {
      type = "json";
      data = jsonDecode(data.toString());
    }
    else if(data is int)
      type = "int";
    else if (data is double)
      type = "double";
    else if(data is String)
      type = "string";
    else if(data is bool)
      type = "bool";

    prefs.setStringList(name, [type, data.toString()]);

  }

  loadData(String name) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? values = prefs.getStringList(name);
    String? type = values![0];
    String? data =  values[1];

    if(type == 'json')
      return json.decode(data);
    else if(data is int)
      return int.parse(data);
    else if (data is double)
      return double.parse(data);
    else if(data is String)
      return data;
    else if(data is bool)
      return data == 'true';

  }

  savePendingHTTPRequest(String url, String method, {dynamic params, dynamic body, String? pathFile, ByteData? bytesFile}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> requests = prefs.getStringList("HTTP_"+method)??[];

    if(method == "UPLOAD_BYTES") {
      var path = await FileAPI().writeFile(bytesFile!, DateTime.now().toLocal().toString());
      pathFile = path;
      method = "UPLOAD";
    }

    requests.add(jsonEncode({
      "number": requests.length,
      "method": method,
      "body": body??{},
      "params": params??{},
      "path": pathFile??"",
      "url": url
    }));

    prefs.setStringList("HTTP_"+method, requests);

  }

  getPendingHTTPRequests() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? get = prefs.getStringList("HTTP_GET");
    List<String>? post = prefs.getStringList("HTTP_POST");
    List<String>? put = prefs.getStringList("HTTP_PUT");
    List<String>? delete = prefs.getStringList("HTTP_DELETE");
    List<String>? upload = prefs.getStringList("HTTP_UPLOAD");

    return {
      "GET": get != null ? get.map((e) => jsonDecode(e)).toList() : [],
      "POST": post != null ? post.map((e) => jsonDecode(e)).toList() : [],
      "PUT": put != null ? put.map((e) => jsonDecode(e)).toList() : [],
      "DELETE": delete != null ? delete.map((e) => jsonDecode(e)).toList() : [],
      "UPLOAD": upload != null ? upload.map((e) => jsonDecode(e)).toList() : [],
    };

  }

  savePendingGQLRequest(String url, String method, String query, {dynamic variables}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> requests = prefs.getStringList("GQL_" + method)??[];

    requests.add(jsonEncode({
      "number": requests.length,
      "url": url,
      "method": method,
      "variables": variables??{},
      "query": query
    }));

    prefs.setStringList("GQL_" + method, requests);

  }

  getPendingGQLRequests() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? query = prefs.getStringList("GQL_QUERY");
    List<String>? save = prefs.getStringList("GQL_SAVE");
    List<String>? set = prefs.getStringList("GQL_SET");
    List<String>? delete = prefs.getStringList("GQL_DELETE");

    return {
      "QUERY": query != null ? query.map((e) => jsonDecode(e)).toList() : [],
      "SAVE": save != null ? save.map((e) => jsonDecode(e)).toList() : [],
      "SET": set != null ? set.map((e) => jsonDecode(e)).toList() : [],
      "DELETE": delete != null ? delete.map((e) => jsonDecode(e)).toList() : [],
    };

  }

  clearPendingHTTPRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("HTTP_GET", []);
    await prefs.setStringList("HTTP_POST", []);
    await prefs.setStringList("HTTP_PUT", []);
    await prefs.setStringList("HTTP_DELETE", []);
    await prefs.setStringList("HTTP_UPLOAD", []);
  }

  clearPendingGQLRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("GQL_QUERY", []);
    await prefs.setStringList("GQL_SAVE", []);
    await prefs.setStringList("GQL_SET", []);
    await prefs.setStringList("GQL_DELETE", []);
  }

}