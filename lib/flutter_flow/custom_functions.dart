import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String getMapUrl(LatLng ubicacion) {
  // Add your function code here!

  return 'https://www.google.com/maps/place/${ubicacion.latitude},${ubicacion.longitude}/@${ubicacion.latitude},${ubicacion.longitude},14z';
}

int rangeDates(
  DateTime? date1,
  DateTime? date2,
) {
  // get the number of days between two dates
  if (date1 == null || date2 == null) {
    // final now = DateTime.now();
    // return rangeDates(now, now) + 1;
    return 0;
  }
  final time = date2.difference(date1);
  return time.inDays + 1;
}

String longitudLista(List<CalificacionRecord>? kalificacion) {
  // get average rating to one decimal point from a list of reviews
  if (kalificacion != null) {
    try {
      if (kalificacion.isEmpty) {
        return "N/A";
      } else {
        var total = kalificacion.map((e) => e.calificacion).reduce((a, b) {
          return a! + b!;
        });
        var totalCalif = kalificacion.length;
        var averTot = totalCalif.roundToDouble();
        return averTot.toStringAsFixed(1);
      }
    } catch (ex) {
      throw Exception('no es posible calificar esta calefaccion');
    }
  } else {
    throw Exception('Empty List of Calif');
  }
}

int sum1(
  int a1,
  int a2,
) {
  // sum 2 numbers
  return a1 + a2;
}

String aveCalif(List<CalificacionRecord>? kalificacion) {
  // get average rating to one decimal point from a list of reviews
  if (kalificacion != null) {
    try {
      if (kalificacion.isEmpty) {
        return "N/A";
      } else {
        var total = kalificacion.map((e) => e.calificacion).reduce((a, b) {
          return a! + b!;
        });
        var totalCalif = total! / kalificacion.length;
        var averTot = totalCalif.roundToDouble();
        return averTot.toStringAsFixed(1);
      }
    } catch (ex) {
      throw Exception('no es posible calificar esta calefaccion');
    }
  } else {
    throw Exception('Empty List of Calif');
  }
}

int? cantidadDias(String? categoria) {
  // if argument is A, then return 10, if argument is b, then return 20, if argument is c, then return 30
  if (categoria == 'A') {
    return 2;
  }
  if (categoria == 'B') {
    return 5;
  }
  if (categoria == 'C') {
    return 30;
  }

  if (categoria == 'D') {
    return 60;
  }
  return null;
}

double aporB(
  int dias,
  double? salarioMinimo,
) {
  // Multiplication of a integer by a double
  return dias * salarioMinimo!;
}

double? comercioPago(
  double? metros2,
  double? precioM2,
) {
  // get multiplication of 2 numbers
  if (metros2 == null || precioM2 == null) {
    return null;
  }
  return (metros2 == 0.0)
      ? 0.0
      : ((metros2 == null) ? 0.0 : precioM2 * metros2);
}

double? comercioPagoTotal(
  double? metros2,
  double? precioM2,
) {
  // get multiplication of 2 numbers
  if (metros2 == null || precioM2 == null) {
    return null;
  }
  return (metros2 == 0.0)
      ? 0.0
      : ((metros2 == null) ? 0.0 : precioM2 * metros2);
}

String checkVigencia(
  DateTime date1,
  DateTime date2,
) {
  // check if today is one year older than another date
  if (date1.compareTo(date2) >= 0) {
    return 'Al corriente';
  } else {
    int year = date1.year - date2.year;
    return 'Vencido';
  }
}

DateTime dateMinus1Year(DateTime? date1) {
  // increase one year from a date
  if (date1 == null) return DateTime.now();

  var date = new DateTime(date1.year - 1, date1.month, date1.day, 0, 0, 0);
  return date;
}

DateTime oneday(DateTime today) {
  // get today less one day
  if (today.isUtc) {
    return DateTime(today.year, today.month, today.day - 1, 0, 0, 0, 0, 0);
  }

  return DateTime.fromMillisecondsSinceEpoch(
      today.millisecondsSinceEpoch - 86400000);
}

DateTime datePlus1Year(DateTime? date1) {
  // increase one year from a date
  if (date1 == null) return DateTime.now();

  var date = new DateTime(date1.year + 1, date1.month, date1.day, 0, 0, 0);
  return date;
}

double sumPagosHoy(List<PagosDiariosRecord> pagosHoy) {
  // get sum of a list
  double suma = 0;
  for (int i = 0; i < pagosHoy.length; i++) {
    suma += pagosHoy[i].cantidad as double;
  }

  return suma;
}

double sumPagosHoyAnual(List<PagosAnualesRecord> pagosHoy) {
  // get sum of a list
  double suma = 0;
  for (int i = 0; i < pagosHoy.length; i++) {
    suma += pagosHoy[i].cantidad as double;
  }

  return suma;
}

String? getURLIpdf(String? ima) {
  // get the URL of firebase image
  if (ima == null) {
    return null;
  } else {
    return '$ima';
  }
}

String getDate(DateTime time) {
  // get day, month and year
  return "${time.day}/${time.month}/${time.year}";
}

int deudaAnios(
  DateTime date1,
  DateTime date2,
) {
  // get the number of years between 2 dates
  return DateTime.parse(date2.toString())
          .difference(DateTime.parse(date1.toString()))
          .inDays ~/
      365;
}

int deudaDias(
  DateTime date1,
  DateTime date2,
) {
  // get the number of days between 2 dates
  int days = 0;
  Duration difference = date2.difference(date1);
  days = difference.inDays;
  return days;
}

double? costoUMAxUMA(
  double costoUMA,
  double noUMAs,
) {
  // multiplication of 2 values
  return costoUMA * noUMAs;
}

double? costoxM2(
  double costo,
  double m2,
) {
  // multiplication of 2 values
  return costo * m2;
}

String? getURLImage(String? ima) {
  // get the URL of firebase image
  if (ima == null) {
    return null;
  } else {
    return '$ima';
  }
}

List<String>? getlistfilter(List<String>? lista) {
  // get the list from "lista" but not duplicated names
  if (lista == null) return null; // Return null if the input list is null
  return lista
      .toSet()
      .toList(); // Convert to a Set to remove duplicates and then back to a List
}

double? depreciacion(
  DateTime? fecha,
  double? precio,
  double? porcentaje,
) {
  if (fecha == null || precio == null || porcentaje == null) {
    return null;
  }

  final DateTime currentDate = DateTime.now();

  int yearsPassed = currentDate.year - fecha.year;
  if (currentDate.month < fecha.month ||
      (currentDate.month == fecha.month && currentDate.day < fecha.day)) {
    yearsPassed--;
  }

  double totalDepreciation = yearsPassed * porcentaje;
  double finalPrice = precio - totalDepreciation;

  return finalPrice < 0 ? 0 : finalPrice;
}

double? depreciacionmes(
  DateTime? fecha,
  double? precio,
  double? porcentaje,
) {
  if (fecha == null || precio == null || porcentaje == null) {
    return null;
  }

  final DateTime currentDate = DateTime.now();
  final Duration difference = currentDate.difference(fecha);

  // Calcular años decimales con precisión
  double yearsPassed = difference.inDays / 365.25;

  double totalDepreciation = yearsPassed * porcentaje;
  double finalPrice = precio - totalDepreciation;

  // Redondear a 2 decimales
  double roundedPrice =
      double.parse((finalPrice < 0 ? 0 : finalPrice).toStringAsFixed(2));

  return roundedPrice;
}

String? givelink(String? link) {
  if (link == null || link.isEmpty) return null;

  try {
    // Extraer la ruta dentro del bucket
    final uri = Uri.parse(link);
    final segments = uri.pathSegments;
    int oIndex = segments.indexOf('o');
    if (oIndex == -1 || oIndex + 1 >= segments.length) return null;

    // Decodificar la parte de la ruta de la imagen
    String path = Uri.decodeComponent(segments[oIndex + 1]);

    // Construir la URL del proxy
    String proxyUrl =
        'https://us-central1-inventarios-pjev.cloudfunctions.net/imageProxy?path=$path';

    return proxyUrl;
  } catch (e) {
    return null;
  }
}
