//
//  TabBarViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation

import UIKit

protocol TabBarViewControllerDelegate{
    var charactersViewModel: CharactersViewControllerDelegate {get}
    var locationsViewModel: LocationsViewControllerDelegate {get}
    
}

class TabBarViewController: UITabBarController{
    
    var viewModel: TabBarViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.orange.cgColor
        UITabBar.appearance().tintColor = UIColor.orange
        
        // Add viewcontroller images
        viewControllers?[0].tabBarItem.image = UIImage(systemName: "person.3.fill")
        
        if let viewControllers = self.viewControllers{
            for viewController in viewControllers {
                if let charactersViewController = viewController as? CharactersViewController {
                    charactersViewController.viewModel = viewModel?.charactersViewModel
                
                }
                if let locationsViewController = viewController as? LocationsViewController {
                    locationsViewController.viewModel = viewModel?.locationsViewModel
                    locationsViewController.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
                }
            }
        }
    }
}
