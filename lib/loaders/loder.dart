import 'package:flutter/cupertino.dart';
import 'package:meeting/helper/colors.dart';

import '../helper/textview.dart';

class DataNotFound extends StatelessWidget {
  final String? title;
  final Color? color;
  const DataNotFound({super.key, this.title, this.color,});

  @override
  Widget build(BuildContext context) =>Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(child: headingText(title: title??'No data found',color: color??ColorConstants.WHITECOLOR,
          fontWeight: FontWeight.w500,fontSize: 16))
    ],
  );
}