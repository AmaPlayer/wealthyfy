import Flutter
import UIKit
import Workmanager // Added for Workmanager
import CoreLocation // Added for location services

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register Workmanager task
    WorkmanagerPlugin.registerTask(withIdentifier: "meetingFakeCheck") // Make sure "meetingFakeCheck" matches the identifier used in registerOneOffTask

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
