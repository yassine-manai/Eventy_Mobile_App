class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String startDate;
  final String endDate;
  final String imageUrl;
  final double price;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.price,
  });
}
