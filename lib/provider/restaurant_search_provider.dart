import 'package:flutter/material.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';
import 'package:restaurant_app/service/api_service.dart';

import '../models/restaurants_model.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;
  late Restaurants _restaurants;
  late ResultState _state;
  String message = '';
  Restaurants get restaurants => _restaurants;
  ResultState get state => _state;

  RestaurantSearchProvider(this.apiService);

  fetchSearchResult(String query) async {
    try {
      _state = ResultState.loading;
      final result = await apiService.searchRestaurants(query);
      if (result.restaurants.isEmpty) {
        _state = ResultState.dataEmpty;
        notifyListeners();
        return message = 'Not Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants = result;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return message = 'No internet. Please check your connection';
    }
  }
}
