// To parse this JSON data, do
//
//     final restaurantResponse = restaurantResponseFromJson(jsonString);

import 'dart:convert';

RestaurantResponse restaurantResponseFromJson(String str) => RestaurantResponse.fromJson(json.decode(str));

String restaurantResponseToJson(RestaurantResponse data) => json.encode(data.toJson());

class RestaurantResponse {
    final String id;
    final String title;
    final String time;
    final String imageUrl;
    final String owner;
    final String code;
    final bool isAvailable;
    final bool pickup;
    final bool delivery;
    final List<dynamic> foods;
    final String logoUrl;
    final int rating;
    final String ratingCount;
    final String verification;
    final String verificationMessage;
    final Coords coords;
    final double earnings;

    RestaurantResponse({
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
        required this.owner,
        required this.code,
        required this.isAvailable,
        required this.pickup,
        required this.delivery,
        required this.foods,
        required this.logoUrl,
        required this.rating,
        required this.ratingCount,
        required this.verification,
        required this.verificationMessage,
        required this.coords,
        required this.earnings,
    });

    factory RestaurantResponse.fromJson(Map<String, dynamic> json) => RestaurantResponse(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        owner: json["owner"],
        code: json["code"],
        isAvailable: json["isAvailable"],
        pickup: json["pickup"],
        delivery: json["delivery"],
        foods: List<dynamic>.from(json["foods"].map((x) => x)),
        logoUrl: json["logoUrl"],
        rating: json["rating"],
        ratingCount: json["ratingCount"],
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
        coords: Coords.fromJson(json["coords"]),
        earnings: json["earnings"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "owner": owner,
        "code": code,
        "isAvailable": isAvailable,
        "pickup": pickup,
        "delivery": delivery,
        "foods": List<dynamic>.from(foods.map((x) => x)),
        "logoUrl": logoUrl,
        "rating": rating,
        "ratingCount": ratingCount,
        "verification": verification,
        "verificationMessage": verificationMessage,
        "coords": coords.toJson(),
        "earnings": earnings,
    };
}

class Coords {
    final String id;
    final double latitude;
    final double longitude;
    final String address;
    final String title;


    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.address,
        required this.title,

    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,

    };
}
