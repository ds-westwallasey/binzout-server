import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

List<T> decodeJsonList<T>(
  String jsonString,
  T Function(Map<String, dynamic>) fromJson,
) {
  final List<dynamic> decodedString = jsonDecode(jsonString);
  final List<T> targetClassList = [];

  for (var iterable in decodedString) {
    targetClassList.add(fromJson(iterable as Map<String, dynamic>));
  }

  return targetClassList;
}

Future<HttpServer> generateServerConnection(
  Handler handler, [
  String host = "localhost",
  int port = 0,
]) async {
  final routeHandler = Pipeline().addHandler(handler);

  final httpServer = await shelf_io.serve(routeHandler, host, port);

  print('Server listening on port:${httpServer.port}');
  return httpServer;
}
