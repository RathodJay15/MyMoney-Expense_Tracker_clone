import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/presentation/add_record_screen.dart';
import 'package:mymoneyclone/presentation/widgets/mymoney_alertdialog.dart';

class RecordDetailDialog extends StatefulWidget {
  final RecordModel record;

  RecordDetailDialog({super.key, required this.record});

  @override
  State<RecordDetailDialog> createState() => _RecordDetailDialogState();
}

class _RecordDetailDialogState extends State<RecordDetailDialog> {
  RecordsController recordsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final account = recordsController.getAccById(widget.record.accountId);

    CategoryModel? category;
    AccountModel? transferAccount;

    if (widget.record.type == AppConstants.transfer) {
      transferAccount = recordsController.getAccById(
        widget.record.transferAccountId!,
      );
    } else {
      category = recordsController.getCatById(widget.record.categoryId!);
    }
    return Dialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 5),
            color: widget.record.type == AppConstants.transfer
                ? Theme.of(context).colorScheme.inversePrimary
                : widget.record.type == AppConstants.expense
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onInverseSurface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      icon: Icon(Iconsax.close_circle_copy, size: 30),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        Get.back();
                        final response = await MymoneyAlertdialog.showMyDialog(
                          context: context,
                          title: AppConstants.deleteThisRecord,
                          content: AppConstants.areYouSure,
                        );
                        if (response == true) {
                          await recordsController.deleteRecord(widget.record);
                        }
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      icon: Icon(Iconsax.trash_copy, size: 30),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                        Get.to(
                          AddRecordScreen(
                            oldRecord: widget.record,
                            title: AppConstants.updateRecord,
                          ),
                        );
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      icon: Icon(Iconsax.edit_2_copy, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    widget.record.type,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Align(
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    AppConstants.amount(widget.record.amount),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    "${AppHelper.getFormattedDateString(widget.record.date)} ${widget.record.time}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 5),
            color: Theme.of(context).colorScheme.onSurface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.record.type == AppConstants.transfer
                          ? AppConstants.from
                          : AppConstants.account,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Icon(
                              IconHelper.getIconsaxIcon(account!.icon),
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            account.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.record.type == AppConstants.transfer
                          ? AppConstants.to
                          : AppConstants.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Icon(
                              IconHelper.getIconsaxIcon(
                                widget.record.type == AppConstants.transfer
                                    ? transferAccount!.icon
                                    : category!.icon,
                              ),
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.record.type == AppConstants.transfer
                                ? transferAccount!.name
                                : category!.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.record.note == null
                        ? AppConstants.noNotes
                        : widget.record.note!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
