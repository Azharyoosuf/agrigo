import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  //final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    //required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/cucumber.jpg",
      
    ],
    // colors: [
    //   const Color(0xFFF6625E),
    //   const Color(0xFF836DB8),
    //   const Color(0xFFDECB9C),
    //   Colors.white,
    // ],
    title:"CUCUMBER 50 KG",
    price: 1300.00,
    description: description1,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/images/drumstick.jpg",
    ],
    // colors: [
    //   const Color(0xFFF6625E),
    //   const Color(0xFF836DB8),
    //   const Color(0xFFDECB9C),
    //   Colors.white,
    // ],
    title: "Fresh DRUMSTICKS ",
    price: 50.5,
    description: description2,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/images/tomato.jpg",
    ],
    // colors: [
    //   const Color(0xFFF6625E),
    //   const Color(0xFF836DB8),
    //   const Color(0xFFDECB9C),
    //   Colors.white,
    // ],
    title: "Farm fresh Tomato",
    price: 36.55,
    description: description3,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/images/potato.jpg",
    ],
    // colors: [
    //   const Color(0xFFF6625E),
    //   const Color(0xFF836DB8),
    //   const Color(0xFFDECB9C),
    //   Colors.white,
    // ],
    title: "Homely produced Potato",
    price: 45.20,
    description: description4,
    rating: 4.1,
    isFavourite: true,
  ),
  
];

const String description1 =
    "Naturally grown, crisp, and refreshing—farm-fresh goodness delivered to your home!";
const String description2 =
    "Naturally grown, nutrient-rich, and perfect for your healthy recipes—farm-fresh to your home!";
const String description3 =
    "Naturally grown, chemical-free, and packed with flavor—farm-fresh goodness straight to your home!";
const String description4 =
    "Naturally grown, hearty, and versatile—farm-fresh quality for your kitchen!";