import 'package:flutter/material.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/helper/textview.dart';

import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/NotificationModelList.dart';

class NotificationSreen extends StatefulWidget {
  const NotificationSreen({super.key});

  @override
  State<NotificationSreen> createState() => _NotificationSreenState();
}

class _NotificationSreenState extends State<NotificationSreen> {

List<notificationDatum>nList=<notificationDatum>[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: headingText(title: 'Notification'),
      ),
      body: SingleChildScrollView(
        child:nList.isEmpty?Center(child: CircularProgressIndicator(color: ColorConstants.DarkMahroon,)): Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: nList.length,

              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 5, top: 0, bottom: 5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: ColorConstants.WHITECOLOR,
                        boxShadow: const [
                          BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            addPadding(10, 0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                nList[index].userImage,
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                              ),
                            ),
                            addPadding(10, 0),
                            headingText(title: nList[index].createdDay),
                            headingText(title: nList[index].createdTime),
                            addPadding(5, 0),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 20),
                            width: 1,
                            color: ColorConstants.DarkMahroon,
                            height: 70),

                        addPadding(0, 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headingText(title: nList[index].title,fontWeight: FontWeight.bold),
                            SizedBox(
                              width: 212,
                              child: headingLongText(
                                  title: nList[index].description),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getNotificationData();
    super.initState();
  }

  void getNotificationData() {
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "pagesize": "150",
      "pagenumber": "1"
    };
    print("NotificationY_MAP=>$hashMap");

    notificationUrlApi(hashMap).then((onValue) {
     setState(() {
       if (onValue.status) {

         NotificationModelList model = onValue.data;
         nList = model.data;
         print('EXCEPTION=>${nList.length}');
       } else {

         print('EXCEPTION=>${onValue.message}');
       }
     });
    });
  }
}
