import 'package:flutter/material.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';
import 'package:restaurant_app/service/database_service.dart';

import '../models/restaurant_model.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseService databaseService;
  List<Restaurant> _favorites = [];

  late ResultState _state;
  String message = '';
  DatabaseProvider(this.databaseService) {
    _getFavorites();
  }

  ResultState get state => _state;
  List<Restaurant> get favorites => _favorites;

  Future<bool> isBookmarked(String id) async {
    final bookmarkedRestaurant = await databaseService.getFavoritesById(id);
    return bookmarkedRestaurant.isNotEmpty;
  }

  void _getFavorites() async {
    await databaseService.getFavorites().then((value) => _favorites = value);
    if (_favorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.dataEmpty;
      message = 'Data is Empty';
    }
    notifyListeners();
  }

  void addBookmark(Restaurant restaurant) async {
    try {
      await databaseService.addFavorites(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      message = 'Error $e';
      notifyListeners();
    }
  }

  void deleteBookmark(String id) async {
    try {
      await databaseService.deleteFavorites(id);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      message = ' Error : $e';
      notifyListeners();
    }
  }
}
