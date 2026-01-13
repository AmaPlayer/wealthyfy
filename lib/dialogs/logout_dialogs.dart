import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/screens/login_screen.dart';

import '../APIs/user_data.dart';
import '../helper/textview.dart';


logoutDialogUI(BuildContext context) {
  showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return const LogOutDialog();
      });
}
class LogOutDialog extends StatefulWidget {
  const LogOutDialog({super.key});

  @override
  State<LogOutDialog> createState() => _LogOutDialogState();
}

class _LogOutDialogState extends State<LogOutDialog> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding:
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 20),
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white.withValues(alpha: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  headingText(
                      title: "Logout",
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: ColorConstants.BLACKCOLOR),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, top: 20),
                    child: headingLongText(
                        title: "Are you sure you want to logout?",
                        fontWeight: FontWeight.w500,
                        align: TextAlign.center,
                        fontSize: 15,
                        color: ColorConstants.BLACKCOLOR),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 18, left: 5, right: 5),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(80, 45),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25)))),
                          icon:  const Icon(
                            Icons.cancel,
                            color: ColorConstants.BLACKCOLOR,
                          ),
                          label: headingText(
                              title: "No",
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 18, left: 35, right: 5),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              viewLoginDetail = null;
                              setLoginModelDetail(null).whenComplete((){
                                viewLoginDetail = null;
                                iAuthorization ='';
                                setUserIsPro(false).whenComplete(()=>Get.offAll(()=>const LoginScreen()));
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(80, 45),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25)))),
                          icon: const Icon(
                            CupertinoIcons.arrow_right,
                            color: ColorConstants.BLACKCOLOR,
                          ),
                          label: headingText(
                              title: "Yes",
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ).paddingOnly(top: 25)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
