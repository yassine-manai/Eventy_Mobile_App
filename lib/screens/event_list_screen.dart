import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/category_filter.dart';
import 'event_detail_screen.dart';
import 'login_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<EventListScreen> with SingleTickerProviderStateMixin {
  String selectedCategory = 'All';
  String searchQuery = '';
  List<Event> filteredEvents = [];
  List<String> categories = ['All'];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _scrollController.addListener(_onScroll);
    _fetchCategories();
    _fetchEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://192.168.1.20:5050/mobile/get_categorys'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories.addAll(data.map((cat) => cat['category_name'].toString()).toList());
      });
    }
  }
  Future<void> _loadMoreEvents() async {
  if (!isLoading) {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.1.20:5050/mobile/get_events'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Event> newEvents = data.map((json) => Event.fromJson(json)).toList();

        setState(() {
          filteredEvents.addAll(newEvents);
        });
      }
    } catch (error) {
      print('Error fetching more events: $error');
    }

    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> _fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://192.168.1.20:5050/mobile/get_events'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        filteredEvents = data.map((json) => Event.fromJson(json)).toList();
        isLoading = false;
      });
    }
  }

  void filterEvents(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  Future<void> _refreshEvents() async {
    await _fetchEvents();
  }

  void _disconnect() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: _buildCategoryFilter(),
            ),
            _buildEventsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: _disconnect,
        color: Theme.of(context).primaryColor,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Discover Events',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CategoryFilter(
        categories: categories,
        selectedCategory: selectedCategory,
        onCategorySelected: filterEvents,
      ),
    );
  }

  Widget _buildEventsList() {
    if (filteredEvents.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text('No events found'),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => EventCard(
            event: filteredEvents[index],
            onTap: () => _navigateToDetail(filteredEvents[index]),
          ),
          childCount: filteredEvents.length,
        ),
      ),
    );
  }

  void _navigateToDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }
}
