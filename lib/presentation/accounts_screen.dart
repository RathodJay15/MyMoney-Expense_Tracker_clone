import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';

class AccountsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return _recordList();
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
