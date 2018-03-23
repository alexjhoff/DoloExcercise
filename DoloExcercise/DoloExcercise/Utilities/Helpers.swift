//
//  Helpers.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

extension String {
    public static let baseUrl = "https://api.foursquare.com/v2/venues/search"
    public static let clientId = "client_id=WTWVJKQOQATHLELVH31WZ2Q2V34M5TEQE1NE0EHYEZ31E443"
    public static let clientSecret = "client_secret=TAGFSMMES2N2D0GQQ4XO4O1ODDBN02QEIMBKBDRVVB3PZ1YA"
    public static let intent = "intent=checkin"
    public static let radius = "radius=500"
    public static let limit = "limit=20"
    public static let version = "v=20180420"
    
    static func buildLocationString(location: Location) -> String {
        var locationString = ""
        
        if let address = location.address {
            locationString += address
        }
        if let crossStreet = location.crossStreet {
            let crossStreetString = " (" + crossStreet + ")"
            locationString += crossStreetString
        }
        if let city = location.city {
            let cityString = ", " + city
            locationString += cityString
        }
        if let state = location.state,
            let zip = location.postalCode {
            let stateZipString = ", " + state + " " + zip
            locationString += stateZipString
        }
        if let country = location.country {
            let countryString = ", " + country
            locationString += countryString
        }
        return locationString
    }
    
    static func buildImageUrlString(icon: Icon) -> String? {
        guard let prefix = icon.prefix,
            let suffix = icon.suffix else { return nil }
        
        let size = "64"
        let url = prefix + size + suffix
        return url
    }
}

extension URL {
    public static func buildLocationUrl(lat: Double, long: Double) -> URL {
        let latLongString = "ll=" + String(describing: lat) + "," + String(describing: long)
        let url = .baseUrl + "?" + latLongString + "&" + .clientId + "&" + .clientSecret + "&" + .intent + "&" + .radius + "&" + .limit + "&" + .version
        return URL(string: url)!
    }
}

fileprivate let imageCache = NSCache<NSString, UIImage>()
fileprivate var imgRequest: AnyObject?

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let urlKey = urlString as NSString
        
        if let cachedItem = imageCache.object(forKey: urlKey) {
            let newImage = cachedItem.withRenderingMode(.alwaysTemplate)
            self.image = newImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }

        let imageRequest = ImageRequest(url: url)
        imgRequest = imageRequest
        imageRequest.load { (image: UIImage?) in
            if let image = image {
                DispatchQueue.main.async {
                    let newImage = image.withRenderingMode(.alwaysTemplate)
                    imageCache.setObject(newImage, forKey: urlKey)
                    self.image = newImage
                }
            }
        }
    }
}

extension UIColor {
    // Not defined by style guide
    public static let gradientPink = UIColor(red:0.85, green:0.40, blue:0.55, alpha:1.0)
    public static let gradientPurple = UIColor(red:0.48, green:0.08, blue:0.42, alpha:1.0)
    
    public static let bodyBlack = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
    
    public static let greyBorder = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
    public static let greyBackground = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    public static let greySearchBar = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
    
    // Defined by style guide
    @nonobjc class var grey3: UIColor {
        return UIColor(white: 173.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var background: UIColor {
        return UIColor(white: 231.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var grey2: UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var black2: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var black: UIColor {
        return UIColor(white: 51.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var grey4: UIColor {
        return UIColor(white: 117.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var grey1: UIColor {
        return UIColor(white: 229.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var offwhite: UIColor {
        return UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var pinkishGrey: UIColor {
        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var pinkish: UIColor {
        return UIColor(red: 218.0 / 255.0, green: 101.0 / 255.0, blue: 141.0 / 255.0, alpha: 1.0)
    }
}
// Text styles
extension UIFont {
    // Not defined by style guide
    public static let nunitoBold = UIFont.systemFont(ofSize:16.0, weight: .bold)
    public static let textStyleMedium = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    public static let textStyleRegular = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    
    // Defined by style guide
    class var h1: UIFont {
        return UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    }
    class var h2: UIFont {
        return UIFont.systemFont(ofSize: 18.0, weight: .medium)
    }
    class var textStyle: UIFont {
        return UIFont.italicSystemFont(ofSize: 18.0)
    }
    class var h3: UIFont {
        return UIFont.systemFont(ofSize: 18.0, weight: .regular)
    }
    class var base: UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }
    class var medium: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .medium)
    }
    class var small: UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: .semibold)
    }
}
