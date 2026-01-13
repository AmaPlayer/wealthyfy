import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/userleave_apply_details.dart';
import '../helper/colors.dart';
import '../helper/imagees.dart';
import '../helper/textview.dart';


class MyLeaveDetails extends StatefulWidget {
  final String tbl_leaveid;
   MyLeaveDetails({super.key,required this.tbl_leaveid});

  @override
  State<MyLeaveDetails> createState() => _MyLeaveDetailsState();
}

class _MyLeaveDetailsState extends State<MyLeaveDetails> {

  bool isloading = true;
List<UserLeaveDetailsDatum> userleavedetails = [];
  userleavedetailsdta(){
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_user_leave_id" :widget.tbl_leaveid.toString(),
    };
    print("SUBMIT_HASH_MAP=>$hashMap");
    userLeaveApplyDetailsApi(hashMap).then((onValue){
      setState(() {
        if(onValue.status){
          UserLeaveDetailsModel mu = onValue.data;
          userleavedetails = mu.data;
          isloading = false;
          print('SUCCESS=>${userleavedetails.length}');
        }else{
          print('EXCEPTION=>${onValue.message}');
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    userleavedetailsdta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: headingText(title: 'My Leave Detail'),
      ),

      body:
      isloading
          ? const Center(child: CircularProgressIndicator(
        color: ColorConstants.DarkMahroon,
      )):
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: ColorConstants.WHITECOLOR,
                boxShadow: [
                  BoxShadow(blurRadius: 4,color: Colors.grey.shade300)
                ],
                borderRadius: BorderRadius.circular(10)
            ),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingText(title: 'Your Leave',fontWeight: FontWeight.bold,fontSize: 20),
                      headingText(title: 'Details is here !',fontWeight: FontWeight.bold,fontSize: 20),
                    ],
                  ),
                ),
                Image.asset(leaveimage,height: 130,)
              ],
            ),
          ),
          addPadding(10, 0),
           Container(
               decoration: BoxDecoration(
                 color: ColorConstants.WHITECOLOR,
                 boxShadow: [
                   BoxShadow(
                     blurRadius: 3,color: Colors.grey.shade300
                   )
                 ],
                 borderRadius: BorderRadius.circular(5)
               ),
               child: Details(),
              ),
              addPadding(15, 0),

        ],
      ),
    );
  }
Widget Details() {
  return  Container(
    padding:
    const EdgeInsets.only( bottom: 10),
    margin: const EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: ColorConstants.WHITECOLOR,
        boxShadow: [
          BoxShadow(blurRadius: 3, color: ColorConstants.GREY3COLOR)
        ],
        borderRadius: BorderRadius.circular(5)
    ),
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 0,left: 10,right: 10),
            height: 40,
            decoration: BoxDecoration(
                color: ColorConstants.GREY4COLOR,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5)
                )
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(title: userleavedetails.first.leaveApplyDate,
                    fontSize: 14,color: ColorConstants.DarkMahroon,fontWeight: FontWeight.bold),
                Container(
                    padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                    decoration: BoxDecoration(
                        color: ColorConstants.WHITECOLOR,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: headingText(title: userleavedetails.first.status.capitalizeFirst,fontSize: 14,
                        color: ColorConstants.DarkMahroon,fontWeight: FontWeight.bold)),
              ],
            )
        ),
        addPadding(15, 0),
        ListView.builder(
            padding: const EdgeInsets.only(left: 10,right: 10),
            shrinkWrap: true,
            itemCount: userleavedetails.length,
            itemBuilder: (context,index){
              var data = userleavedetails[index];
              return  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText(title: 'Leave Type',color: ColorConstants.DarkMahroon,
                          fontSize: 16,fontWeight: FontWeight.w500),
                      headingText(title: data.leaveType,color: ColorConstants.GREY5COLOR,
                          fontSize: 16,fontWeight: FontWeight.w500)
                    ],
                  ),
                  Divider(color: ColorConstants.GREY3COLOR,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText(title: 'From Date',color: ColorConstants.DarkMahroon,
                          fontSize: 16,fontWeight: FontWeight.w500),
                      headingText(title: data.fromDate,color: ColorConstants.GREY5COLOR,
                          fontSize: 16,fontWeight: FontWeight.w500)
                    ],
                  ),
                  Divider(color: ColorConstants.GREY3COLOR,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText(title: 'To Date',color: ColorConstants.DarkMahroon,
                          fontSize: 16,fontWeight: FontWeight.w500),
                      headingText(title: data.toDate,color: ColorConstants.GREY5COLOR,
                          fontSize: 16,fontWeight: FontWeight.w500)
                    ],
                  ),
                  Divider(color: ColorConstants.GREY3COLOR,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText(title: 'Leave Time',color: ColorConstants.DarkMahroon,
                          fontSize: 16,fontWeight: FontWeight.w500),
                      headingText(title: data.leaveApplyTime,color: ColorConstants.GREY5COLOR,
                          fontSize: 16,fontWeight: FontWeight.w500)
                    ],
                  ),
                  Divider(color: ColorConstants.GREY3COLOR,),
                  headingText(title: "Reason",fontSize: 18,fontWeight: FontWeight.w700,
                  color: ColorConstants.DarkMahroon),
                  headingFullText(title: data.reason,fontSize: 16,fontWeight: FontWeight.w600),

                ],
              );
            }),
        addPadding(10,0),
      ],
    ),
  );
}
}
