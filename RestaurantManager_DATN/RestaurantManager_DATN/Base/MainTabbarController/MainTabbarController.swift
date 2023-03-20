//
//  MainTabbarController.swift
//  BaoThanhNien
//
//  Created by Pham Tuan Anh on 02/01/2023.
//

import Foundation
import UIKit

class MainTabbarController: UITabBarController {
    
    let arrayOfImageNameForUnselectedState = ["manager_gray","manager_gray","manager_gray", "manager_gray", "manager_gray"]
    let arrayOfImageNameForSelectedState = ["manager_black","manager_black","manager_black","manager_black", "manager_black"]
    var indexNoti = 0
    var selectedTagBefore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabbar()
        self.setShadow()
    }
    
    func initTabbar() {
        self.delegate = self
        let restaurantManager =  RestaurantManagerViewController()
        let restaurantManagerNavi = UINavigationController.init(rootViewController: restaurantManager)
        restaurantManagerNavi.isNavigationBarHidden = true
        restaurantManagerNavi.tabBarItem = UITabBarItem(
            title: "Nhà hàng",
            image: UIImage (named: ""),
            tag:0)
        
        let radio =  RestaurantManagerViewController()
        let radioNavi = UINavigationController.init(rootViewController: radio)
        radioNavi.isNavigationBarHidden = true
        radioNavi.tabBarItem = UITabBarItem(
            title:"Nhà bếp",
            image: UIImage (named: ""),
            tag:1)
        
        let news = RestaurantManagerViewController()
        let newsNavi = UINavigationController.init(rootViewController: news)
        newsNavi.isNavigationBarHidden = true
        newsNavi.tabBarItem = UITabBarItem(
            title: "Kho",
            image: UIImage (named: ""),
            tag:2)
        
        let video = RestaurantManagerViewController()
        let videoNavi = UINavigationController.init(rootViewController: video)
        videoNavi.isNavigationBarHidden = true
        videoNavi.tabBarItem = UITabBarItem(
            title: "Quản lí",
            image: UIImage (named: ""),
            tag:3)
        
        let menu = RestaurantManagerViewController()
        let menuNavi = UINavigationController.init(rootViewController: menu)
        menuNavi.isNavigationBarHidden = true
        menuNavi.tabBarItem = UITabBarItem(
            title: "Thông tin",
            image: UIImage (named: ""),
            tag:4)
        
        let controllers = [restaurantManager, radioNavi, newsNavi, videoNavi, menuNavi]
        self.viewControllers = controllers
        UITabBar.appearance().barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.configTabbar()
    }
    
    func configTabbar() {
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let selectedColor   = #colorLiteral(red: 0.01176470588, green: 0.5921568627, blue: 0.8274509804, alpha: 1)
        let unselectedColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        
        let nameFont =  UIFont(name: FontName.kFontSanRegular, size: 11) ?? UIFont.systemFont(ofSize: 11)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: nameFont as Any, NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
      
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        self.tabBar.isTranslucent = false
        
    }
    
    func setShadow() {
        tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -10)
        tabBar.layer.shadowRadius = 20
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
        tabBar.layer.shouldRasterize = true
        tabBar.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabbarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController, let vi = nav.viewControllers[0] as? RestaurantManagerViewController, self.selectedTagBefore == selectedIndex {
            vi.handleRefreshScroll()
        }
        if let nav = viewController as? UINavigationController, let vi = nav.viewControllers[0] as? RestaurantManagerViewController, self.selectedTagBefore == selectedIndex {
            vi.handleRefreshScroll()
        }
        if let nav = viewController as? UINavigationController, let vi = nav.viewControllers[0] as? RestaurantManagerViewController, self.selectedTagBefore == selectedIndex {
            vi.handleRefreshScroll()
        }

        selectedTagBefore = selectedIndex
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.1, options: [.transitionCrossDissolve], completion: nil)
        }
        guard let tabViewControllers = viewControllers else { return false }
        // Pop to root controller if already on requested tab.
        let index = tabViewControllers.firstIndex(of: viewController)
        if index == tabBarController.selectedIndex {
            (viewController as? UINavigationController)?.popToRootViewController(animated: true)
        }
        // For transition animation like Facebook app, remove this line if don't want to use animation
        return true
    }
}

extension UITabBarController {
    
    // A function to implement transition animation when switch tabbar item
    fileprivate func animateTabTransition (_ tabBarController: UITabBarController, to viewController: UIViewController) -> Bool {
        
        guard let tabViewControllers = viewControllers else { return false }
        
        if let selectedViewController = tabBarController.selectedViewController,
            let fromView = selectedViewController.view,
            let toView = viewController.view {
            
            if fromView == toView { return false }
            let fromIndex: Int = tabViewControllers.firstIndex(of: selectedViewController) ?? 0
            let toIndex: Int = tabViewControllers.firstIndex(of: viewController) ?? 0
            let translationX = tabBarController.view.bounds.width
            
            toView.transform = CGAffineTransform.init(
                translationX: toIndex > fromIndex ? translationX/3 : -translationX/3,
                y: 0.0)
            
            let imageView = tabBarController.addPrevViewControllerSnapShot(fromView.takeSnapshot())
            
            UIView.animate(
                withDuration: 0.24,
                delay: 0.0,
                options: UIView.AnimationOptions(rawValue: 7 << 16),
                animations: {
                    toView.transform = CGAffineTransform.identity
                    imageView.alpha = 0.5
                    imageView.transform = CGAffineTransform.init(
                        translationX: toIndex > fromIndex ? -translationX/6 : translationX/6,
                        y: 0.0)
            }, completion: { (finished) in
                if finished {
                    tabBarController.selectedIndex = toIndex
                }
                imageView.removeFromSuperview()
            })
        }
        
        return true
    }
    func setSelectedIndex(toIndex: Int, _ animated: Bool) {
        guard let tabViewControllers = viewControllers, toIndex < tabViewControllers.count else { return }
        if animated {
            let viewController = tabViewControllers[toIndex]
            if let selectedViewController = selectedViewController,
                let fromView = selectedViewController.view, let toView = viewController.view {
                if fromView == toView { return }
                let fromIndex: Int = tabViewControllers.firstIndex(of: selectedViewController) ?? 0
                let toIndex: Int = tabViewControllers.firstIndex(of: viewController) ?? 0
                let translationX = view.bounds.width/// 4
                toView.transform = CGAffineTransform.init( translationX: toIndex > fromIndex ? translationX/3 : -translationX/3, y: 0.0)
                let imageView = addPrevViewControllerSnapShot(fromView.takeSnapshot())
                selectedIndex = toIndex
                UIView.animate(
                    withDuration: 0.24,
                    delay: 0.0,
                    options: UIView.AnimationOptions(rawValue: 7 << 16),
                    animations: {
                        toView.transform = CGAffineTransform.identity
                        imageView.alpha = 0.5
                        imageView.transform = CGAffineTransform.init( translationX: toIndex > fromIndex ? -translationX/6 : translationX/6, y: 0.0)
                }, completion: { (_) in
                    imageView.removeFromSuperview()
                })
            }
        } else {
            self.selectedIndex = toIndex
        }
    }
    
    func addPrevViewControllerSnapShot(_ image: UIImage?) -> UIView {
        if let oldView = view.viewWithTag(9876) {
            oldView.removeFromSuperview()
        }
        let imageView = UIImageView(image: image)
        imageView.tag = 9876
        imageView.frame = view.bounds
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        return imageView
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.children[self.selectedIndex]
    }

    open override var childForStatusBarHidden: UIViewController? {
        return self.children[self.selectedIndex]
    }
}
