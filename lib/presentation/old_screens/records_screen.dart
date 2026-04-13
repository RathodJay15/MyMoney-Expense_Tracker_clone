import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/presentation/old_widgets/empty_state.dart';
import 'package:mymoneyclone/presentation/old_widgets/record_detail_dialog.dart';

class RecordsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  RecordsController recordsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return _list();
  }

  Widget _list() {
    return Obx(() {
      final groupedRecordsKyes = recordsController.groupedRecords.keys.toList();

      if (groupedRecordsKyes.isEmpty) {
        return Center(
          child: EmptystateScreen.emptyState(
            icon: Iconsax.receipt_add_copy,
            title: AppConstants.emptyStateMsg,
            context: context,
          ),
        );
      }

      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: groupedRecordsKyes.length,
        itemBuilder: (context, index) {
          String groupKey = groupedRecordsKyes[index];
          List<RecordModel> records =
              recordsController.groupedRecords[groupKey]!;

          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    groupKey,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 0,
                  ),
                  _recordList(records),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _recordList(List<RecordModel> records) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: records.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Theme.of(context).colorScheme.onPrimary,
          thickness: 1,
          indent: 60,
          endIndent: 10,
          height: 4,
        );
      },
      itemBuilder: (context, index) {
        final record = records[index];
        final account = recordsController.getAccById(record.accountId);

        String title = "";
        CategoryModel? category;
        AccountModel? transferAccount;

        if (record.type == AppConstants.transfer) {
          title = AppConstants.transfer;
          transferAccount = recordsController.getAccById(
            record.transferAccountId!,
          );
        } else {
          category = recordsController.getCatById(record.categoryId!);

          title = category!.name;
        }

        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return RecordDetailDialog(record: record);
              },
            );
          },
          splashColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    record.transferAccountId == null
                        ? IconHelper.getIconsaxIcon(category!.icon)
                        : Iconsax.arrow_swap_horizontal_copy,
                    size: 30,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: AppColors.whitIcon.withAlpha(120),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Icon(
                              IconHelper.getIconsaxIcon(account!.icon),
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withAlpha(120),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 5),

                          Text(
                            account.name,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant.withAlpha(120),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          if (transferAccount != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.arrow_right_1_copy,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant.withAlpha(120),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.whitIcon.withAlpha(120),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Icon(
                                    IconHelper.getIconsaxIcon(
                                      transferAccount.icon,
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface.withAlpha(120),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 5),

                                Text(
                                  transferAccount.name,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withAlpha(120),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  AppConstants.amount(record.amount),
                  style: TextStyle(
                    color: record.type == AppConstants.transfer
                        ? Colors.blueAccent
                        : record.type == AppConstants.expense
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
