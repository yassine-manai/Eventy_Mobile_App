import 'package:flutter/material.dart';
import '../models/event.dart';
import '../data/dummy_data.dart';
import '../widgets/event_card.dart';
import '../widgets/category_filter.dart';
import 'event_detail_screen.dart';
import 'login_screen.dart'; // Add this import

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<EventListScreen> with SingleTickerProviderStateMixin {
  String selectedCategory = 'All';
  String searchQuery = '';
  List<Event> filteredEvents = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    filteredEvents = dummyEvents;
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

  Future<void> _loadMoreEvents() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterEvents(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredEvents = dummyEvents.where((event) {
      final matchesCategory = selectedCategory == 'All' || event.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          event.title.toLowerCase().contains(searchQuery) ||
          event.description.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
    filteredEvents.sort((b, a) => a.startDate.compareTo(b.startDate));
  }

  Future<void> _refreshEvents() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _applyFilters();
      isLoading = false;
    });
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildCategoryFilter(),
          ),
          _buildEventsList(),
        ],
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
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearchDialog(context),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortDialog(context),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CategoryFilter(
        categories: const ['All', 'Music', 'Sports', 'Business', 'Technology', 'Art'],
        selectedCategory: selectedCategory,
        onCategorySelected: filterEvents,
      ),
    );
  }

  Widget _buildEventsList() {
    if (filteredEvents.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == filteredEvents.length) {
              return _buildLoader();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FadeTransition(
                opacity: _animation,
                child: EventCard(
                  event: filteredEvents[index],
                  onTap: () => _navigateToDetail(filteredEvents[index]),
                ),
              ),
            );
          },
          childCount: filteredEvents.length + 1,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: isLoading ? const CircularProgressIndicator() : const SizedBox(),
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Search Events'),
          content: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Enter event name or description...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sort Events'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption('Date (Newest First)', () => _sortEvents((b, a) => a.startDate.compareTo(b.startDate))),
              _buildSortOption('Date (Oldest First)', () => _sortEvents((a, b) => a.startDate.compareTo(b.startDate))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }

  void _sortEvents(int Function(Event, Event) compareFunction) {
    setState(() {
      filteredEvents.sort(compareFunction);
    });
  }
}