import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/presentation/widgets/record_detail_dialog.dart';
import 'package:mymoneyclone/presentation/widgets/empty_state.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchScrrenState();
}

class SearchScrrenState extends State<SearchScreen> {
  RecordsController recordsController = Get.find();

  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  Timer? _debounce;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 300), () {
      recordsController.searchRecords(query);
    });
  }

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    recordsController.clearSearch();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.onSurface,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.heightOf(context),
          width: MediaQuery.widthOf(context),
          color: Theme.of(context).colorScheme.onSurface,
          child: Stack(
            children: [
              _customAppbar(),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.heightOf(context) * 0.88,
                  width: MediaQuery.widthOf(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _searchResultSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customAppbar() {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 30),
          bottomRight: Radius.elliptical(200, 30),
        ),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(
              "assets/images/png_bg_rings.png",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: SizedBox(
              height: 50,
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Theme.of(context).colorScheme.onSurface,
                    selectionColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(80),
                    selectionHandleColor: Theme.of(
                      context,
                    ).colorScheme.onSurface,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  focusNode: focusNode,
                  onChanged: (value) {
                    recordsController.searchRecords(value);
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 22),
                    hint: Text(
                      AppConstants.searchForRecords,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchResultSection() {
    return Obx(() {
      var searchResult = recordsController.searchResultRecords;
      if (searchResult.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: EmptystateScreen.emptyState(
                icon: Iconsax.receipt_search_copy,
                title: AppConstants.searchEmptyStateMsg,
                context: context,
              ),
            ),
            Flexible(flex: 2, child: SizedBox()),
          ],
        );
      }
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: searchResult.length,
        itemBuilder: (context, index) {
          final record = searchResult[index];
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

          return Material(
            color: Colors.transparent,
            child: InkWell(
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
              ).colorScheme.onPrimary.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        record.transferAccountId == null
                            ? IconHelper.getIconsaxIcon(category!.icon)
                            : Iconsax.arrow_swap_horizontal_copy,
                        color: Theme.of(context).colorScheme.onPrimary,
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
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                IconHelper.getIconsaxIcon(account!.icon),
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20,
                              ),
                              SizedBox(width: 5),

                              Text(
                                account.name,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
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
                                      ).colorScheme.onPrimary,
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      IconHelper.getIconsaxIcon(
                                        transferAccount.icon,
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),

                                    Text(
                                      transferAccount.name,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          if (record.note!.isNotEmpty)
                            Text(
                              record.note!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      AppConstants.amount(record.amount),
                      style: TextStyle(
                        color: record.type == AppConstants.transfer
                            ? Theme.of(context).colorScheme.inversePrimary
                            : record.type == AppConstants.expense
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onInverseSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
