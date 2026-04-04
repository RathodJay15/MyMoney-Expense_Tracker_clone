import 'package:flutter/material.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';

class AppSnackbar {
  static void showSnackBar(BuildContext context, IconData icon, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: AppColors.black,
                    offset: Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 25,
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.widthOf(context) * 0.70,
                    child: Text(
                      text,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
