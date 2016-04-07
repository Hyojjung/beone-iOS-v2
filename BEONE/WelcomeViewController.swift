
import UIKit

class WelcomeViewController: BaseViewController {

  let rmParallaxViewController: RMParallax = {
    let rmParallax = RMParallax(motion: false)
    return rmParallax
  }()
  
  override func setUpView() {
    super.setUpView()
    addChildViewController(rmParallaxViewController)
    view.addSubview(rmParallaxViewController.view)
    rmParallaxViewController.didMoveToParentViewController(self)
    
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: kVisited)
  }
  
}
