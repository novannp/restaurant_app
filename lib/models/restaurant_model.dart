import 'category_model.dart';
import 'customer_review_model.dart';
import 'menus_model.dart';
import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"] == null ? '' : json['description'],
        city: json["city"],
        address:
            json["address"] == null ? 'address not found' : json['address'],
        pictureId: json["pictureId"],
        rating: json["rating"].toDouble(),
        categories: json['categories'] != null
            ? List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x)))
            : [Category(name: '')],
        menus: json['menus'] != null
            ? Menus.fromJson(json["menus"])
            : Menus(foods: [], drinks: []),
        customerReviews: json['customerReviews'] != null
            ? List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : [
                CustomerReview(
                    name: 'noName', review: 'no review', date: 'not available'),
              ]);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "pictureId": pictureId,
        "rating": rating,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        city,
        address,
        pictureId,
        rating,
        categories,
        menus,
        customerReviews
      ];
}
