//
//  SlideInPresentationManager.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/17/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

class SlideInPresentationManager: NSObject {

}

// MARK: - UIViewControllerTransitioningDelegate
extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = AddFoodPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }

}


