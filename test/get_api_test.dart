// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:restaurant_app/service/api_service.dart';

void main() {
  ApiService apiService = ApiService();
  String id = 'rqdv5juczeskfw1e867';
  group('get Restaurant Detail  :', () {
    test(
      'get id when get Restaurant Details',
      () async {
        final result = await apiService.getRestaurantById(id, http.Client());
        expect(result.id, id);
      },
    );

    test('show error when failed to get data', () async {
      final mockClientHttp = MockClient((request) async {
        final response = {};
        return http.Response(jsonEncode(response), 404);
      });
      expect(await ApiService().getRestaurantById(id, mockClientHttp),
          'Failed to get data');
    });
  });
}
