import 'package:flutter/material.dart';

enum RideStatus {
  available,
  maintenance,
  closed,
}

String getRideStatusText(RideStatus status) {
  switch (status) {
    case RideStatus.available:
      return 'ใช้งานได้';
    case RideStatus.maintenance:
      return 'ปรับปรุง';
    case RideStatus.closed:
      return 'ปิดให้บริการ';
  }
}

Color getRideStatusColor(RideStatus status) {
  switch (status) {
    case RideStatus.available:
      return Colors.green.shade700;
    case RideStatus.maintenance:
      return Colors.orange.shade800;
    case RideStatus.closed:
      return Colors.red.shade700;
  }
}