import 'dart:io';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wealthyfy/controller/dashboardcontroller.dart';
import 'package:wealthyfy/helper/ErrorBottomSheet.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/helper/textview.dart';
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
                physics: const BouncingScrollPhysics(),
                child: dController.profileData.isEmpty
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
            color: ColorConstants.GREYCOLOR.withValues(alpha: 0.6),
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
            color: ColorConstants.GREYCOLOR.withValues(alpha: 0.6),
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
        constraints: const BoxConstraints(minHeight: 800),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              headingText(
                  title: dController.profileData.first.fullName.capitalizeFirst.toString(),
                  color: ColorConstants.DarkMahroon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              addPadding(0, 0),
              headingText(
                  title: dController.profileData.first.designationName.capitalizeFirst.toString().toString(),
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.DarkMahroon,
                  fontSize: 18),
              addPadding(15, 0),
              _myProFile(),
              _logout(),
              _supportFaq(),
            ],
          ),
        ),
      );

  _supportFaq() => Container(
      margin: const EdgeInsets.only(top: 15, right: 6, left: 6, bottom: 10),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.WHITECOLOR,
          boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
          borderRadius: BorderRadius.circular(10)),
      child: Obx(() {
        final faqData = dController.faqData.value;
        final isLoading = dController.isFaqLoading.value;
        final supportEmail = faqData?.supportEmail ?? '';
        final supportPhone = faqData?.supportPhone ?? '';
        final faqs = faqData?.faqs ?? const [];
        final announcementData = dController.announcementData.value;
        final isAnnouncementLoading = dController.isAnnouncementLoading.value;
        final announcements =
            announcementData?.announcements ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icons.support_agent_outlined,
                      color: Colors.grey.shade700,
                    )),
                addPadding(0, 10),
                headingText(
                    title: 'Support & FAQ',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ColorConstants.GREY7COLOR),
              ],
            ),
            addPadding(6, 0),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                'Support',
                style: TextStyle(
                  color: ColorConstants.DarkMahroon,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              children: [
                if (isLoading && faqData == null)
                  _supportStatus('Loading support details...')
                else ...[
                  _supportRow('Email', supportEmail),
                  _supportRow('Phone', supportPhone),
                  if (supportEmail.isEmpty && supportPhone.isEmpty)
                    _supportStatus('Support details not available.'),
                ],
              ],
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                'FAQs',
                style: TextStyle(
                  color: ColorConstants.DarkMahroon,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              children: [
                if (isLoading && faqs.isEmpty)
                  _supportStatus('Loading FAQs...')
                else if (faqs.isEmpty)
                  _supportStatus('No FAQs available.')
                else
                  Column(
                    children: [
                      for (int i = 0; i < faqs.length; i++)
                        ExpansionTile(
                          key: PageStorageKey('faq_$i'),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.only(bottom: 6),
                          title: Text(
                            faqs[i].heading.isEmpty
                                ? 'FAQ ${i + 1}'
                                : faqs[i].heading,
                            style: TextStyle(
                              color: ColorConstants.GREY7COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                              child: Text(
                                faqs[i].body.isEmpty
                                    ? 'Details will be updated soon.'
                                    : faqs[i].body,
                                style: TextStyle(
                                  color: ColorConstants.GREY7COLOR,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                'Announcements',
                style: TextStyle(
                  color: ColorConstants.DarkMahroon,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              children: [
                if (isAnnouncementLoading && announcements.isEmpty)
                  _supportStatus('Loading announcements...')
                else if (announcements.isEmpty)
                  _supportStatus('No announcements available.')
                else
                  Column(
                    children: [
                      for (int i = 0; i < announcements.length; i++)
                        ExpansionTile(
                          key: PageStorageKey('announcement_$i'),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.only(bottom: 6),
                          title: Text(
                            announcements[i].heading.isEmpty
                                ? 'Announcement ${i + 1}'
                                : announcements[i].heading,
                            style: TextStyle(
                              color: ColorConstants.GREY7COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                              child: Text(
                                _stripHtml(announcements[i].html).isEmpty
                                    ? 'Details will be updated soon.'
                                    : _stripHtml(announcements[i].html),
                                style: TextStyle(
                                  color: ColorConstants.GREY7COLOR,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ],
        );
      }));

  Widget _supportRow(String label, String value) {
    final textValue = value.trim().isEmpty ? 'Not available' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: ColorConstants.GREY7COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
          addPadding(0, 6),
          Expanded(
            child: Text(
              textValue,
              style: TextStyle(
                color: ColorConstants.GREY7COLOR,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportStatus(String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      child: Text(
        message,
        style: TextStyle(
          color: ColorConstants.GREY6COLOR,
          fontSize: 12.5,
        ),
      ),
    );
  }

  String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
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
     // Fluttertoast.showToast(msg: response.message);
    } else {
    //  Fluttertoast.showToast(msg: response.message);
      showErrorBottomSheet(response.message);
    }
  }
}
