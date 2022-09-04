import 'dart:convert';

import '../models/restaurant_model.dart';
import 'package:http/http.dart' as client;

import '../models/restaurants_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _getList = 'list';
  static const String _detail = 'detail/';
  static const String _search = 'search?q=';

  getRestaurantList() async {
    final Uri url = Uri.parse('$_baseUrl$_getList');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return Restaurants.fromJson(data);
    } else {
      return 'Connection lost';
    }
  }

  Future getRestaurantById(String id, client.Client http) async {
    final Uri url = Uri.parse('$_baseUrl$_detail$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Restaurant.fromJson(data['restaurant']);
    } else {
      return 'Failed to get data';
    }
  }

  Future<Restaurants> searchRestaurants(String query) async {
    final Uri url = Uri.parse('$_baseUrl$_search$query');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return Restaurants.fromJson(data);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
