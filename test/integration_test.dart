import 'dart:convert';
import 'package:main/server/server.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() async {
  final server = await generateServerConnection(
    productionHandler,
    0,
    "localhost",
  );
  final port = server.port;

  group(
    'GET',
    () => {
      test('200: api/healthcheck', () async {
        final url = Uri.parse('http://localhost:$port/api/healthcheck');
        final response = await http.get(url);
        expect(response.body, "Hello from working server!");
      }),

      test('200: api/bins/<postcode> ', () async {
        const postcode = 'L167PQ';
        final url = Uri.parse(
          'http://localhost:$port/api/bins/postcode/$postcode',
        );
        final response = await http.get(url);
        final List<dynamic> binSchedule = jsonDecode(response.body);

        expect(binSchedule.length, 3);
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
