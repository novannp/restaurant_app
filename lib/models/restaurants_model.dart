import 'restaurant_model.dart';

class Restaurants {
  final List<Restaurant> restaurants;

  Restaurants({required this.restaurants});

  factory Restaurants.fromJson(Map<String, dynamic> json) {
    //============ PENJABARAN PEMROSESAN DATA ==========
    // List<dynamic> response = json['restaurants'];
    // List<Restaurant> data =
    //     response.map((e) => Restaurant.fromJson(e)).toList();

    return Restaurants(
      restaurants: List<Restaurant>.from(
          json['restaurants'].map((e) => Restaurant.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() => {
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
