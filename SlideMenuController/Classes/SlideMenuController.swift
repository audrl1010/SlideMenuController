//
//  SlideMenuController.swift
//  Pods-SlideMenuController_Example
//
//  Created by myung gi son on 2017. 10. 15..
//

import UIKit

extension UIViewController {
  public var slideMenuController: SlideMenuController? {
    var viewController: UIViewController? = self
    while viewController != nil {
      if viewController is SlideMenuController {
        return viewController as? SlideMenuController
      }
      viewController = viewController?.parent
    }
    return nil
  }
}

public enum SlideOutState: String {
  case left
  case main
  case right
}

public class SlideMenuController: BaseViewController {
  
  // MARK: - Public Properties
  
  public var animationDuration: TimeInterval = 0.45
  
  public var leftVisibleWidthPercentage: CGFloat = 0.65 // 0 ~ 1
  public var rightVisibleWidthPercentage: CGFloat = 0.65 // 0 ~ 1
  
  public var allowedRightSwipe: Bool = true
  public var allowedLeftSwipe: Bool = true
  
  public var minimumMovePercentage: CGFloat = 0.15
  
  public var panningLimitedToTopViewController: Bool = true
  
  public var currentSlideOutState: SlideOutState = .main {
    didSet {
      let shouldShowShadow = (currentSlideOutState != .main)
      showShadowForMainViewController(shouldShowShadow)
    }
  }
  
  public var mainNavigationBarLeftToggleButtonIcon: UIImage? {
    didSet {
      if let icon = mainNavigationBarLeftToggleButtonIcon,
        let topViewController = topViewControllerInMainViewController() {
        addToggleBarButtonItem(for: topViewController, with: icon, direction: .left)
      }
    }
  }
  public var mainNavigationBarRightToggleButtonIcon: UIImage? {
    didSet {
      if let icon = mainNavigationBarRightToggleButtonIcon,
        let topViewController = topViewControllerInMainViewController() {
        addToggleBarButtonItem(for: topViewController, with: icon, direction: .right)
      }
    }
  }
  
  private(set) var mainViewController: UIViewController?
  private(set) var leftViewController: UIViewController?
  private(set) var rightViewController: UIViewController?
  
  // MARK: - Private Properties
  
  private var leftContainerView = UIView().then {
    $0.backgroundColor = .clear
  }
  private var mainContainerView = UIView().then {
    $0.backgroundColor = .clear
  }
  private var rightContainerView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private var mainContainerTapGesture: UITapGestureRecognizer?
  
  private var mainContainerViewLeftConstraint: NSLayoutConstraint?
  private var mainContainerViewLeftConstraintValue: CGFloat {
    return mainContainerViewLeftConstraint?.constant ?? 0
  }
  private var oldMainContainerViewLeftConstraintValueBeforePan: CGFloat = 0
  
  // MARK: - Init
  public convenience init(
    mainViewController: UIViewController,
    leftViewController: UIViewController? = nil,
    rightViewController: UIViewController? = nil
  ) {
    self.init()
    self.mainViewController = mainViewController
    self.leftViewController = leftViewController
    self.rightViewController = rightViewController
    addChildViewController(
      targetView: mainContainerView,
      targetViewController: mainViewController
    )
    addChildViewController(
      targetView: leftContainerView,
      targetViewController: leftViewController
    )
    addChildViewController(
      targetView: rightContainerView,
      targetViewController: rightViewController
    )
  }
  
  public override func setupViews() -> [CanBeSubview]? {
    addPanGesture(toView: mainContainerView)
    
    return [
      rightContainerView,
      leftContainerView,
      mainContainerView
    ]
  }
  
  public override func setupConstraints() {
    mainContainerView.flu
      .topAnchor(equalTo: view.topAnchor)
      .leftAnchor(equalTo: view.leftAnchor, constraint: &mainContainerViewLeftConstraint)
      .widthAnchor(equalTo: view.widthAnchor)
      .heightAnchor(equalTo: view.heightAnchor)
    
    leftContainerView.flu
      .widthAnchor(equalTo: mainContainerView.widthAnchor)
      .heightAnchor(equalTo: mainContainerView.heightAnchor)
      .topAnchor(equalTo: mainContainerView.topAnchor)
      .leftAnchor(equalTo: view.leftAnchor)
    
    rightContainerView.flu
      .widthAnchor(equalTo: mainContainerView.widthAnchor)
      .heightAnchor(equalTo: mainContainerView.heightAnchor)
      .topAnchor(equalTo: mainContainerView.topAnchor)
      .rightAnchor(equalTo: view.rightAnchor)
  }
  
  // MARK: - Public Methods
  
  public func setLeft(viewController newLeftViewController: UIViewController?) {
    if let newLeftViewController = newLeftViewController {
      if leftViewController != newLeftViewController {
        let previousLeftVC = leftViewController
        if isViewLoaded {
          removeChildViewController(previousLeftVC)
          leftViewController = newLeftViewController
          addChildViewController(
            targetView: leftContainerView,
            targetViewController: newLeftViewController
          )
        }
      }
    }
  }
  
  public func setRight(viewController newRightViewController: UIViewController?) {
    if let newRightViewController = newRightViewController {
      if rightViewController != newRightViewController {
        let previousRightVC = rightViewController
        
        if isViewLoaded {
          removeChildViewController(previousRightVC)
          rightViewController = newRightViewController
          addChildViewController(
            targetView: rightContainerView,
            targetViewController: newRightViewController
          )
        }
      }
    }
  }
  
  public func setMain(viewController newMainViewController: UIViewController?) {
    // if mainViewController is UINavigationController, add barButtonItem(left, right).
    func addBarButtonItemInMainViewController() {
      if let topViewController = topViewControllerInMainViewController() {
        if let mainNavigationBarLeftToggleButtonIcon = mainNavigationBarLeftToggleButtonIcon {
          addToggleBarButtonItem(
            for: topViewController,
            with: mainNavigationBarLeftToggleButtonIcon,
            direction: .left
          )
        }
        if let mainNavigationBarRightToggleButtonIcon = mainNavigationBarRightToggleButtonIcon {
          addToggleBarButtonItem(
            for: topViewController,
            with: mainNavigationBarRightToggleButtonIcon,
            direction: .right
          )
        }
      }
    }
    
    if let newMainViewController = newMainViewController {
      if mainViewController != newMainViewController {
        let previousMainVC = mainViewController
        
        if currentSlideOutState == .main {
          removeChildViewController(previousMainVC)
          mainViewController = newMainViewController
          addChildViewController(
            targetView: mainContainerView,
            targetViewController: newMainViewController
          )
          addBarButtonItemInMainViewController()
        }
        else if isViewLoaded {
          UIView.Animator(duration: 0.2)
            .beforeAnimations { [weak self] in
              guard let `self` = self else { return }
              UIApplication.shared.beginIgnoringInteractionEvents()
              let movement = (self.currentSlideOutState == .left)
                ? self.view.bounds.size.width
                : -self.view.bounds.size.width
              
              self.mainContainerViewLeftConstraint?.constant = movement
            }
            .animations { [weak self] in
              guard let `self` = self else { return }
              self.view.layoutIfNeeded()
            }
            .completion { [weak self] _ in
              guard let `self` = self else { return }
              self.removeChildViewController(previousMainVC)
              self.mainViewController = newMainViewController
              self.addChildViewController(
                targetView: self.mainContainerView,
                targetViewController: newMainViewController
              )
              
              addBarButtonItemInMainViewController()
              
              self.preventRunningAnimationImmediatelyWhileLayoutView() { [weak self] in
                guard let `self` = self else { return }
                self.animateMainViewController()
                UIApplication.shared.endIgnoringInteractionEvents()
              }
            }
            .animate()
        }
      }
    }
  }
  
  public func showLeft() {
    let notAlreadyShowed = (currentSlideOutState != .left)
    if notAlreadyShowed {
      addChildViewController(
        targetView: leftContainerView,
        targetViewController: leftViewController
      )
      // add tapGesture
      mainContainerTapGesture = addTapGesture(toView: mainContainerView)
      
      animateLeftViewController()
    }
  }
  
  public func showRight() {
    let notAlreadyShowed = (currentSlideOutState != .right)
    if notAlreadyShowed {
      
      addChildViewController(
        targetView: rightContainerView,
        targetViewController: rightViewController
      )
      // add tapGesture
      mainContainerTapGesture = addTapGesture(toView: mainContainerView)
      
      animateRightViewController()
    }
  }
  
  public func showMain() {
    let notAlreadyShowed = (currentSlideOutState != .main)
    if notAlreadyShowed {
      // remove tapGesture
      removeTapGesture(mainContainerTapGesture, ofView: mainContainerView)
      self.mainContainerTapGesture = nil
      
      animateMainViewController()
    }
  }
  
  @objc public func toggleLeft() {
    let notAlreadyShowed = (currentSlideOutState != .left)
    if notAlreadyShowed {
      addChildViewController(
        targetView: leftContainerView,
        targetViewController: leftViewController
      )
      // add tapGesture
      mainContainerTapGesture = addTapGesture(toView: mainContainerView)
      
      preventRunningAnimationImmediatelyWhileLayoutView { [weak self] in
        guard let `self` = self else { return }
        self.animateLeftViewController()
      }
    }
    else {
      // remove tapGesture
      removeTapGesture(mainContainerTapGesture, ofView: mainContainerView)
      mainContainerTapGesture = nil
      
      animateMainViewController()
    }
  }
  
  @objc public func toggleRight() {
    let notAlreadyShowed = (currentSlideOutState != .right)
    if notAlreadyShowed {
      addChildViewController(
        targetView: rightContainerView,
        targetViewController: rightViewController
      )
      // add tapGesture
      mainContainerTapGesture = addTapGesture(toView: mainContainerView)
      
      preventRunningAnimationImmediatelyWhileLayoutView { [weak self] in
        guard let `self` = self else { return }
        self.animateRightViewController()
      }
    }
    else {
      // remove tapGesture
      removeTapGesture(mainContainerTapGesture, ofView: mainContainerView)
      mainContainerTapGesture = nil
      
      animateMainViewController()
    }
  }
  
  // MARK: - Private Methods
  
  private func showShadowForMainViewController(_ show: Bool) {
    if show {
      mainContainerView.layer.shadowColor = UIColor.black.cgColor
      mainContainerView.layer.shadowRadius = 10.0
      mainContainerView.layer.shadowOpacity = 0.75
    } else {
      mainContainerView.layer.shadowOpacity = 0.0
    }
  }
  
  private func createAnimator() -> UIView.SpringAnimator {
    return UIView.SpringAnimator(duration: animationDuration)
      .damping(1.0)
      .velocity(1.0)
      .options(.curveEaseInOut)
  }
  
  private func animateMainViewController() {
    leftContainerView.isUserInteractionEnabled = false
    rightContainerView.isUserInteractionEnabled = false
    mainViewController?.view.isUserInteractionEnabled = true
    
    let animator = createAnimator()
      .beforeAnimations { [weak self] in
        guard let `self` = self else { return }
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.mainContainerViewLeftConstraint?.constant = 0
      }
      .animations { [weak self] in
        guard let `self` = self else { return }
        self.view.layoutIfNeeded()
    }
    switch currentSlideOutState {
    case .main:
      animator
        .completion { [weak self] _ in
          guard let `self` = self else { return }
          self.currentSlideOutState = .main
          self.removeChildViewController(self.leftViewController)
          self.removeChildViewController(self.rightViewController)
          UIApplication.shared.endIgnoringInteractionEvents()
      }
    case .left:
      animator
        .completion { [weak self] _ in
          guard let `self` = self else { return }
          self.currentSlideOutState = .main
          self.removeChildViewController(self.leftViewController)
          UIApplication.shared.endIgnoringInteractionEvents()
      }
    case .right:
      animator
        .completion { [weak self] _ in
          guard let `self` = self else { return }
          self.currentSlideOutState = .main
          self.removeChildViewController(self.rightViewController)
          UIApplication.shared.endIgnoringInteractionEvents()
      }
    }
    animator.animate()
  }
  
  private func animateLeftViewController() {
    leftContainerView.isUserInteractionEnabled = true
    rightContainerView.isUserInteractionEnabled = false
    mainViewController?.view.isUserInteractionEnabled = false
    
    currentSlideOutState = .left
    createAnimator()
      .beforeAnimations { [weak self] in
        guard let `self` = self else { return }
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.mainContainerViewLeftConstraint?.constant = (self.view.frame.width * self.leftVisibleWidthPercentage)
      }
      .animations { [weak self] in
        guard let `self` = self else { return }
        self.view.layoutIfNeeded()
      }
      .completion { _ in
        UIApplication.shared.endIgnoringInteractionEvents()
        
      }
      .animate()
  }
  
  private func animateRightViewController() {
    rightContainerView.isUserInteractionEnabled = true
    leftContainerView.isUserInteractionEnabled = false
    mainViewController?.view.isUserInteractionEnabled = false
    
    currentSlideOutState = .right
    createAnimator()
      .beforeAnimations { [weak self] in
        guard let `self` = self else { return }
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.mainContainerViewLeftConstraint?.constant = (self.view.frame.width * -self.rightVisibleWidthPercentage)
      }
      .animations { [weak self] in
        guard let `self` = self else { return }
        self.view.layoutIfNeeded()
      }
      .completion { _ in
        UIApplication.shared.endIgnoringInteractionEvents()
      }
      .animate()
  }
  
  // MARK: - Action
  
  @objc func handleTap(_ tapGesture: UITapGestureRecognizer) {
    // remove tapGesture
    removeTapGesture(mainContainerTapGesture, ofView: mainContainerView)
    mainContainerTapGesture = nil
    
    animateMainViewController()
  }
  
  @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
    // Check left or right
    let isDraggingLeft = (panGesture.velocity(in: mainContainerView).x > 0)
    
    switch panGesture.state {
    case .began:
      oldMainContainerViewLeftConstraintValueBeforePan = mainContainerViewLeftConstraintValue
      if currentSlideOutState == .main {
        showShadowForMainViewController(true)
      }
      
    case .changed:
      let translationX = panGesture.translation(in: mainContainerView).x
      panGesture.setTranslation(.zero, in: mainContainerView)
      
      let constant = mainContainerViewLeftConstraintValue + translationX
      
      if allowedLeftSwipe && allowedRightSwipe {
        mainContainerViewLeftConstraint?.constant += translationX
      }
      else if allowedLeftSwipe {
        if constant >= 0 && constant <= view.frame.size.width {
          mainContainerViewLeftConstraint?.constant += translationX
        }
      }
      else if allowedRightSwipe {
        if constant <= 0 && constant >= -view.frame.size.width {
          mainContainerViewLeftConstraint?.constant += translationX
        }
      }
      
      if mainContainerViewLeftConstraintValue > 0 {
        // show leftViewController
        if leftViewController?.view.superview == nil {
          addChildViewController(
            targetView: leftContainerView,
            targetViewController: leftViewController
          )
        }
        if rightViewController?.view.superview != nil {
          removeChildViewController(rightViewController)
        }
      }
      else if mainContainerViewLeftConstraintValue < 0 {
        // show rightViewController
        if rightViewController?.view.superview == nil {
          addChildViewController(
            targetView: rightContainerView,
            targetViewController: rightViewController
          )
        }
        if leftViewController?.view.superview != nil {
          removeChildViewController(leftViewController)
        }
      }
      
    case .ended:
      let movement = mainContainerViewLeftConstraintValue - oldMainContainerViewLeftConstraintValueBeforePan
      let minimum = view.bounds.size.width * minimumMovePercentage
      
      switch currentSlideOutState {
      case .main:
        if isDraggingLeft {
          if rightViewController?.view.superview != nil {
            animateMainViewController()
          }
          else {
            // is possible Left Move ?
            if (movement > minimum) {
              // add tapGesture
              mainContainerTapGesture = addTapGesture(toView: mainContainerView)
              
              animateLeftViewController()
            }
            else {
              animateMainViewController()
            }
          }
        }
        else {
          if leftViewController?.view.superview != nil {
            animateMainViewController()
          }
          else {
            // is possible Right Move ?
            if (movement < -minimum) {
              // add tapGesture
              mainContainerTapGesture = addTapGesture(toView: mainContainerView)
              
              animateRightViewController()
            }
            else {
              animateMainViewController()
            }
          }
        }
      case .left:
        if isDraggingLeft {
          animateLeftViewController()
        }
        else {
          // is possible Main Move ?
          if (movement < -minimum) {
            // remove tapGesture
            removeTapGesture(mainContainerTapGesture, ofView: mainContainerView)
            mainContainerTapGesture = nil
            
            animateMainViewController()
          }
          else {
            animateLeftViewController()
          }
        }
      case .right:
        if isDraggingLeft {
          // is possible Main Move ?
          if (movement > minimum) {
            // remove tapGesture
            removeTapGesture(mainContainerTapGesture, ofView: mainContainerView)
            mainContainerTapGesture = nil
            
            animateMainViewController()
          }
          else {
            animateRightViewController()
          }
        }
        else {
          animateRightViewController()
        }
      }
    default: break
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension SlideMenuController: UIGestureRecognizerDelegate {
  
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    if let pan = gestureRecognizer as? UIPanGestureRecognizer {
      let translate = pan.translation(in: pan.view!)
      // determine if right swipe is allowed
      if (translate.x < 0 && !allowedRightSwipe) {
        return true
      }
      // determine if left swipe is allowed
      if (translate.x > 0 && !allowedLeftSwipe) {
        return true
      }
    }
    return false
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    
    func isOnTopLevelViewController(_ viewController: UIViewController?) -> Bool {
      if let nav = viewController as? UINavigationController {
        return nav.viewControllers.count == 1
      }
      else if let tab = viewController as? UITabBarController {
        return isOnTopLevelViewController(tab.selectedViewController)
      }
      return viewController != nil
    }
    
    if panningLimitedToTopViewController && !isOnTopLevelViewController(mainViewController) {
      return false
    }
    else if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
      return true
    }
    else if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
      let pan = gestureRecognizer as! UIPanGestureRecognizer
      let translate = pan.translation(in: pan.view!)
      
      // Check whether user swipe.
      let isSwipe = translate.x != 0 && translate.y.absolute / translate.x.absolute < 1.0
      
      if isSwipe && (translate.x > 0) || (translate.x < 0) {
        return true
      }
    }
    return false
  }
}

// MARK: - Internal Helper
extension SlideMenuController {
  
  private func addPanGesture(toView view: UIView) {
    let panGesture = UIPanGestureRecognizer()
    panGesture.addTarget(self, action: #selector(handlePan(_:)))
    panGesture.delegate = self
    panGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(panGesture)
  }
  
  private func addTapGesture(toView view: UIView) -> UITapGestureRecognizer {
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(handleTap(_:)))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
    return tapGesture
  }
  
  private func removeTapGesture(_ tapGesture: UITapGestureRecognizer?, ofView view: UIView) {
    if let tapGesture = tapGesture {
      view.removeGestureRecognizer(tapGesture)
    }
  }
  
  private func topViewControllerInMainViewController() -> UIViewController? {
    if let nav = mainViewController as? UINavigationController {
      if nav.viewControllers.count > 0 {
        return nav.viewControllers[0]
      }
    }
    return nil
  }
  
  private enum BarButtonItemDirection {
    case left
    case right
  }
  
  private func addToggleBarButtonItem(
    for viewController: UIViewController,
    with icon: UIImage,
    direction: BarButtonItemDirection
  ) {
    let button = UIButton(type: .custom)
    button.setImage(icon, for: .normal)
    
    if #available(iOS 11, *) {
      button.flu
        .widthAnchor(equalToConstant: icon.size.width)
        .heightAnchor(equalToConstant: icon.size.height)
    }
    else {
      button.frame = CGRect(
        x: 0,
        y: 0,
        width: icon.size.width,
        height: icon.size.height
      )
    }
    
    switch direction {
    case .left:
      button.addTarget(
        self,
        action: #selector(toggleLeft),
        for: .touchUpInside
      )
      viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    case .right:
      button.addTarget(
        self,
        action: #selector(toggleRight),
        for: .touchUpInside
      )
      viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
  }
  
  private func addChildViewController(
    targetView: UIView,
    targetViewController: UIViewController?
  ) {
    if let viewController = targetViewController {
      addChildViewController(viewController)
      view.backgroundColor = viewController.view.backgroundColor
      targetView.addSubview(viewController.view)
      viewController.view.flu
        .topAnchor(equalTo: targetView.topAnchor)
        .leftAnchor(equalTo: targetView.leftAnchor)
        .rightAnchor(equalTo: targetView.rightAnchor)
        .bottomAnchor(equalTo: targetView.bottomAnchor)
      viewController.didMove(toParentViewController: self)
    }
  }
  
  private func removeChildViewController(_ viewController: UIViewController?) {
    if let viewController = viewController {
      viewController.willMove(toParentViewController: nil)
      viewController.view.removeFromSuperview()
      viewController.removeFromParentViewController()
    }
  }
  
  /// if run the animation immediately while placing the view, looks bad.
  private func preventRunningAnimationImmediatelyWhileLayoutView(_ block: @escaping () -> Void) {
    let deadlineTime = DispatchTime.now() + 0.06
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
      block()
    }
  }
}

extension CGFloat {
  var absolute: CGFloat {
    return CGFloat(fabsf(Float(self)))
  }
}
