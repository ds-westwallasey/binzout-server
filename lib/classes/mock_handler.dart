import 'dart:async';
import 'dart:convert';
import 'package:main/classes/production_handler.dart';

class MockHandler extends ProductionHandler {
  @override
  Future<String> getBinSchedule(String postcode) async {
    late String jsonTestData;

    if (postcode == "L167PQ") {
      jsonTestData = jsonEncode([
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
    } else if (postcode == "L167PG") {
      Future<String> delayedResponse() async {
        await Future.delayed(const Duration(seconds: 31));
        return "I never get thrown";
      }

      await Future.any([delayedResponse()]);
    } else {
      /*
        for purpose of mocking: there are only two current scenarios for this function 
         - the real world api only seems to either provide schedules or an empty array with provided with a postcode entry:
         - valid postcode finding schedules
         - invalid returning an empty array
       */
      jsonTestData = jsonEncode([]);
    }

    return jsonTestData;
  }
}
