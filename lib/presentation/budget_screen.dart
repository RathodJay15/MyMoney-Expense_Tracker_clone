import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';

class BudgetScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return _list();
  }

  Widget _list() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(10),
          color: Colors.amber,
          child: _recordList(),
        );
      },
    );
  }

  Widget _recordList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.blueAccent,
          height: 20,
          margin: EdgeInsets.all(10),
        );
      },
    );
  }
}
