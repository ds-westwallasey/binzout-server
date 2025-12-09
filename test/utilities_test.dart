import 'dart:convert';
import 'package:main/classes/calender_event.dart';
import 'package:main/utilities/utilities.dart';
import 'package:test/test.dart';

void main() {
  group("decodeJsonList", () {
    test('type of return value is List<T>', () {
      const String testString = "[]";
      final parsedList = decodeJsonList(testString, CalenderEvent.fromJson);

      expect(parsedList, TypeMatcher<List<CalenderEvent>>());
    });

    test(
      "will parsed a json string containing a single instance of type T",
      () {
        final String testString = jsonEncode([
          {
            "Date": "2025-12-04T16:30:33.2886395+00:00",
            "Type": 2,
            "CalendarNumber": 2,
          },
        ]);

        final parsedList = decodeJsonList(testString, CalenderEvent.fromJson);
        final calendarEvent = parsedList[0];

        expect(parsedList.length, equals(1));
        expect(calendarEvent, TypeMatcher<CalenderEvent>());
        expect(calendarEvent.date, equals("2025-12-04T16:30:33.2886395+00:00"));
        expect(calendarEvent.type, equals(2));
        expect(calendarEvent.calendarNumber, equals(2));
      },
    );

    test(
      "will parse a json string containing multiple instances of type T",
      () {
        final String testString = jsonEncode([
          {
            "Date": "2025-12-04T16:30:33.2886395+00:00",
            "Type": 2,
            "CalendarNumber": 2,
          },
          {
            "Date": "2025-12-04T16:30:33.2886395+00:00",
            "Type": 1,
            "CalendarNumber": 1,
          },
        ]);

        final parsedList = decodeJsonList(testString, CalenderEvent.fromJson);

        expect(parsedList.length, equals(2));
        for (var event in parsedList) {
          expect(event, TypeMatcher<CalenderEvent>());
          expect(event.date, TypeMatcher<String>());
          expect(event.type, TypeMatcher<int>());
          expect(event.calendarNumber, TypeMatcher<int>());
        }
      },
    );
  });
}
