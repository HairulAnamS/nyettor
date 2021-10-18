import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const int modeBrowse = 0;
const int modeNew = 1;
const int modeEdit = 2;
const int modeDelete = 3;
const Color warna = const Color.fromARGB(255, 0, 0, 80);
final formatter =
    new NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp.');

String getBulan(DateTime aDate, bool isAddYears) {
  List bulanList = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];
  String result;
  int idxBulan = aDate.month;

  if (isAddYears){
    result = bulanList[idxBulan - 1] + ' ' + DateFormat('yyyy').format(aDate);
  }else{
    result = bulanList[idxBulan - 1];
  }
  //print('bulan lahir : ' + result);
  return result;
}

DateTime convertBulan(String aBulan) {
  DateTime result = new DateTime.now();
  int month = 1;

  String thn = aBulan.substring(aBulan.length - 4, aBulan.length);
  String bln = aBulan.substring(0, aBulan.length - 5);

  if (bln == 'Januari')
    month = 1;
  else if (bln == 'Februari')
    month = 2;
  else if (bln == 'Maret')
    month = 3;
  else if (bln == 'April')
    month = 4;
  else if (bln == 'Mei')
    month = 5;
  else if (bln == 'Juni')
    month = 6;
  else if (bln == 'Juli')
    month = 7;
  else if (bln == 'Agustus')
    month = 8;
  else if (bln == 'September')
    month = 9;
  else if (bln == 'Oktober')
    month = 10;
  else if (bln == 'November')
    month = 11;
  else if (bln == 'Desember') month = 12;

  result = DateTime(int.parse(thn), month, 1);
  print('tahun:' +
      thn +
      ' bulan:' +
      bln +
      ' month:' +
      month.toString() +
      ' result:' +
      result.toString());
  return result;
}


