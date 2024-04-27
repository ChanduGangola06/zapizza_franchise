import 'package:flutter/material.dart';
import 'package:zapizza/models/api_error.dart';
import 'package:zapizza/models/orders_model.dart';

class FetchOrders {
  final List<OrdersModel>? data;
  final bool isLoading;
  final ApiError? error;
  final VoidCallback refetch;

  FetchOrders({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch,
  });
}
