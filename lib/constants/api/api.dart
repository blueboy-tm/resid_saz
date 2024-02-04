import 'package:dio/dio.dart';

class Api {
  static const make = '/make/';
}

final dio = Dio(
  BaseOptions(
    headers: {
      'Content-Type': 'application/json',
    }
  ),
);
