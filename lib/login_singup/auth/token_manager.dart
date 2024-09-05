// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/login_singup/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../main.dart';
class ApiClient {
  // Assume you have methods like these to retrieve tokens from secure storage
  Future<String?> getJwtToken() async {
    // Implement your logic to retrieve the JWT token
    return await secure_storage.read(key: 'token');
  }
  Future<String?> getSessionId() async {
    // Implement your logic to retrieve the JWT token
    return await secure_storage.read(key: 'sessionId');
  }
  Future<bool> isJwtTokenExpired() async {
    try {
      final String? token = await secure_storage.read(key: 'token');
      if (token == null) {
        return true;
      }
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final int expirationTimestamp = decodedToken['exp'];
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds

      if (currentTimestamp > expirationTimestamp) {
        // Token is expired
        return true;
      } else {
        // Token is not expired
        return false;
      }
    } catch (e) {
      // Invalid token or couldn't decode it
      return true; // Assume it's expired to be safe
    }
  }
  void Jwtkicker(BuildContext context) async {
    try {
      final String? token = await secure_storage.read(key: 'token');
      if (token == null) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
      }
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final int expirationTimestamp = decodedToken['exp'];
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds

      if (currentTimestamp > expirationTimestamp) {
        // Token is expired
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
      } else {
      }
    } catch (e) {
      // Invalid token or couldn't decode it
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),), (route) => false);
// Assume it's expired to be safe
    }
  }
  Future<http.Response?> makeAuthenticatedRequest(String path, Map<String, dynamic> body) async {
    final jwtToken = await getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL, path);
    bool waitexp=await isJwtTokenExpired();
    if (jwtToken != null && !waitexp) {
      // JWT token is valid, attach it to the request header
      try {
        final response = await http.post(url, headers: headers, body: jsonEncode(body));
        if (response.statusCode == 200) {
          // Handle the successful response
          return response;
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
        } else {
          // Handle other status codes
        }
      // ignore: empty_catches
      } catch (e) {
      }
    } else {
    }
  }
  Future<bool?> deletAccount(BuildContext context)async {
    var jwtToken = await ApiClient().getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL,"/api/Auth/DeleteMyAccount");
    bool waitexp=  await isJwtTokenExpired();
    final sessionId = await getSessionId();
    if (sessionId != null) {
      headers['Cookie'] = 'SessionId=$sessionId';
    }
    else
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
    }
    if (jwtToken != null && !waitexp) {
      // JWT token is validH, attach it to the request header
      try {
        // Make the API request
        final response = await http.delete(url, headers: headers);
        if (response.statusCode == 204) {
          // Handle the successful response
          return true;
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login(),), (
              route) => false,);
        } else if (response.statusCode == 499) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login(),), (
              route) => false,);
        }
      }
      catch(e)
      {
        return false;
      }
    }

  }
  Future<http.Response?> getAuthenticatedRequest(BuildContext context,String path) async {
    final jwtToken = await getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL, path);
    bool waitexp=await isJwtTokenExpired();
    final sessionId = await getSessionId();
    if (sessionId != null) {
      headers['Cookie'] = 'SessionId=$sessionId';
    }
    else
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
    }
    if (jwtToken != null && !waitexp) {
      // JWT token is validH, attach it to the request header
      try {
        // Make the API request
        final response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          // Handle the successful response
          return response;
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
        }else if (response.statusCode == 499)
          {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
          }
          else {
          // Handle other status codes
        }
        // ignore: empty_catches
      } catch (e) {
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login(),));
    }
  }

  Future<bool?> putinfo(BuildContext context,String newName)async {
    var jwtToken = await ApiClient().getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL,"/api/Auth/UpdateProfile");
    bool waitexp=  await isJwtTokenExpired();
    final sessionId = await getSessionId();
    if (sessionId != null) {
      headers['Cookie'] = 'SessionId=$sessionId';
    }
    else
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
    }
    if (jwtToken != null && !waitexp) {

      Map<String, String> data = {
        "fullName": newName,
      };
      String jsonBody = jsonEncode(data);

      // JWT token is validH, attach it to the request header
      try {
        // Make the API request
        final response = await http.put(url, headers: headers,body: jsonBody);
        if (response.statusCode == 204) {
          // Handle the successful response
          return true;
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login(),), (
              route) => false,);
        } else if (response.statusCode == 499) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login(),), (
              route) => false,);
        }
      }
      catch(e)
      {
        return false;
      }
    }

  }
  Future<String?> addFreeCourse(BuildContext context,String courseId)async {
    print(courseId);
    var jwtToken = await ApiClient().getJwtToken();
    final headers= {'Authorization': 'Bearer $jwtToken','Content-Type': 'application/json'};
    var url = Uri.https(URL,"/api/UserCourses/AddFreeCourse");
    bool waitexp=  await isJwtTokenExpired();
    final sessionId = await getSessionId();
    if (sessionId != null) {
      headers['Cookie'] = 'SessionId=$sessionId';
    }
    else
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login(),),(route) => false,);
    }
    if (jwtToken != null && !waitexp) {

      Map<String, String> data = {
        "courseId": courseId,
      };
      String jsonBody = jsonEncode(data);

      // JWT token is validH, attach it to the request header
      try {
        // Make the API request
        final response = await http.post(url, headers: headers,body: jsonBody);
        print(response.body);
        if (response.statusCode == 204) {
          // Handle the successful response
          return "تم الأضافة";
        }else if (response.statusCode == 404) {
          // JWT token expired, attempt to refresh
          // ignore: use_build_context_synchronously
          return "تمت اضافة هذه الكورس بالفعل";
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login(),), (
              route) => false,);
          return "حدثت مشكلة اثناء اضافة الكورس";
        } else if (response.statusCode == 499) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login(),), (
              route) => false,);
          return "حدثت مشكلة اثناء اضافة الكورس";
        }
      }
      catch(e)
      {
        return "حدثت مشكلة اثناء اضافة الكورس";
      }
    }

  }

}