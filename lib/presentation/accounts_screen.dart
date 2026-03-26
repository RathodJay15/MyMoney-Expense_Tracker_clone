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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 40,
          snap: true,
          floating: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),

          title: Text(
            AppConstants.myMoney,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          actions: [
            Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 10),
          ],
        ),
        SliverAppBar(
          toolbarHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
            width: double.infinity,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppConstants.allAccounts(10000),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryItem(
                      AppConstants.expenseSoFar,
                      "₹5,738.00",
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),

                    _summaryItem(
                      AppConstants.incomeSoFar,
                      "-₹5,238.00",
                      Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(child: _recordList()),
      ],
    );
  }

  Widget _summaryItem(String title, String amount, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
