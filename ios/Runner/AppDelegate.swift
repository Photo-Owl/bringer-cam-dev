import UIKit
import BackgroundTasks
import Flutter
import UserNotifications
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
      // Register background task with your bundle ID as prefix
//      BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.smoose.photoowldev.backgroundtask", using: nil) { task in
//          self.handleBackgroundTask(task: task as! BGProcessingTask)
//      }
      
//      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//          if granted {
//              print("Permission granted")
////              let content = UNMutableNotificationContent()
////              content.title = "Good morning"
////              content.subtitle = "This is a local notification"
////              content.body = "Don't forget to check out our app."
////              content.userInfo = ["content-available": 1]
////              
////              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
////
////              let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
////
////              UNUserNotificationCenter.current().add(request) { error in
////                  if let error = error {
////                      print("Error: \(error.localizedDescription)")
////                  }
////              }
//          } else if let error = error {
//              print("Error: \(error.localizedDescription)")
//          }
//      }
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        print(deviceTokenString)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("notification thrown")
    }
    func handleBackgroundTask(task: BGProcessingTask) {
        scheduleBackgroundTask()
        
        performBackgroundTask {
            task.setTaskCompleted(success: true)
        }
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
    }
    
    func performBackgroundTask(completion: @escaping () -> Void) {
        // Perform your background task here
        print("Performing background task")
        completion()
    }
    
    func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.smoose.photoowldev.backgroundtask")
        request.requiresNetworkConnectivity = true // Requires network connectivity
        request.requiresExternalPower = false // Does not require external power
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to submit BGProcessingTaskRequest: \(error)")
        }
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
//        scheduleBackgroundTask()
    }
    
//    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        print("Notification received with userInfo: \(userInfo)")
//        
//        completionHandler([])
//    }
    
    //MARK: Importing methods
    override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let imageId = FilePathUtil.randomIntBasedOnTimestamp()
        let imagePath = FilePathUtil.imagePath(imgId: imageId.description)
        
        FilePathUtil.copyImage(from: url, to: imagePath)
        
        DBUtil.sharedInstance().insertImage(imageId: imageId, path: imagePath)
        return true
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
