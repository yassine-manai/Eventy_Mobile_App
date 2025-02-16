import 'package:dio/dio.dart';

Future<List<String>> fetchCategories() async {
  try {
    final response = await Dio().get('https://example.com/api/categories');

    // Fix: Convert List<dynamic> to List<String>
    return (response.data as List)
        .map((e) => e['category_name'].toString())
        .toList();
  } catch (e) {
    print("Error fetching categories: $e");
    return [];
  }
}
