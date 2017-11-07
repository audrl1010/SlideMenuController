//
//  Base.swift
//
//  Created by myung gi son on 2017. 11. 5..
//

import UIKit

// MARK: - CanBeSubview

/// This is a protocol that allow adding subviews
/// to the superview without distinction of CALayer or UIView.
public protocol CanBeSubview {}

extension UIView: CanBeSubview {}
extension CALayer: CanBeSubview {}

extension UIView {
  public func addSubviews(_ subviews: UIView...) -> UIView {
    subviews.forEach { addSubview($0) }
    return self
  }
}

extension CALayer {
  public func addSublayers(_ sublayers: CALayer...) -> CALayer {
    sublayers.forEach { addSublayer($0) }
    return self
  }
}

// MARK: - BaseViewController

open class BaseViewController: UIViewController {
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    configureSubviews(ofSuperview: view)
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// After configure propertys for each view,
  /// return an array of views to add to the superview in desired order.
  open func setupViews() -> [CanBeSubview]? {
    return nil
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Configure the constraints for each view.
  open func setupConstraints() {}
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Execute `setupViews` method and
  /// add an array of views desired order to the superview
  /// and execute `setupConstraints` method.
  public func configureSubviews(ofSuperview superview: UIView) {
    setupViews()?.forEach {
      if let subLayer = $0 as? CALayer {
        superview.layer.addSublayer(subLayer)
      }
      else {
        superview.addSubview($0 as! UIView)
      }
    }
    setupConstraints()
  }
}

// MARK: - BaseView

open class BaseView: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    configureSubviews(ofSuperview: self)
  }
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// After configure propertys for each view,
  /// return an array of views to add to the superview in desired order.
  open func setupViews() -> [CanBeSubview]? {
    return nil
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Configure the constraints for each view.
  open func setupConstraints() {}
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Execute `setupViews` method and
  /// add an array of views desired order to the superview
  /// and execute `setupConstraints` method.
  public func configureSubviews(ofSuperview superview: UIView) {
    setupViews()?.forEach {
      if let subLayer = $0 as? CALayer {
        superview.layer.addSublayer(subLayer)
      }
      else {
        superview.addSubview($0 as! UIView)
      }
    }
    setupConstraints()
  }
}

// MARK: - BaseTableViewCell

open class BaseTableViewCell: UITableViewCell {
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    configureSubviews(ofSuperview: self)
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// After configure propertys for each view,
  /// return an array of views to add to the superview in desired order.
  open func setupViews() -> [CanBeSubview]? {
    return nil
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Configure the constraints for each view.
  open func setupConstraints() {}
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Execute `setupViews` method and
  /// add an array of views desired order to the superview
  /// and execute `setupConstraints` method.
  public func configureSubviews(ofSuperview superview: UIView) {
    setupViews()?.forEach {
      if let subLayer = $0 as? CALayer {
        superview.layer.addSublayer(subLayer)
      }
      else {
        superview.addSubview($0 as! UIView)
      }
    }
    setupConstraints()
  }
}

// MARK: - BaseCollectionViewCell

open class BaseCollectionViewCell: UICollectionViewCell {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    configureSubviews(ofSuperview: self)
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// After configure propertys for each view,
  /// return an array of views to add to the superview in desired order.
  open func setupViews() -> [CanBeSubview]? {
    return nil
  }
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Configure the constraints for each view.
  open func setupConstraints() {}
  
  // this is kind of ugly I know :(
  // Swift compiler reports "Not supported yet" when trying to override protocol extensions
  
  /// Execute `setupViews` method and
  /// add an array of views desired order to the superview
  /// and execute `setupConstraints` method.
  public func configureSubviews(ofSuperview superview: UIView) {
    setupViews()?.forEach {
      if let subLayer = $0 as? CALayer {
        superview.layer.addSublayer(subLayer)
      }
      else {
        superview.addSubview($0 as! UIView)
      }
    }
    setupConstraints()
  }
}
