import 'dart:core';

class Product {
  int quantity;
  String name;
  String imageUrl;
  double price;
  String id;

  Product(
      {required this.name,
      required this.imageUrl,
      required this.quantity,
      required this.price,
      required this.id});
}
