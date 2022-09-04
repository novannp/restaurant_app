import 'package:flutter/material.dart';
import 'package:restaurant_app/service/api_service.dart';

import '../models/restaurants_model.dart';

enum ResultState { loading, hasData, dataEmpty, error }

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;
  late ResultState _state;
  late Restaurants _restaurants;
  String message = '';

  ResultState get state => _state;
  Restaurants get restaurants => _restaurants;

  RestaurantsProvider({required this.apiService}) {
    fetchAllRestaurants();
  }

  fetchAllRestaurants() async {
    _state = ResultState.loading;
    notifyListeners();
    final result = await apiService.getRestaurantList();
    if (result.runtimeType != Restaurants) {
      _state = ResultState.error;
      notifyListeners();
      return message = 'Connection lost';
    }
    try {
      if (result.restaurants.isEmpty) {
        _state = ResultState.dataEmpty;
        notifyListeners();
        return message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants = result;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return message = 'Error $e';
    }
  }
}
