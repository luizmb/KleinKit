//
//  RootNavigationViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//
import UIKit

open class ENSideMenuNavigationController: UINavigationController, ENSideMenuProtocol {

    open var sideMenu : ENSideMenu?
    open var sideMenuAnimationType : ENSideMenuAnimation = .default
    var hamburger: UIBarButtonItem?

    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        hamburger = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self.sideMenu, action: #selector(toggleSideMenuView))
        self.viewControllers.first?.navigationItem.setLeftBarButton(hamburger, animated: false)
    }

    public init( menuViewController: UIViewController, contentViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)

        if let rootViewController = contentViewController {
            setMainViewController(rootViewController)
        }

        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menuViewController, menuPosition:.left)
        view.bringSubview(toFront: navigationBar)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Navigation
    open func setContentViewController(_ contentViewController: UIViewController) {
        self.sideMenu?.toggleMenu()
        setMainViewController(contentViewController)
    }

    private func setMainViewController(_ viewController: UIViewController) {
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.setLeftBarButton(hamburger, animated: false)
        self.setViewControllers([viewController], animated: sideMenuAnimationType == .default)
    }
}
