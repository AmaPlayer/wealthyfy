import 'dart:io';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting/controller/dashboardcontroller.dart';
import 'package:meeting/helper/ErrorBottomSheet.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/helper/textview.dart';
import '../APIs/Api.dart';
import '../dialogs/logout_dialogs.dart';
import '../loaders/loder.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    setState(() {
      dController.initiateProfileApi();
    });
  }

  File? _image;
  DashboardController dController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, other) {
        if (dController.selectedIndex.value != 0) {
          dController.selectedIndex.value = 0;
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstants.DarkMahroon,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: headingText(
            title: 'Profile',
          ),
        ),
        body: dController.profileData.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.DarkMahroon,
                ),
              )
            : SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: dController.profileData.value.isEmpty
                    ? const DataNotFound(
                        color: Colors.black,
                      )
                    : Column(
                        children: [
                          Stack(
                            children: [
                              _location(),
                              _proFileImages(),
                            ],
                          ),
                        ],
                      ).paddingOnly(top: 20),
              ),
      ),
    );
  }

  _myProFile() => Container(
      margin: const EdgeInsets.only(top: 15, right: 6, left: 6),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.WHITECOLOR,
          boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: ColorConstants.WHITECOLOR,
                      boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
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
          addPadding(5, 0),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
            height: 1,
            width: double.infinity,
            color: ColorConstants.GREYCOLOR.withOpacity(0.6),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorConstants.WHITECOLOR,
                    boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.phone,
                  size: 22,
                  color: ColorConstants.GREY7COLOR,
                ).paddingAll(2),
              ),
              addPadding(0, 10),
              headingText(
                  title: dController.profileData.first.mobile,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.GREY7COLOR)
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
            height: 1,
            width: double.infinity,
            color: ColorConstants.GREYCOLOR.withOpacity(0.6),
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
                          boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.backup_table_outlined,
                        color: ColorConstants.GREY7COLOR,
                      )),
                  addPadding(0, 10),
                  headingText(
                      title: dController.profileData.first.designationName.capitalizeFirst.toString(),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ColorConstants.GREY7COLOR),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
            height: 1,
            width: double.infinity,
            color: ColorConstants.GREYCOLOR,
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
                          boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
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
            ],
          )
        ],
      ));

  _logout() => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => logoutDialogUI(context),
        child: Container(
            margin: const EdgeInsets.only(top: 15, right: 6, left: 6, bottom: 0),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorConstants.WHITECOLOR,
                boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
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
                                boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.logout,
                              color: ColorConstants.GREY7COLOR,
                            )),
                        addPadding(0, 10),
                        headingText(
                            title: 'Log Out',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: ColorConstants.GREY7COLOR),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: ColorConstants.GREY5COLOR,
                    )
                  ],
                ),
              ],
            )),
      );

  _proFileImages() => InkWell(
        onTap: _pickImageFromGallery,
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(blurRadius: 2, color: ColorConstants.GREYCOLOR),
                  ],
                  color: ColorConstants.WHITECOLOR,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : FancyShimmerImage(
                            imageUrl: dController.profileData.first.userImage.toString(),
                            boxFit: BoxFit.cover,
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
        ),
      );

  _location() => Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          color: ColorConstants.WHITECOLOR,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        width: double.infinity,
        height: 800,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              headingText(
                  title: dController.profileData.value.first.fullName.capitalizeFirst.toString(),
                  color: ColorConstants.DarkMahroon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              addPadding(0, 0),
              headingText(
                  title: dController.profileData.value.first.designationName.capitalizeFirst.toString().toString(),
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.DarkMahroon,
                  fontSize: 18),
              addPadding(15, 0),
              _myProFile(),
              _logout(),
            ],
          ),
        ),
      );

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
     // Fluttertoast.showToast(msg: response.message);
    } else {
    //  Fluttertoast.showToast(msg: response.message);
      showErrorBottomSheet(response.message);
    }
  }
}
