//
//  Example.swift
//  SlideMenuController_Example
//
//  Created by myung gi son on 2017. 10. 15..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import SlideMenuController

class MainViewController: UIViewController {
  var tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.separatorColor = .clear
    $0.register(MenuCell.self, forCellReuseIdentifier: MenuCell.cellIdentifier)
  }
  
  var menus: [String] = ((1...30).map { "\($0)" })
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    view.backgroundColor = .white
    view.addSubview(tableView)
    
    tableView.flu
      .topAnchor(equalTo: topLayoutGuide.bottomAnchor)
      .leftAnchor(equalTo: view.leftAnchor)
      .rightAnchor(equalTo: view.rightAnchor)
      .bottomAnchor(equalTo: bottomLayoutGuide.topAnchor)
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return menus.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let menuCell = tableView.dequeueReusableCell(withIdentifier: MenuCell.cellIdentifier) as! MenuCell
    menuCell.label.text = menus[indexPath.row]
    menuCell.label.textAlignment = .center
    return menuCell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    print(indexPath.row + 1)
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 50
  }
}

class LeftViewController: MenuViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    menuTextAlignment = .left
    menus = ["Left 1", "Left 2", "Left 3", "Left 4", "Left 5"]
    view.backgroundColor = .white
    tableView.reloadData()
  }
}

class RightViewController: MenuViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    menuTextAlignment = .right
    menus = ["Right 1", "Right 2", "Right 3", "Right 4"]
    view.backgroundColor = .white
    tableView.reloadData()
  }
}

class DetailViewController: HasLabelViewController { }

class HasButtonViewController: UIViewController {
  var buttonText: String = "" {
    didSet {
      button.setTitle(buttonText, for: .normal)
    }
  }
  
  var button = UIButton(type: .system)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(button)
    view.backgroundColor = .white
    button.addTarget(self, action: #selector(buttonDidTouch), for: .touchUpInside)
    button.flu
      .widthAnchor(equalToConstant: 150)
      .heightAnchor(equalToConstant: 50)
      .centerXAnchor(equalTo: view.centerXAnchor)
      .centerYAnchor(equalTo: view.centerYAnchor)
  }
  
  @objc func buttonDidTouch() {
    let detailViewController = HasLabelViewController()
    detailViewController.label.text = "Detail viewController: \(buttonText)"
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

class HasLabelViewController: UIViewController {
  var text: String = "" {
    didSet {
      label.text = text
    }
  }
  var label = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(label)
    
    label.flu
      .centerXAnchor(equalTo: view.centerXAnchor)
      .centerYAnchor(equalTo: view.centerYAnchor)
  }
}

class MenuViewController: UIViewController {
  var tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.separatorColor = .clear
    $0.register(MenuCell.self, forCellReuseIdentifier: MenuCell.cellIdentifier)
  }
  
  var menuTextAlignment: NSTextAlignment = .center
  var menus: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.flu
      .topAnchor(equalTo: topLayoutGuide.bottomAnchor)
      .leftAnchor(equalTo: view.leftAnchor)
      .rightAnchor(equalTo: view.rightAnchor)
      .bottomAnchor(equalTo: bottomLayoutGuide.topAnchor)
  }
}

extension MenuViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return menus.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let menuCell = tableView.dequeueReusableCell(withIdentifier: MenuCell.cellIdentifier) as! MenuCell
    menuCell.label.text = menus[indexPath.row]
    menuCell.label.textAlignment = menuTextAlignment
    return menuCell
  }
}

extension MenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedMenuViewController = HasButtonViewController()
    selectedMenuViewController.buttonText = menus[indexPath.row]
    let navi = UINavigationController(rootViewController: selectedMenuViewController)
    self.slideMenuController?.setMain(viewController: navi)
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 50
  }
}

class MenuCell: BaseCell {
  var label = UILabel().then {
    $0.textColor = .black
  }
  var separatorView = UIView().then {
    $0.backgroundColor = .black
  }
  override func addViews() -> [UIView] {
    return [label, separatorView]
  }
  override func setupConstraints() {
    label.flu
      .topAnchor(equalTo: topAnchor, constant: 5)
      .leftAnchor(equalTo: leftAnchor, constant: 15)
      .rightAnchor(equalTo: rightAnchor, constant: -15)
      .bottomAnchor(equalTo: bottomAnchor, constant: -5)
    
    separatorView.flu
      .leftAnchor(equalTo: leftAnchor)
      .rightAnchor(equalTo: rightAnchor)
      .heightAnchor(equalToConstant: 1)
      .bottomAnchor(equalTo: bottomAnchor)
  }
}

class BaseCell: UITableViewCell {
  class var cellIdentifier: String { return "\(self)" }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    for childView in addViews() {
      addSubview(childView)
    }
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    for childView in addViews() {
      addSubview(childView)
    }
    setupConstraints()
  }
  
  func setupViews() {
    selectionStyle = .none
  }
  func addViews() -> [UIView] { return [] }
  func setupConstraints() {}
}

