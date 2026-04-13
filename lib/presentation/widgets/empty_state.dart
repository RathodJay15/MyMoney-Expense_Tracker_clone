import 'package:flutter/material.dart';

class EmptystateScreen {
  static Widget emptyState({required icon, required title, required context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.surface, size: 60),
        SizedBox(height: 15),
        SizedBox(
          width: 300,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
