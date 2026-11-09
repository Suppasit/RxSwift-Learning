import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    // The window and root view controller are created automatically from
    // Main.storyboard, as configured by UISceneStoryboardFile in Info.plist.
    guard scene is UIWindowScene else { return }
  }
}
