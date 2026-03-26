import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';

class AnalysisScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Iconsax.arrow_circle_left_copy,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),

                          Text(
                            "March, 2026",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Iconsax.arrow_circle_right_copy,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.sort_copy),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryItem(
                      AppConstants.expense,
                      "₹5,738.00",
                      Theme.of(context).colorScheme.error,
                    ),
                    _summaryItem(
                      AppConstants.income,
                      "₹500.00",
                      Theme.of(context).colorScheme.onInverseSurface,
                    ),
                    _summaryItem(
                      AppConstants.total,
                      "-₹5,238.00",
                      Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(child: _list()),
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
