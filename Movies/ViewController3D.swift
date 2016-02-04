//
//  3dViewController.swift
//  Movies
//
//  Created by Leonardo Talero on 2/3/16.
//  Copyright © 2016 unir. All rights reserved.
//

import UIKit

class ViewController3D:UIViewController
{

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location) else { return nil }
        
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) else { return nil }
        
        
        
    }
    
}
