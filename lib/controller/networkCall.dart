import 'package:github_user/controller/global.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class networkLayer{
  Future getGitUser() async {
    final String apiUrl = userList().getUrl;
    try {
      final response = await http.get(apiUrl);
    print('Response is ${response.body}');
      if (response.statusCode == 200) {
        final String responseString = response.body;
       
        var data = json.decode(responseString);
        //print(data);
        return data;
      } else if (response.statusCode >= 500 && response.statusCode <= 599) {
        return 0; // Something went wrong
      }
    } catch (e) {
      
      print(e);
      return 0;
    }
  }
}
