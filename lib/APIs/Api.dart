import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wealthyfy/APIs/user_data.dart';
import 'package:wealthyfy/Models/attendancelist_model.dart';
import 'package:wealthyfy/Models/leavetype_model.dart';
import 'package:wealthyfy/Models/userleave_applylist_Model.dart';
import 'package:wealthyfy/Models/usermeeting_List_model.dart';
import '../Models/MyTeamListModel.dart';
import '../Models/NotificationModelList.dart';
import '../Models/TeamAttendaceModelList.dart';
import '../Models/dashboard_approvedmeeting_model.dart';
import '../Models/login_model.dart';
import 'dart:convert';
import '../Models/announcement_model.dart';
import '../Models/faq_model.dart';
import '../Models/profile_model.dart';
import '../Models/teamDesignationListModel.dart';
import '../Models/userleave_apply_details.dart';
import '../Models/usermeeting_details_model.dart';
import '../Models/yesterday_user_attendance_model.dart';
const Duration kApiTimeout = Duration(seconds: 20);

Future<http.Response> _post(Uri uri, {Map<String, String>? headers, Object? body}) {
  return http.post(uri, headers: headers, body: body).timeout(kApiTimeout);
}

Future<http.Response> _get(Uri uri, {Map<String, String>? headers}) {
  return http.get(uri, headers: headers).timeout(kApiTimeout);
}


// -------------------Base URL and endpoints ------------------------------
String BaseUrl = 'http://13.204.10.62:8112/';
// ------------------- URL and endpoints ------------------------------
String loginUrl = "${BaseUrl}user_data/user_login_api";
String profileUrl = "${BaseUrl}user_data/My_profile_APi";
String checkinUrl =  "${BaseUrl}attendance/user_check_in_API";
String checkoutUrl = "${BaseUrl}attendance/user_check_out_API";
String attendanceListUrl = "${BaseUrl}attendance/user_full_attendance_list_API";
String leaveTypeUrl = "${BaseUrl}attendance/leave_type_list_API";
String userLeaveApplyUrl = "${BaseUrl}attendance/user_leave_apply_API";
String userLeaveApplyListUrl ="${BaseUrl}attendance/user_leave_apply_list_API";
String userLeaveApplyDetailsUrl = "${BaseUrl}attendance/user_leave_apply_detail_API";
String createMeetingUrl = "${BaseUrl}meeting_data/create_meeting_api";
String userUploadImageUrl = "${BaseUrl}user_data/upload_profile_image?tbl_user_id=1&user_image";
String userMeetingListUrl = "${BaseUrl}meeting_data/user_meeting_list_api";
String userEditableMeetingListUrl = "${BaseUrl}meeting_data/user_editable_meeting_list_api";
String myTeamListUrl = "${BaseUrl}user_data/my_team_API";
String teamDesignationListUrl = "${BaseUrl}user_data/user_team_designation_list_API";
String userMeetingDetailUrl = "${BaseUrl}meeting_data/user_meeting_details_api";
String updateMeetingUrl = "${BaseUrl}meeting_data/edit_meeting_api";
String meetingRejectedApprovedUrl = "${BaseUrl}meeting_data/meeting_reject_approved_api";
String yesterdayUserAttendanceUrl  = "${BaseUrl}attendance/yesterday_user_attendance_API";
String dashboardApprovedMeetingUrl = "${BaseUrl}meeting_data/user_dashboard_approved_meeting_api";
String notificationUrl = "${BaseUrl}notification_data/notification_list_API";
String meetingCheckInUrl = "${BaseUrl}meeting_data/meeting_check_in_api";
String meetingCheckOutUrl = "${BaseUrl}meeting_data/meeting_check_out_api";
String meetingMinutesUrl = "${BaseUrl}meeting_data/meeting_minutes_api";
String meetingPermissionCheckUrl = "${BaseUrl}permission-check";
String meetingFakeCheckUrl = "${BaseUrl}meeting_data/fake_meeting_api";
String leaveApproveRejectUlr = "${BaseUrl}attendance/leave_reject_approved_API";
String teamAttendanceUlr = "${BaseUrl}attendance/my_team_full_attendance_list_API";
String faqUrl = "${BaseUrl}faqapi";
String announcementUrl = "${BaseUrl}announcementapi";

//----------------------------------------------------------------------------

Map<String, String> authHeaders() {
  final token = viewLoginDetail?.data.first.jwtToken ?? "";
  if (token.isEmpty) return {};
  return {"Authorization": "Bearer $token"};
}

Future<APIResponse> loginApi(Map<String, dynamic> hashMap) async {
  try {
    final response = await _post(Uri.parse(loginUrl), body: hashMap);
      var data = json.decode(response.body);
      print('check_data$data');
      if (data['status']) {
        LoginModel model = loginModelFromJson(response.body);
        return APIResponse(message: data['message'], status: true, data: model);
      } else {
        return APIResponse(message: data['message'], status: false);
      }
     } catch (error) {
    print('Error_in_LoginApi: $error');
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> myProfileAPI({String? bToken}) async {
  Map<String, dynamic> hasMap = {
    "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString()
  };
  try {
    final response = await _post(Uri.parse(profileUrl), body: hasMap, headers: authHeaders());
    data = jsonDecode(response.body);
     print("check profile Api response $data");
    if (data[status]) {
      MyProfileModel myModel = myProfileModelFromJson(response.body);

      return APIResponse(message: data[message], status: true, data: myModel);
    } else {
      return APIResponse(message: data[message], status: false);
    }
  } catch (error) {
    return APIResponse(message: error.toString(), status: false);
  }
}
  String defaultStartDate="",defaultEndDate="";
Future<APIResponse> attendanceApi(String startDate, String endDate, String userAttandanceStatus)async{
  final now = DateTime.now();
  DateTimeRange? dateRange;
  dateRange = DateTimeRange(
    start: now.subtract(const Duration(days: 30)),
    end: now,
  );

  defaultStartDate = DateFormat('yyyy-MM-dd').format(dateRange.start);
  defaultEndDate = DateFormat('yyyy-MM-dd').format(dateRange.end);
  print("$defaultStartDate - $defaultEndDate");

//by default 30days data will be show

  Map<String, dynamic> hashmap = {
    "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
    "from_date":startDate==""?defaultStartDate:startDate,
    "to_date":endDate==""?defaultEndDate:endDate,
    "status":userAttandanceStatus,
  };
  print("check my attandance $hashmap");
  try {
    final response = await _post(Uri.parse(attendanceListUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print("attendanceApi data $data");
    if (data["status"]) {
      AttendanceListModel model = attendanceListModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data:model );
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    print("attendanceApi error$error");
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> leaveTypeApi()async{
  try {
    final response = await _get(Uri.parse(leaveTypeUrl), headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      LeaveTypeModel model = leaveTypeModelFromJson(response.body,);
      return APIResponse(message: data["message"], status: true,data: model );
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> userLeaveApplyApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(userLeaveApplyUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print('check_data$data');
    if (data["status"]) {
      return APIResponse(message: data["message"], status: true,);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    print('check error $error');
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> userLeaveApplyListApi(Map<String,dynamic>hashmap)async{

  try {
    final response = await _post(Uri.parse(userLeaveApplyListUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      UserLeaveApplyListModel model = userLeaveApplyListModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data:model );
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> userLeaveApplyDetailsApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(userLeaveApplyDetailsUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      UserLeaveDetailsModel model = userLeaveAppDetailsModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data:model);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> createMeetingApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(createMeetingUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      return APIResponse(message: data["message"], status: true,);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> updateProfileImgApi(String userImg) async {
  var hasMap = {
    "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString()
  };
  try {
    final res = http.MultipartRequest('POST', Uri.parse(userUploadImageUrl));
    res.fields.addAll(hasMap);
    res.headers.addAll(authHeaders());
    String userImgExtension = userImg.toString().split('.').last;
    res.files.add(await http.MultipartFile.fromPath('user_image', userImg,contentType: MediaType('image', userImgExtension)));
    var sendRequest = await res.send();
    var convertByte = await sendRequest.stream.toBytes();
    var getResponse = String.fromCharCodes(convertByte);
    data = jsonDecode(getResponse);
    if (data[status]) {
      return APIResponse(message: data[message], status: true);
    } else {
      return APIResponse(message: data[message], status: false);
    }
  } catch (error) {
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> faqApi() async {
  try {
    final response = await _get(Uri.parse(faqUrl), headers: authHeaders());
    final raw = jsonDecode(response.body);
    if (raw[status]) {
      FaqModel model = FaqModel.fromApi(Map<String, dynamic>.from(raw));
      return APIResponse(message: raw[message], status: true, data: model);
    } else {
      return APIResponse(message: raw[message], status: false);
    }
  } catch (error) {
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> announcementApi() async {
  try {
    final response = await _get(Uri.parse(announcementUrl), headers: authHeaders());
    final raw = jsonDecode(response.body);
    if (raw[status]) {
      AnnouncementModel model =
          AnnouncementModel.fromApi(Map<String, dynamic>.from(raw));
      return APIResponse(message: raw[message], status: true, data: model);
    } else {
      return APIResponse(message: raw[message], status: false);
    }
  } catch (error) {
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> createMeetingListApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(userMeetingListUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print("checkk,   $data");
    if (data["status"]) {
      UserMeetingListModel model =userMeetingListModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    print("checkk,   $error");
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> editableMeetingListApi(Map<String, dynamic> hashmap) async {
  try {
    final response = await _post(Uri.parse(userEditableMeetingListUrl), body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      UserMeetingListModel model = userMeetingListModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true, data: model);
    } else {
      return APIResponse(message: data["message"], status: false);
    }
  } catch (error) {
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> myTeamListApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(myTeamListUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print("check down line here$data");
    if (data["status"]) {
      MyTeamListModel model =myTeamListModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> teamDesignationListUrlApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(teamDesignationListUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      TeamDesignationListModel model =teamDesignationListModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> userMeetingDetailsApi( Map<String, dynamic> hashmap)async{
  try {
    final response = await _post(Uri.parse(userMeetingDetailUrl), body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      UserMeetingDetailsModel model = userMeetingDetailsModelFromJson(response.body);
      return APIResponse(message: data["message"], status: true,data:model);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  }  catch (error){
    print("check api response$error");
    return APIResponse(message:  error.toString(), status: false);
  }
}

Future<APIResponse> updateMeetingApi(Map<String,dynamic>hashmap)async{
  try{
    final response = await _post(Uri.parse(updateMeetingUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if(data["status"]) {
      return APIResponse(message: data["message"], status: true);
    }else {
      return APIResponse(message: data["message"], status: false);
    }
  }catch (error){
    print("check update api$error");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> meetingApprovedRejectedApi(Map<String,dynamic>hashmap)async{
  try{
    final response = await _post(Uri.parse(meetingRejectedApprovedUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print('CHECK_APPROVED_API$data');
    if(data["status"]) {
      return APIResponse(message: data["message"], status: true);
    }else {
      return APIResponse(message: data["message"], status: false);
    }
  }catch (error){
    print("check_APPROVED_REJECTED_API$error");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse>  yesterdayUserAttendanceApi(Map<String,dynamic>hashmap)async{
  try{
    final response = await _post(Uri.parse(yesterdayUserAttendanceUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if(data["status"]){
      YesterdayUserAttendanceModel model = yesterdayUserAttendanceModelFromJson (response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    }else{
      return APIResponse(message: data["message"], status: false);
    }
  }catch(error){
    print("CHECK_YESTERDAY_API$error");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> dashboardApprovedMeetingApi(Map<String,dynamic>hashmap)async{
  try{
    final response = await _post(Uri.parse(dashboardApprovedMeetingUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if(data["status"]){
      DashboardApprovedMeetingModel model = dashboardApprovedMeetingModelFromJson (response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    }else{
      return APIResponse(message: data["message"], status: false);
    }
  }catch(error){
    print("CHECK_DASHBOARD_APPROVED_MEETING");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> notificationUrlApi(Map<String,dynamic>hashmap)async{
  try{
    final response = await _post(Uri.parse(notificationUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if(data["status"]){
      NotificationModelList model = notificationModelListFromJson (response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    }else{
      return APIResponse(message: data["message"], status: false);
    }
  }catch(error){
    print("CHECK_DASHBOARD_APPROVED_MEETING");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> meetingCheckInApi (Map<String,dynamic>hashmap)async{
  try{
    final response = await _post(Uri.parse(meetingCheckInUrl),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print('CHECK_DATA$data');
    if(data["status"]){
      return APIResponse(message: data["message"], status: true);
    }else{
      return APIResponse(message: data["message"], status:false);
    }
  }catch(error){
    print(("CHECK_IN_MEETING"));
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> meetingCheckOutApi(Map<String, dynamic> hashmap) async {
  try {
    final response = await _post(Uri.parse(meetingCheckOutUrl), body: hashmap, headers: authHeaders());
    final data = jsonDecode(response.body);
    if (data["status"]) {
      return APIResponse(message: data["message"], status: true);
    } else {
      return APIResponse(message: data["message"], status: false);
    }
  } catch (error) {
    print("CHECK_OUT_MEETING");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> meetingMinutesApi(Map<String, dynamic> hashmap) async {
  try {
    final response = await _post(Uri.parse(meetingMinutesUrl), body: hashmap, headers: authHeaders());
    final data = jsonDecode(response.body);
    if (data["status"]) {
      return APIResponse(message: data["message"], status: true);
    } else {
      return APIResponse(message: data["message"], status: false);
    }
  } catch (error) {
    print("MEETING_MINUTES");
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> meetingPermissionCheckApi(Map<String, dynamic> hashMap) async {
  try {
    final response =
        await _post(Uri.parse(meetingPermissionCheckUrl), body: hashMap, headers: authHeaders());
    final data = jsonDecode(response.body);
    return APIResponse(
      message: data["message"] ?? "",
      status: data["status"] == true,
    );
  } catch (error) {
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> meetingFakeCheckApi(Map<String, dynamic> payload) async {
  try {
    final response = await _post(
      Uri.parse(meetingFakeCheckUrl),
      headers: {
        "Content-Type": "application/json",
        ...authHeaders(),
      },
      body: jsonEncode(payload),
    );

    print("FAKE_MEETING statusCode: ${response.statusCode}");
    print("FAKE_MEETING raw: ${response.body}");

    final data = jsonDecode(response.body);

    return APIResponse(
      message: data["message"]?.toString() ?? "No message",
      status: data["status"] == true,
    );
  } catch (error) {
    print("CHECK_FAKE_MEETING error: $error");
    return APIResponse(message: error.toString(), status: false);
  }
}


Future <APIResponse> leaveApproveRejectApi (Map<String,dynamic>hashmap)async{
  try{
    final  response = await _post(Uri.parse(leaveApproveRejectUlr),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print(('CHECK_LEAVE_REJECT$data'));
    if(data["status"]){
      return APIResponse(message: data["message"], status: true);
    }else{
      return APIResponse(message: data["message"], status:false);
    }
  }catch(error){
    print('check_error$error');
    return APIResponse(message: error.toString(), status: false);
  }
}

Future <APIResponse> teamAttendanceUlrApi (Map<String,dynamic>hashmap)async{
  try{
    final  response = await _post(Uri.parse(teamAttendanceUlr),body: hashmap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print(('teamAttendance $data'));
    if(data["status"]){
      TeamAttendaceModelList model=teamAttendaceModelListFromJson (response.body);
      return APIResponse(message: data["message"], status: true,data: model);
    }else{
      return APIResponse(message: data["message"], status:false);
    }
  }catch(error){
    print('check_error$error');
    return APIResponse(message: error.toString(), status: false);
  }
}

Future<APIResponse> checkinAPI(Map<String, dynamic> hashMap) async {

  try {
    final response = await _post(Uri.parse(checkinUrl),body: hashMap, headers: authHeaders());
    var data = jsonDecode(response.body);
    if (data["status"]) {
      final responseData = json.decode(response.body);
      return APIResponse(message: responseData['message'], status: true);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  } catch (error){
    print('EXCEPTION_CHECK_OUT=>$error');
    return APIResponse(message:  error.toString(), status: false);
  }
}
Future<APIResponse> checkoutAPI(Map<String, dynamic> hashMap) async {
  try {
    final response = await _post(Uri.parse(checkoutUrl),body: hashMap, headers: authHeaders());
    var data = jsonDecode(response.body);
    print('CHECK_OUT_API$data');
    if (data["status"]) {
      final responseData = json.decode(response.body);
      return APIResponse(message: responseData['message'], status: true);
    } else {
      return APIResponse(message:  data["message"], status: false);
    }
  } catch (error){
    print('EXCEPTION=>$error');
    return APIResponse(message:  error.toString(), status: false);

  }
}

String kGoogleApiKey = "AIzaSyDNcThqjjV50vmTfe_-CBITHjEL8coIwKE";
String? userCity;
String? userState;
String? userArea;
String? userLat;
String? userLng;
String? userFullAddress;

Future<void> fetchPlaceDetails(String placeId) async {
  final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final detail = await places.getDetailsByPlaceId(placeId);

  if (detail.isOkay) {
    final place = detail.result;
    userLat = "${place.geometry?.location.lat}";
    userLng = "${place.geometry?.location.lng}";

    // print("Place Name: ${place.name}");
    // print("Formatted Address: ${place.formattedAddress}");
    // print("Formatted Address: ${place.geometry?.location.lat}");
    // print("Formatted Address: ${place.geometry?.location.lng}");

    for (var component in place.addressComponents) {
      for (var type in component.types) {
        if (type == 'locality') {
          userCity = component.longName;
        } else if (type == 'administrative_area_level_1') {
          userState = component.shortName;
        } else if (type == 'sublocality_level_1') {
          userArea = component.longName;
        }
      }
    }

    // Print extracted components
    print("City: $userCity");
    print("State: $userState");
    print("Area: $userArea");

    // Optionally set the text field with the full formatted address
    userFullAddress = place.formattedAddress!;
  } else {
    print("Error fetching place details: ${detail.errorMessage}");
  }
}
//---------------------------------------------------------

late Map data;
String status = "status";
String message = "message";
String authorization = "Authorization";
// APIResponse

class APIResponse {
  dynamic data;
  String message;
  bool status;

  APIResponse({required this.message, required this.status, this.data});
}
