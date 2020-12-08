//
//  TabBarControler.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

class TabBarController: UITabBarController {
    
    var controllers: [UIViewController] = []
    
    init(controllers: [UIViewController]) {
        self.controllers = controllers
        
        super.init(nibName: nil, bundle: nil)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        
        let tabBar = self.tabBar
        tabBar.standardAppearance = appearance
        tabBar.backgroundImage = nil
        tabBar.tintColor = .black
        tabBar.backgroundColor = .clear
        tabBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setViewControllers(self.controllers, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
