import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:meeting/APIs/Api.dart';

// ✅ Cleaner + safer refactor
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized(); // ✅ important for background isolate

    _log("BG task started: $task");
    _log("BG inputData: $inputData");

    try {
      final payload = await _buildCheckpointPayload(inputData);
      if (payload == null) return Future.value(false);

      _log("Sending checkpoint payload: ${jsonEncode(payload)}");

      final APIResponse apiRes = await meetingFakeCheckApi(payload);

      if (apiRes.status) {
        _log("✅ Fake checkpoint stored successfully. msg=${apiRes.message}");
        return Future.value(true);
      } else {
        _log("❌ Fake checkpoint failed. msg=${apiRes.message}");
        return Future.value(false);
      }
    } catch (e, st) {
      _log("❌ BG task exception: $e");
      _log("Stack: $st");
      return Future.value(false);
    }
  });
}
/// Returns payload Map to send to API, or null if we should not send anything.
Future<Map<String, dynamic>?> _buildCheckpointPayload(Map<String, dynamic>? inputData) async {
  if (inputData == null) {
    _log("❌ inputData is null");
    return null;
  }

  final String? meetingId = inputData['meeting_id']?.toString();
  final String? userId = inputData['tbl_user_id']?.toString();
  final String? tsStr = inputData['initial_check_in_timestamp']?.toString();
  final String? checkpointStr = inputData['checkpoint_number']?.toString();

  if (meetingId == null || meetingId.isEmpty || userId == null || userId.isEmpty) {
    _log("??O Missing meeting_id / tbl_user_id");
    return null;
  }

  int? elapsedMinutes;
  if (tsStr != null && tsStr.isNotEmpty) {
    final int? ts = int.tryParse(tsStr);
    if (ts != null) {
      elapsedMinutes = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(ts))
          .inMinutes;
    } else {
      _log("??O initial_check_in_timestamp is not a valid int: $tsStr");
    }
  }

  final int? intendedCheckpoint = int.tryParse(checkpointStr ?? "");
  int? checkpointNumber;
  if (intendedCheckpoint == 1 || intendedCheckpoint == 2) {
    if (elapsedMinutes == null) {
      _log("??O Missing initial_check_in_timestamp for checkpoint gating");
      return null;
    }
    if (intendedCheckpoint == 1 && !(elapsedMinutes >= 4 && elapsedMinutes < 9)) {
      _log("??O Checkpoint 1 window not reached. elapsedMinutes=$elapsedMinutes");
      return null;
    }
    if (intendedCheckpoint == 2 && !(elapsedMinutes >= 9 && elapsedMinutes < 21)) {
      _log("??O Checkpoint 2 window not reached. elapsedMinutes=$elapsedMinutes");
      return null;
    }
    checkpointNumber = intendedCheckpoint;
    _log("Using intended checkpoint=$checkpointNumber, elapsedMinutes=$elapsedMinutes");
  } else if (elapsedMinutes != null) {
    checkpointNumber = _resolveCheckpoint(elapsedMinutes);
  } else {
    _log("??O Missing checkpoint_number and initial_check_in_timestamp");
    return null;
  }

  if (checkpointNumber == null) {
    _log("⏭️ Not in checkpoint window. elapsedMinutes=$elapsedMinutes");
    return null;
  }

  final Position? position = await _getPositionSafe();
  if (position == null) return null;

  final String lat = position.latitude.toString();
  final String lng = position.longitude.toString();
  final String address = await _getAddressSafe(position) ?? "Unknown Address";

  return {
    "tbl_user_id": userId,
    "tbl_meeting_id": meetingId,
    "checkpoint_number": checkpointNumber.toString(),
    "latitude": lat,
    "longitude": lng,
    "full_address": address,
  };
}

/// Your original strict windows:
///  - checkpoint 1: minutes 4..6
///  - checkpoint 2: minutes 9..11
int? _resolveCheckpoint(int elapsedMinutes) {
  if (elapsedMinutes >= 4 && elapsedMinutes < 9) return 1;
  if (elapsedMinutes >= 9 && elapsedMinutes < 21) return 2;
  return null;
}

Future<Position?> _getPositionSafe() async {
  try {
    // In background, permissions can fail; log clearly.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log("❌ Location service disabled");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      _log("❌ Location permission denied (or deniedForever): $permission");
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  } catch (e) {
    _log("❌ Geolocator error: $e");
    return null;
  }
}

Future<String?> _getAddressSafe(Position position) async {
  try {
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isEmpty) return null;

    final p = placemarks.first;

    // Build a clean address without lots of ", ,"
    final parts = <String?>[
      p.name,
      p.street,
      p.subLocality,
      p.locality,
      p.subAdministrativeArea,
      p.administrativeArea,
      p.postalCode,
      p.country,
    ]
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return parts.join(", ");
  } catch (e) {
    _log("⚠️ Geocoding error: $e");
    return null;
  }
}

void _log(String msg) {
  // One place for logs (easy to disable later)
  // ignore: avoid_print
  print("[FAKE_CHECK_BG] $msg");
}
