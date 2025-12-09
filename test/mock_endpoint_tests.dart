import 'dart:convert';

import 'package:main/classes/mock_handler.dart';
import 'package:main/utilities/utilities.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() async {
  final server = await generateServerConnection(
    MockHandler().handler,
    "localhost",
  );
  final port = server.port;

  group('checkHealthStatus()', () {
    test(
      '200: Server responds with a healthcheck message when running successfully',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/api/healthcheck'),
        );

        expect(response.body, equals("Hello from working server!"));
      },
    );
  });

  group('getBinSchedule function()', () {
    test(
      '200: Server returns 200 and a list of bin schedules when provided with a valid postcode',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/api/bins/postcode/L167PQ'),
        );

        expect(
          response.body,
          jsonEncode([
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
          ]),
        );
      },
    );
    test(
      '404: Server returns 404 not found when a provided postcode returns no schedule or is not a valid postcode',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/api/bins/postcode/invalidPostcode'),
        );

        expect(response.statusCode, 404);
        expect(
          response.body,
          "404: Could not find information for this postcode.",
        );
      },
    );
  });

  group('Valid but unhandled endpoint', () {
    test(
      'if provided an endpoint that is not handled by the handler, server returns a 404 - not found',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/whatisthis'),
        );

        expect(response.statusCode, equals(404));
        expect(response.body, equals("404: Endpoint not recognised."));
      },
    );
  });

  group('Errors', () {
    test(
      'Server will return a 408 timeout error if a request times out',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/api/bins/postcode/L167PG'),
        );

        expect(response.statusCode, equals(408));
        expect(response.body, "408: Server has timed out.");
      },
      timeout: Timeout(Duration(seconds: 35)),
    );
  });
}
