import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/services/accounts_hive_service.dart';
import 'package:mymoneyclone/data/services/categories_hive_service.dart';

class HiveToScv {
  AccountsHiveService accService = AccountsHiveService();
  CategoriesHiveService catService = CategoriesHiveService();

  String getCatById(int catID) {
    final category = catService.getCatById(catID);
    return category == null ? "" : category.name;
  }

  String getAccById(int accID) {
    final account = accService.getAccById(accID);
    return account == null ? "" : account.name;
  }

  Future<void> exportHiveToCsv(List<RecordModel> records) async {
    List<List<dynamic>> rows = [];

    rows.add([
      "TIME",
      "TYPE",
      "AMOUNT(IN INR)",
      "CATEGORY",
      "ACCOUNT",
      "NOTES",
    ]);

    for (var record in records) {
      String category = record.type == AppConstants.transfer
          ? "-"
          : getCatById(record.categoryId!);
      String transferAccount = record.type == AppConstants.transfer
          ? getAccById(record.transferAccountId!)
          : "";
      String account = getAccById(record.accountId);
      String accountString = record.type == AppConstants.transfer
          ? "$account -> $transferAccount"
          : account;

      final formatter = NumberFormat("#,##,##0.00", "en_IN");
      String amount = formatter.format(record.amount);

      rows.add([
        AppHelper.getFullDateTime(record.date, record.time),
        record.type,
        amount,
        category,
        accountString,
        record.note ?? "",
      ]);
    }

    // Convert to CSV String
    String csvData = const ListToCsvConverter().convert(rows);

    Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));

    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save CSV File',
      fileName: 'data_export.csv',
      bytes: bytes,
    );

    if (outputPath == null) {
      return;
    }

    debugPrint("CSV exported to $outputPath");
  }
}
