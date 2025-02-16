

class Event {
  final int eventId;
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final String image;
  final int category;

  Event({
    required this.eventId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.image,
    required this.category,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] as int,
      title: json['title'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      location: json['location'] as String,
      image: "http://192.168.1.20:5050/${json['image']}", // Ensure it's a full URL
      category: json['category'] as int,
    );
  }
}
