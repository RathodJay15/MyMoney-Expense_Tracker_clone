import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/services/hive_to_scv.dart';
import 'package:mymoneyclone/presentation/old_widgets/app_snackbar.dart';

class ExportScreen extends StatefulWidget {
  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  RecordsController recordsController = Get.find();

  bool isLoading = false;

  DateTime selectedFromDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime selectedToDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void _getFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedFromDate = picked;
      });
    }
  }

  void _getToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedToDate = picked;
      });
    }
  }

  void _export() async {
    setState(() {
      isLoading = true;
    });
    HiveToScv hts = HiveToScv();

    List<RecordModel> records = recordsController.getRecordsForDuration(
      selectedFromDate,
      selectedToDate,
    );

    if (records.isEmpty) {
      setState(() {
        isLoading = false;
      });
      AppSnackbar.showSnackBar(
        context,
        Iconsax.close_square,
        AppConstants.noRecordsToBeExported,
      );
      return;
    }

    await hts.exportHiveToCsv(records);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.onSurface,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        body: isLoading
            ? Container(
                height: 300,
                width: 300,
                color: Theme.of(context).colorScheme.surface,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : Container(
                height: MediaQuery.heightOf(context),
                color: Theme.of(context).colorScheme.onSurface,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(200, 30),
                          bottomRight: Radius.elliptical(200, 30),
                        ),
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              "assets/images/png_bg_rings.png",
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 35,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(
                                        Iconsax.arrow_left_copy,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        AppConstants.exportRecords,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: MediaQuery.widthOf(context) - 40,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.surface,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: _bodySection(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _bodySection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.myMoney,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_right_alt,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 10),
            Icon(
              Iconsax.document_download_copy,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                AppConstants.exportMsg,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
                speed: const Duration(milliseconds: 25),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _title(AppConstants.from),
                  SizedBox(height: 5),
                  InkWell(
                    splashColor: Theme.of(context).colorScheme.primary,
                    onTap: _getFromDate,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppHelper.getFormattedDateString(selectedFromDate),
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _title(AppConstants.to),
                  SizedBox(height: 5),
                  InkWell(
                    splashColor: Theme.of(context).colorScheme.primary,
                    onTap: _getToDate,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppHelper.getFormattedDateString(selectedToDate),
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: _export,
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppConstants.export,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
