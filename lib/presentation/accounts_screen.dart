import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/presentation/widgets/mymoney_alertdialog.dart';

class AccountsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AccountsController accController = Get.put(AccountsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final accounts = accController.accounts;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 20),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Text(
                AppConstants.accounts,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ...accounts.map((e) => _listItem(e)),

            SizedBox(height: 20),

            Center(child: _addButton()),
          ],
        ),
      );
    });
  }

  Widget _listItem(AccountModel account) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
          border: BoxBorder.all(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(90),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary.withAlpha(50),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => displayCat(account),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: !account.isIgnored
                        ? Colors.white
                        : Colors.white.withAlpha(90),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    IconHelper.getIconsaxIcon(account.icon),
                    color: !account.isIgnored
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onPrimary.withAlpha(90),
                    size: 45,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: TextStyle(
                        color: !account.isIgnored
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant.withAlpha(90),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: !account.isIgnored
                            ? null
                            : TextDecoration.lineThrough,
                        decorationColor: !account.isIgnored
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant.withAlpha(90),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.balance,
                          style: TextStyle(
                            color: !account.isIgnored
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant.withAlpha(90),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          AppConstants.amount(account.balance),
                          style: TextStyle(
                            color: !account.isIgnored
                                ? Theme.of(context).colorScheme.onInverseSurface
                                : Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface.withAlpha(90),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                tooltip: AppConstants.options,
                icon: Icon(
                  Iconsax.more_copy,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).colorScheme.surface,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AccountDialog(
                            title: AppConstants.editAcc,
                            account: account,
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        AppConstants.edit,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      final response = await MymoneyAlertdialog.showMyDialog(
                        context: context,
                        title: AppConstants.deleteThisAcc,
                        content: AppConstants.deletingAccMsg,
                      );
                      if (response == true) {
                        await accController.deleteAccount(account);
                      }
                    },
                    child: Text(
                      AppConstants.delete,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      if (!account.isIgnored) {
                        final response = await MymoneyAlertdialog.showMyDialog(
                          context: context,
                          title: AppConstants.ingnoreThisAcc,
                          content: AppConstants.ignoreAccMsg,
                        );
                        if (response == true) {
                          account.isIgnored = true;
                          await accController.updateAccounts(account);
                        }
                      } else {
                        account.isIgnored = false;
                        await accController.updateAccounts(account);
                      }
                    },
                    child: Text(
                      !account.isIgnored
                          ? AppConstants.ignore
                          : AppConstants.restore,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return SizedBox(
      width: 230,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AccountDialog(
                title: AppConstants.addNewAcc,
                account: null,
              );
            },
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            width: 2.0,
          ),
          // Define the corner radius
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Iconsax.add_circle_copy,
                size: 25,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),

              Text(
                AppConstants.addNewAcc,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayCat(AccountModel account) {
    final list = [];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Iconsax.close_circle_copy, size: 40),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.accDetails,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppConstants.recordsAllTime,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withAlpha(180),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    IconHelper.getIconsaxIcon(account.icon),
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
                        account.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${AppConstants.balance} ${AppConstants.amount(account.balance)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (account.initialAmount != 0.00)
                        Text(
                          '${AppConstants.initialy} ${AppConstants.amount(account.initialAmount)}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withAlpha(180),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withAlpha(100),
                border: BoxBorder.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha(90),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.info_circle_copy,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 350,
                    child: Text(
                      AppConstants.analysisDialog,
                      maxLines: 2,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: list.isEmpty
                ? Text(
                    AppConstants.noRecordInThisCat,
                    textAlign:
                        TextAlign.center, // Ensures multi-line text is centered
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text('Item $index'));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AccountDialog extends StatefulWidget {
  final String title;
  final AccountModel? account;

  AccountDialog({super.key, required this.title, required this.account});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  AccountsController accController = Get.find();

  // final AccountC controller = Get.find();
  late TextEditingController nameController;
  late TextEditingController initialAmountController;
  int selectedIcon = 0;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    nameController = TextEditingController(
      text: widget.account != null
          ? widget.account!.name
          : AppConstants.untitled,
    );

    initialAmountController = TextEditingController(
      text: widget.account != null
          ? widget.account!.initialAmount.toString()
          : AppConstants.initAmountVal,
    );

    selectedIcon = widget.account != null
        ? IconHelper.catIcons.indexOf(widget.account!.icon)
        : 0;
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: widget.title == AppConstants.addNewAcc ? 16 : 0),

              /// Initial Amount Field
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.initAmountTxt,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextField(
                      controller: initialAmountController,
                      keyboardType: TextInputType.number,
                      focusNode: focusNode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Text(
                AppConstants.initAmountMsg,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha(200),
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 8),

              /// Name Field
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 265,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Icon Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.icon,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Icon Grid
              Container(
                height: 120,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: IconHelper.catIcons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedIcon = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.blueBG,
                          shape: BoxShape.circle,
                          border: selectedIcon == index
                              ? Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Icon(
                          IconHelper.getIconsaxIcon(IconHelper.catIcons[index]),
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      AppConstants.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      if (widget.account == null) {
                        accController.addAccounts(
                          AccountModel(
                            name: nameController.text,
                            balance: 0.00,
                            icon: IconHelper.catIcons[selectedIcon],
                            isIgnored: false,
                            initialAmount: double.parse(
                              initialAmountController.text,
                            ),
                          ),
                        );
                      } else {
                        final acc = widget.account!;

                        acc.name = nameController.text;
                        acc.icon = IconHelper.catIcons[selectedIcon];
                        acc.initialAmount = double.parse(
                          initialAmountController.text,
                        );
                        acc.isIgnored = false;
                        accController.updateAccounts(acc);
                      }
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      AppConstants.save,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
