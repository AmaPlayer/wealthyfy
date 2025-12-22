import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeting/helper/textview.dart';

showErrorBottomSheet(String title) {
  Get.bottomSheet(SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                addPadding(0, 10),
                Row(
                  children: [
                    addPadding(20, 0),
                    const SizedBox(
                        width: 30,
                        child: Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 25,
                        )),
                    addPadding(10, 0),
                    Expanded(
                        child: headingFullText(
                            title: "Oh! $title",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.white,
                            align: TextAlign.start)),
                    addPadding(50, 0),
                  ],
                ),
                addPadding(0, 10),
              ],
            ),
          ),
        ],
      ),
    ),
  ));
}

showSuccessBottomSheet(String title) {
  Get.bottomSheet(Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              addPadding(0, 10),
              Row(
                children: [
                  addPadding(20, 0),
                  const SizedBox(
                      width: 30,
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 25,
                      )),
                  addPadding(10, 0),
                  Expanded(
                      child: headingFullText(
                          title: "Yes! $title",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.white,
                          align: TextAlign.start)),
                  addPadding(50, 0),
                ],
              ),
              addPadding(0, 10),
            ],
          ),
        ),
      ],
    ),
  ));
}