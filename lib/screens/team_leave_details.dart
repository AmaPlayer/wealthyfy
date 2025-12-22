import 'package:flutter/material.dart';
import 'package:meeting/APIs/Api.dart';
import 'package:meeting/APIs/user_data.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/controller/button_controller/custombuttom.dart';
import 'package:meeting/helper/textview.dart';

import '../Models/userleave_apply_details.dart';


class TeameLeaveDetails extends StatefulWidget {
  final tbl_leaveId;

  const TeameLeaveDetails({super.key, this.tbl_leaveId,});

  @override
  State<TeameLeaveDetails> createState() => _TeameLeaveDetailsState();
}

class _TeameLeaveDetailsState extends State<TeameLeaveDetails> {
  List<UserLeaveDetailsDatum> userleavedetails = [];
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
        title: headingText(title: 'Team Leave Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child:userleavedetails.isEmpty?const Center(child: CircularProgressIndicator(
          color: ColorConstants.DarkMahroon,
        ),):
        Column(
          children: [
            _leaveDetails(),
            addPadding(50, 0),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: CustomButton(text: 'Reject', onPressed: (){
                      Navigator.pop(context);
                    },color: Colors.red,),
                  ),

                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: CustomButton(text: 'Approved', onPressed: (){
                      Navigator.pop(context);
                    }),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _leaveDetails()=>  Column(
    children: [
      addPadding(15, 0),
      Container(
        decoration: const BoxDecoration(
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headingText(title: 'Leave Type :',color: ColorConstants.DarkMahroon,
                fontSize: 14,fontWeight: FontWeight.w500),
            headingText(title: userleavedetails.first.leaveType,color: ColorConstants.BLACKCOLOR,
                fontSize: 14,fontWeight: FontWeight.w500)
          ],
        ),
      ),
      addPadding(10, 0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          headingText(title: 'From Date',color: ColorConstants.DarkMahroon,
              fontSize: 14,fontWeight: FontWeight.w500),
          headingText(title: userleavedetails.first.fromDate,color: ColorConstants.BLACKCOLOR,
              fontSize: 14,fontWeight: FontWeight.w500)
        ],
      ),
      addPadding(10, 0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          headingText(title: 'To Date:',color: ColorConstants.DarkMahroon,
              fontSize: 14,fontWeight: FontWeight.w500),
          headingText(title: userleavedetails.first.toDate,color: ColorConstants.BLACKCOLOR,
              fontSize: 14,fontWeight: FontWeight.w500)
        ],
      ),
      addPadding(10, 0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          headingText(title: 'Leave Time:',color: ColorConstants.DarkMahroon,
              fontSize: 14,fontWeight: FontWeight.w500),
          headingText(title: userleavedetails.first.leaveApplyTime,color: ColorConstants.BLACKCOLOR,
              fontSize: 14,fontWeight: FontWeight.w500)
        ],
      ),
      addPadding(10, 0),
    ],
  );

userleavedetailsdta(){
  var hashMap = {
    "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
    "tbl_user_leave_id" :widget.tbl_leaveId.toString(),
  };
  print("SUBMIT_HASH_MAP=>$hashMap");
  userLeaveApplyDetailsApi(hashMap).then((onValue){
    setState(() {
      if(onValue.status){
        UserLeaveDetailsModel mu = onValue.data;
        userleavedetails = mu.data;
        print('SUCCESS=>${userleavedetails.length}');
      }else{
        print('EXCEPTION=>${onValue.message}');
      }
    });
  });
}

}

