import 'dart:convert';
import 'package:main/classes/production_handler.dart';
import 'package:http/http.dart' as http;
import 'package:main/utilities/utilities.dart';
import 'package:test/test.dart';

void main() async {
  final server = await generateServerConnection(
    ProductionHandler().handler,
    "0.0.0.0",
  );
  final port = server.port;

  group(
    'GET',
    () => {
      test('200: api/healthcheck', () async {
        final url = Uri.parse('http://localhost:$port/api/healthcheck');
        final response = await http.get(url);

        expect(response.statusCode, equals(200));
        expect(response.body, equals("Hello from working server!"));
      }),

      test('200: api/bins/<postcode> ', () async {
        const postcode = 'L167PQ';
        final url = Uri.parse(
          'http://localhost:$port/api/bins/postcode/$postcode',
        );
        final response = await http.get(url);
        final List<dynamic> binSchedule = jsonDecode(response.body);

        expect(response.statusCode, equals(200));
        expect(binSchedule.length, equals(3));
        expect(
          binSchedule,
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
      }),
    },
  );
}
