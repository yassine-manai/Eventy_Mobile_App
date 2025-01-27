import 'package:flutter/material.dart';
import '../models/event.dart';
import '../data/dummy_data.dart';
import '../widgets/event_card.dart';
import '../widgets/category_filter.dart';
import 'event_detail_screen.dart';
class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String selectedCategory = 'All';
  List<Event> filteredEvents = dummyEvents;

  void filterEvents(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredEvents = dummyEvents;
      } else {
        filteredEvents = dummyEvents
            .where((event) => event.category == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Column(
        children: [
          CategoryFilter(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: filterEvents,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (ctx, index) => EventCard(
                event: filteredEvents[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(
                        event: filteredEvents[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
