import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meeting/APIs/Api.dart';
import 'package:meeting/APIs/user_data.dart'; // Assuming viewLoginDetail is from here
import 'package:get/get.dart'; // Assuming GetX is used for navigation or context if needed
import 'package:geocoding/geocoding.dart';
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    try {
      // Initialize position immediately after try block
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String currentLat = position.latitude.toString();
      String currentLng = position.longitude.toString();
      String currentFullAddress = "Unknown Address";

      final String? meetingId = inputData?['meeting_id'];
      final String? userId = inputData?['tbl_user_id'];
      final String? initialCheckInTimestampStr = inputData?['initial_check_in_timestamp'];

      if (meetingId == null || userId == null || initialCheckInTimestampStr == null) {
        print("Error: Missing meeting_id, tbl_user_id, or initial_check_in_timestamp in background task inputData.");
        return Future.value(false);
      }

      final initialCheckInTime = DateTime.fromMillisecondsSinceEpoch(int.parse(initialCheckInTimestampStr));
      final currentTime = DateTime.now();
      final difference = currentTime.difference(initialCheckInTime);
      final elapsedMinutes = difference.inMinutes;

      int? checkpointNumber;

      if (elapsedMinutes >= 4 && elapsedMinutes < 7) { // Roughly 5 minutes
        checkpointNumber = 1;
      } else if (elapsedMinutes >= 9 && elapsedMinutes < 12) { // Roughly 10 minutes
        checkpointNumber = 2;
      }

      if (checkpointNumber == null) {
        print("Error: Not within 5 or 10 minute checkpoint window. Elapsed minutes: $elapsedMinutes");
        return Future.value(false); // Do not send if not in a checkpoint window
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentFullAddress =
            "${place.name ?? ''}, "
            "${place.street ?? ''}, "
            "${place.subLocality ?? ''}, "
            "${place.locality ?? ''}, "
            "${place.subAdministrativeArea ?? ''}, "
            "${place.administrativeArea ?? ''}, "
            "${place.postalCode ?? ''}, "
            "${place.country ?? ''}";
        currentFullAddress = currentFullAddress.trim().replaceAll(RegExp(r'\s+,'), '');
      }

      var hashMap = {
        "tbl_user_id": userId,
        "tbl_meeting_id": meetingId,
        "checkpoint_number": checkpointNumber.toString(), // Send as string if backend expects dynamic type
        "latitude": currentLat,
        "longitude": currentLng,
        "full_address": currentFullAddress,
      };

      print("Sending checkpoint data from background (Checkpoint $checkpointNumber): $hashMap");
      APIResponse onValue = await meetingFakeCheckApi(hashMap);

      if (onValue.status) {
        print("Background fake check-in successful for meeting ID: $meetingId");
        return Future.value(true);
      } else {
        print("Background fake check-in failed for meeting ID: $meetingId: ${onValue.message}");
        return Future.value(false);
      }
    } catch (e) {
      print("Error during background task execution: $e");
      return Future.value(false);
    }
  });
}