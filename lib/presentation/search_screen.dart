import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/presentation/widgets/empty_state.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchScrrenState();
}

class SearchScrrenState extends State<SearchScreen> {
  RecordsController recordsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var searchResult = recordsController.searchResultRecords;

      if (searchResult.isEmpty) {
        return Center(
          child: EmptystateScreen.emptyState(
            icon: Iconsax.receipt_search_copy,
            title: AppConstants.searchEmptyStateMsg,
            context: context,
          ),
        );
      }
      return SizedBox();
    });
  }
}
