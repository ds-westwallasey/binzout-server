import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class MockHandler {
  FutureOr<Response> handler(Request request) {
    var url = request.url.toString();

    if (url == "api/healthcheck") {
      return Response.ok(checkHealthStatus());
    }

    if (url == "api/bins/L167PQ") {
      return Response.ok(getBinSchedule());
    }

    return Response.ok("Mock Handler could not match this route");
  }

  String checkHealthStatus() {
    return "Hello from working server!";
  }

  String getBinSchedule() {
    return jsonEncode([
      {
        "Date": "2025-12-04T16:30:33.2886395+00:00",
        "Type": 2,
        "CalendarNumber": 2,
      },
      {
        "Date": "2025-12-04T16:30:33.2886395+00:00",
        "Type": 2,
        "CalendarNumber": 2,
      },
      {
        "Date": "2025-12-04T16:30:33.2886395+00:00",
        "Type": 2,
        "CalendarNumber": 2,
      },
    ]);
  }
}
