import UIKit
import BackgroundTasks
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      // Register background task with your bundle ID as prefix
      BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.smoose.photoowldev.backgroundtask", using: nil) { task in
          self.handleBackgroundTask(task: task as! BGProcessingTask)
      }
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func handleBackgroundTask(task: BGProcessingTask) {
        // Schedule the next background task
        scheduleBackgroundTask()
        
        // Perform the background task
        performBackgroundTask {
            task.setTaskCompleted(success: true)
        }
        
        // Expiration handler
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
        // Schedule background task when app enters background
        scheduleBackgroundTask()
    }
}
