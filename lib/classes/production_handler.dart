import 'dart:async';
import 'package:main/classes/calender_event.dart';
import 'package:main/utilities/utilities.dart';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

class ProductionHandler {
  FutureOr<Response> handler(Request request) async {
    try {
      var url = request.url.toString();
      RegExp postcodeExp = RegExp(r'api/bins/postcode');

      if (url == "api/healthcheck") {
        final response = await checkHealthStatus();
        return Response.ok(response);
      }
      // if it matches postcode endpoint
      else if (postcodeExp.hasMatch(url)) {
        final postcode = url.split("/")[3];
        final scheduleResponse = await getBinSchedule(
          postcode,
        ).timeout(Duration(seconds: 30));

        final parsedCalendarEventList = decodeJsonList(
          scheduleResponse,
          CalenderEvent.fromJson,
        );

        if (parsedCalendarEventList.isEmpty) {
          return Response.notFound(
            "404: Could not find information for this postcode.",
          );
        } else {
          return Response.ok(scheduleResponse);
        }
      } else {
        return Response.notFound("404: Endpoint not recognised.");
      }
    } catch (e) {
      // if a TimeoutException is thrown by
      if (e is TimeoutException) {
        return Response(408, body: "408: Server has timed out.");
      }

      return Response.ok("Some other error");
    }
  }

  Future<String> checkHealthStatus() async {
    return "Hello from working server!";
  }

  Future<String> getBinSchedule(String postcode) async {
    final apiUrl = Uri.parse(
      'https://api.liverpool.gov.uk/api/Bins/Postcode/$postcode',
    );
    final response = await http.get(apiUrl);
    final scheduleData = response.body;

    return scheduleData;
  }
}
