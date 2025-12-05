import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http/http.dart' as http;

Future<Response> productionHandler(Request request) async {
  var url = request.url.toString();
  print(url);

  if (url == "api/healthcheck") {
    return Response.ok("Hello from working server!");
  }

  RegExp postcodeExp = RegExp(r'api/bins/postcode');

  if (postcodeExp.hasMatch(url)) {
    final postcode = url.split("/")[3];
    final apiUrl = Uri.parse(
      'https://api.liverpool.gov.uk/api/Bins/Postcode/$postcode',
    );
    final response = await http.get(apiUrl);
    final scheduleData = response.body;

    return Response.ok(scheduleData);
  }

  return Response.ok('No endpoints could be matched!');
}

Future<HttpServer> generateServerConnection(
  Handler handler, [
  int port = 0,
  String host = "localhost",
]) async {
  final routeHandler = Pipeline().addHandler(handler);

  final httpServer = await shelf_io.serve(routeHandler, host, port);

  print('Server listening on port:$port');
  return httpServer;
}
