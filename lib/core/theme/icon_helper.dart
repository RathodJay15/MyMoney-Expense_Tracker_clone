import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';

class IconHelper {
  static IconData getIconsaxIcon(String iconName) {
    switch (iconName) {
      // ===== INCOME =====
      case "award":
        return Iconsax.award;
      case "ticket_discount":
        return Iconsax.ticket_discount;
      case "gift":
        return Iconsax.gift;
      case "ticket_star":
        return Iconsax.ticket_star;
      case "money_recive":
        return Iconsax.money_recive;
      case "home_2":
        return Iconsax.home_2;
      case "wallet_3":
        return Iconsax.wallet_3;
      case "tag":
        return Iconsax.tag;

      // ===== EXPENSE =====
      case "happyemoji":
        return Iconsax.happyemoji;
      case "brush_2":
        return Iconsax.brush_2;
      case "receipt_item":
        return Iconsax.receipt_item;
      case "car":
        return Iconsax.car;

      case "shop":
        return Iconsax.shop;
      case "teacher":
        return Iconsax.teacher;
      case "device_message":
        return Iconsax.device_message;
      case "video_play":
        return Iconsax.video_play;
      case "milk":
        return Iconsax.milk;
      case "heart":
        return Iconsax.heart;
      case "home":
        return Iconsax.home;
      case "security_safe":
        return Iconsax.security_safe;
      case "shopping_cart":
        return Iconsax.shopping_cart;
      case "people":
        return Iconsax.people;
      case "cup":
        return Iconsax.cup;
      case "receipt_edit":
        return Iconsax.receipt_edit;
      case "call":
        return Iconsax.call;
      case "bus":
        return Iconsax.bus;

      default:
        return Iconsax.category;
    }
  }

  static List<String> icons = [
    "award",
    "ticket_discount",
    "gift",
    "ticket_star",
    "money_recive",
    "home_2",
    "wallet_3",
    "tag",
    "happyemoji",
    "brush_2",
    "receipt_item",
    "car",
    "shop",
    "teacher",
    'device_message',
    "video_play",
    "milk",
    "heart",
    "home",
    "security_safe",
    "shopping_cart",
    "people",
    "cup",
    "receipt_edit",
    "call",
    "bus",
  ];
}
