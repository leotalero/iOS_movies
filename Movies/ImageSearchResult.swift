//
//  ImageSearchResult.swift
//  Movies
//
//  Created by Leonardo Talero on 1/28/16.
//  Copyright © 2016 unir. All rights reserved.
//

import UIKit

class ImageSearchResult {
    let imageURL:String?
    let source:String?
    let attributionURL:String?
    var image:UIImage?
    
    required init(anImageURL: String?, aSource: String?, anAttributionURL: String?) {
        imageURL = anImageURL
        source = aSource
        attributionURL = anAttributionURL
    }
    
    func fullAttribution() -> String {
        var result:String = ""
        if attributionURL != nil && attributionURL!.isEmpty == false {
            result += "Image from \(attributionURL!)"
        }
        if source != nil && source!.isEmpty == false  {
            if result.isEmpty {
                result += "Image from "
            }
            result += " \(source!)"
        }
        return result
    }
}