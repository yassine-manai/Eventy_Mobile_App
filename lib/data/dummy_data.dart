import 'package:event_app/models/event.dart';

final List<Event> dummyEvents = [
  Event(
    id: '1',
    title: 'Tech Conference 2025',
    description: 'Annual technology conference featuring the latest innovations in AI, blockchain, and cloud computing. Join industry leaders and innovators for three days of inspiring talks, workshops, and networking opportunities.',
    category: 'Technology',
    location: 'Silicon Valley Convention Center',
    startDate: "2025, 3, 15",
    endDate: "2025, 04, 15",
    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
    price: 299.99,
  ),
  Event(
    id: '2',
    title: 'Summer Music Festival',
    description: 'Three days of live music performances featuring top artists from around the world. Experience multiple stages, food vendors, and unforgettable moments under the summer sky.',
    category: 'Music',
    location: 'Central Park',
    startDate: "2025, 3, 15",
    endDate: "2025, 04, 15",
    imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
    price: 150.00,
  ),
  Event(
    id: '3',
    title: 'Global Business Summit',
    description: 'Connect with business leaders and entrepreneurs from around the world. Featuring keynote speakers, panel discussions, and networking sessions focused on future business trends.',
    category: 'Business',
    location: 'Grand Hyatt Hotel',
    startDate: "2025, 3, 15",
    endDate: "2025, 04, 15",
    imageUrl: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=800&q=80',
    price: 499.99,
  ),
  Event(
    id: '4',
    title: 'International Sports Cup',
    description: 'Watch the world\'s top athletes compete in this prestigious sporting event. Multiple sports, opening ceremony, and closing celebrations included.',
    category: 'Sports',
    location: 'National Stadium',
    startDate: "2025, 3, 15",
    endDate: "2025, 04, 15",
    imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800&q=80',
    price: 199.99,
  ),
  Event(
    id: '5',
    title: 'Modern Art Exhibition',
    description: 'Experience contemporary art from renowned artists worldwide. Features installations, paintings, sculptures, and interactive digital art pieces.',
    category: 'Arts',
    location: 'Metropolitan Art Gallery',
    startDate: "2025-3-15",
    endDate: "2025-04-15",
    imageUrl: 'https://images.unsplash.com/photo-1531243269054-5ebf6f33c7ce?w=800&q=80',
    price: 25.00,
  ),
];

final List<String> categories = [
  'All',
  'Technology',
  'Music',
  'Business',
  'Sports',
  'Arts',
];