class CalenderEvent {
  final String date;
  final int type;
  final int calendarNumber;

  CalenderEvent(this.date, this.type, this.calendarNumber);

  Map<String, dynamic> toJson() {
    return {'date': date, 'type': type, 'calendarNumber': calendarNumber};
  }

  factory CalenderEvent.fromJson(Map<String, dynamic> json) {
    return CalenderEvent(
      json['date'] as String,
      json['type'] as int,
      json['calendarNumber'] as int,
    );
  }
}
