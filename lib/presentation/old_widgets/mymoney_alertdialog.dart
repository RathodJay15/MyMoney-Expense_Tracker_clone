import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';

class MymoneyAlertdialog {
  static Future<bool?> showMyDialog({
    required BuildContext context,
    String title = 'Confirm',
    String content = 'Are you sure?',
    String actionN = AppConstants.no,
    String actionY = AppConstants.yes,
    Color? actionNColor,
    Color? actionYColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      actionN,
                      style: TextStyle(
                        color:
                            actionNColor ??
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => Get.back(result: true),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      actionY,
                      style: TextStyle(
                        color:
                            actionYColor ??
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
