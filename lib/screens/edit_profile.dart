
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wealthyfy/APIs/Api.dart';
import 'package:wealthyfy/controller/dashboardcontroller.dart';
import 'package:wealthyfy/helper/ErrorBottomSheet.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/helper/textview.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

DashboardController dController = Get.find<DashboardController>();

  File? _image;

@override
void initState() {
  super.initState();
  setState(() {
    updateProfileImgApi;
    dController.initiateProfileApi();
  });
}
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print("opppppp=>${_image!.path}");
        _uploadImage();

      });
    }
  }
  Future<void> _uploadImage() async {
      APIResponse response = await updateProfileImgApi(_image!.path.toString());
      if (response.status) {
        dController.initiateProfileApi();
        showSuccessBottomSheet(response.message);
      //  Fluttertoast.showToast(msg: response.message);
      } else {
        showErrorBottomSheet(response.message);
        //Fluttertoast.showToast(msg: response.message);
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.DarkMahroon,
      appBar: AppBar(

        actions: [
          addPadding(0, 20)
        ],
        centerTitle: true,
        title: headingText(
          title: 'Edit Profile',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _edit(),
          ],
        ),
      ),
    );
  }
  _edit()=> Stack(
    children: [
      Container(
        padding:  const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.only(top: 50),
        decoration:   const BoxDecoration(
          color: ColorConstants.WHITECOLOR,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)),
        ),
        width: double.infinity,
        child: Padding(
          padding:  EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                headingText(
                    title: dController.profileData.first.fullName.capitalizeFirst.toString(),
                    color: ColorConstants.DarkMahroon,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                addPadding(5, 0),
                headingText(
                    title: dController.profileData.first.designationName.capitalizeFirst.toString(),
                    color: ColorConstants.GREY8COLOR,
                    fontSize: 17),
                addPadding(15, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         const Icon(
                          Icons.location_on,
                          color: ColorConstants.GREENCOLOR,
                        ),
                        addPadding(0, 10),
                        headingText(
                            title: 'Noida, Sector 62',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.GREYCOLOR),
                      ],
                    ),
                    Row(
                      children: [
                         const Icon(
                          Icons.phone,
                          color: ColorConstants.GREENCOLOR,
                        ),
                        addPadding(0, 10),
                        headingText(
                            title: '2559783525  ',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.GREYCOLOR)
                      ],
                    ),
                  ],
                ),
            Container(
                margin: const EdgeInsets.only(top: 15, right: 6, left: 6),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [
                      BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITECOLOR,
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1, color: ColorConstants.GREYCOLOR)
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade700,
                                )),
                            addPadding(0, 10),
                            headingText(
                                title: dController.profileData.first.email,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ColorConstants.GREY7COLOR),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: ColorConstants.GREY7COLOR,
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
                      height: 1,
                      width: double.infinity,
                      color: ColorConstants.GREY2COLOR,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITECOLOR,
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1, color: ColorConstants.GREYCOLOR)
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.lock_open,
                                  color: ColorConstants.GREY7COLOR,
                                )),
                            addPadding(0, 10),
                            headingText(
                                title: 'Change Password',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ColorConstants.GREY7COLOR),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: ColorConstants.GREY7COLOR,
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
                      height: 1,
                      width: double.infinity,
                      color: ColorConstants.GREY2COLOR,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITECOLOR,
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1, color: ColorConstants.GREYCOLOR)
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.backup_table_outlined,
                                  color: ColorConstants.GREY7COLOR,
                                )),
                            addPadding(0, 10),
                            headingText(
                                title:
                                dController.profileData.first.designationName.capitalizeFirst.toString(),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ColorConstants.GREY7COLOR),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: ColorConstants.GREY7COLOR,
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
                      height: 1,
                      width: double.infinity,
                      color: ColorConstants.GREY2COLOR,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITECOLOR,
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1, color: ColorConstants.GREYCOLOR)
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  color: ColorConstants.GREY7COLOR,
                                )),
                            addPadding(0, 10),
                            headingText(
                                title: dController.profileData.first.createdDate,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ColorConstants.GREY7COLOR),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: ColorConstants.GREY7COLOR,
                        )
                      ],
                    )
                  ],
                )),

              ],
            ),
          ),
        ),
      ),
      Center(
        child: InkWell(
          onTap: _pickImageFromGallery,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 85,
            width: 85,
            decoration: BoxDecoration(
              boxShadow:  const [
                BoxShadow(blurRadius: 2, color: ColorConstants.GREYCOLOR),
              ],
              color: ColorConstants.WHITECOLOR,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: _image != null
                    ? Image.file(
                  _image!,
                  fit: BoxFit.cover,
                )
                    : FancyShimmerImage(
                      imageUrl:   dController.profileData.first.userImage.toString(),
                   boxFit: BoxFit.cover,

                    ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 70, left: 50),
        child: Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: ColorConstants.WHITECOLOR,
                  boxShadow: const [BoxShadow(blurRadius: 2)],
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
              ),
            )),
      )
    ],
  );
}
