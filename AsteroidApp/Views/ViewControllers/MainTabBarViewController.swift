//
//  MainTabBarViewController.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 19.04.2022.
//

import UIKit

// MARK: - MainTabBarViewController - главный экран
final class MainTabBarViewController: UITabBarController {
    
    private enum Strings {
        static let titleForListVC = "Армагеддон 2022"
        static let tabBarTitleForListVC = "Астеориды"
        static let titleForDestroyVC = "Корзина"
        static let tabBarTitleForDestroyVC = "Уничтожение"
        static let globeImage = "globe"
        static let trashImage = "trash"
        static let fontTitle = "SFProText-Semibold"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 0.92)
        setupViewControllers()
    }
    
    // установка viewControllers
    private func setupViewControllers() {
        
        guard let imageForListVC = UIImage(systemName: Strings.globeImage) else { return  }
        guard let imageForDestroyVC = UIImage(systemName: Strings.trashImage) else { return  }
        
        viewControllers = [
            createNavigationController(for: ListAsteroidViewController(),
                                       title: Strings.titleForListVC,
                                       image: imageForListVC,
                                       tabBarTitle: Strings.tabBarTitleForListVC),
            createNavigationController(for: DestroyViewController(),
                                       title: Strings.titleForDestroyVC,
                                       image: imageForDestroyVC,
                                       tabBarTitle: Strings.tabBarTitleForDestroyVC)
        ]
    }

    // метод для создания VC
    private func createNavigationController(for viewController: UIViewController,
                                            title: String,
                                            image: UIImage,
                                            tabBarTitle: String) -> UIViewController {
        let navigationContoller = UINavigationController(rootViewController: viewController)
        navigationContoller.tabBarItem.title = tabBarTitle
        navigationContoller.tabBarItem.image = image
        navigationContoller.navigationBar.tintColor = .systemBlue
        navigationContoller.navigationBar.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 0.92)
        navigationContoller.navigationBar.prefersLargeTitles = false
        navigationContoller.navigationBar.barStyle = .default
        viewController.navigationItem.title = title
        if let font = UIFont(name: Strings.fontTitle, size: 15) {
            navigationContoller.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        }
        return navigationContoller
    }
}
