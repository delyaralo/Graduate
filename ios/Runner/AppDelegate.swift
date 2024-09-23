import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    var blackOutView: UIView?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        preventScreenRecording()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)

        preventScreenRecording()
    }

    func preventScreenRecording() {
        if UIScreen.main.isCaptured {
            showBlackScreen()
        } else {
            hideBlackScreen()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingChanged), name: UIScreen.capturedDidChangeNotification, object: nil)
    }

    @objc func screenRecordingChanged() {
        if UIScreen.main.isCaptured {
            showBlackScreen()
        } else {
            hideBlackScreen()
        }
    }

    func showBlackScreen() {
        if blackOutView == nil, let window = UIApplication.shared.keyWindow {
            blackOutView = UIView(frame: window.bounds)
            blackOutView?.backgroundColor = UIColor.black
            window.addSubview(blackOutView!)
        }
    }

    func hideBlackScreen() {
        blackOutView?.removeFromSuperview()
        blackOutView = nil
    }
}
