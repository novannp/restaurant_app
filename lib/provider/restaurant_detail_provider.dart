import 'package:flutter/material.dart';
import 'package:restaurant_app/service/api_service.dart';

import '../models/restaurant_model.dart';
import 'restaurants_provider.dart';
import 'package:http/http.dart' as http;

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  late ResultState _state;
  late Restaurant _restaurant;
  String message = '';

  ResultState get state => _state;
  Restaurant get restaurant => _restaurant;

  RestaurantDetailProvider(this.apiService);

  Future<dynamic> fetchRestaurantDetail(String id, http.Client http) async {
    try {
      _state = ResultState.loading;
      final result = await apiService.getRestaurantById(id, http);
      if (result.id.isEmpty) {
        _state = ResultState.dataEmpty;
        notifyListeners();
        return message = 'Data is empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = result;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return message = 'Data error';
    }
  }
}
