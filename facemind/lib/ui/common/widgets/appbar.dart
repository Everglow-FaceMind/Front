import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar(
      {super.key,
      required Widget super.title,
      super.actions,
      bool underline = true})
      : super(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          shape: underline
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                )
              : null,
        );
}
