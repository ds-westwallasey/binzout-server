import 'dart:convert';
import 'package:main/classes/mock_handler.dart';
import 'package:main/server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() async {
  final server = await generateServerConnection(
    MockHandler().handler,
    0,
    "localhost",
  );
  final port = server.port;

  group('GET Requests', () {
    test(
      '200: api/healthcheck - expect this endpoint to return a string',
      () async {
        final url = Uri.parse('http://localhost:$port/api/healthcheck');

        final Response response = await MockHandler().handler(
          Request('GET', url),
        );

        final String responseBody = await response.readAsString();

        expect(responseBody, "Hello from working server!");
      },
    );

    test('200: api/bins/<postcode> ', () async {
      final url = Uri.parse('http://localhost:$port/api/bins/L167PQ');

      final Response response = await MockHandler().handler(
        Request('GET', url),
      );

      final responseBody = await response.readAsString();
      final parsedJsonList = jsonDecode(responseBody);

      expect(parsedJsonList.length, 3);
      expect(
        parsedJsonList,
        everyElement(
          predicate((element) {
            if (element is Map<String, dynamic>) {
              return element['Date'] != null &&
                  element['Type'] != null &&
                  element['CalendarNumber'] != null;
            }
            return false;
          }),
        ),
      );
    });
  });
}
