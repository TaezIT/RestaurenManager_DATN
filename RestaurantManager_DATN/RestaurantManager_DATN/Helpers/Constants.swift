//
//  Constants.swift
//  BaoThanhNien
//
//  Created by Pham Tuan Anh on 02/11/2022.
//

import Foundation
import UIKit

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate



struct Constants {
    //DEV
//    static let SecretKey = "vpab35UtRvBeJC7w"
//    static let BookMarkKey = "KveF8FdN5rYX7mjF"
    //PROD
    
    struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
}

struct FontName {
    static let kFontSFProRegular = "SFProDisplay-Regular"
    static let kFontSFProDisplayBlack = "SFProDisplay-Black"
    static let kFontSFProDisplayBlackItalic = "SFProDisplay-BlackItalic"
    static let kFontSFProDisplayBold = "SFProDisplay-Bold"
    static let kFontSFProDisplayHeavy = "SFProDisplay-Heavy"
    static let kFontSFProDisplayHeavyItalic = "SFProDisplay-HeavyItalic"
    static let kFontSFProDisplayLight = "SFProDisplay-Light"
    static let kFontSFProDisplayLightItalic = "SFProDisplay-LightItalic"
    static let kFontSFProDisplayMedium = "SFProDisplay-Medium"
    static let kFontSFProDisplayMediumItalic = "SFProDisplay-MediumItalic"
    static let kFontSFProDisplayRegularItalic = "SFProDisplay-RegularItalic"
    static let kFontSFProDisplaySemibold = "SFProDisplay-Semibold"
    static let kFontSFProDisplaySemiboldItalic = "SFProDisplay-SemiboldItalic"
    static let kFontSFProDisplayThin = "SFProDisplay-Thin"
    static let kFontSFProDisplayThinItalic = "SFProDisplay-ThinItalic"
    static let kFontSFProDisplayUltralight = "SFProDisplay-Ultralight"
    static let kFontSFProDisplayUltralightItalic = "SFProDisplay-UltralightItalic"
    static let kFontSFProDisplayItalic = "SFProDisplay-Italic"
    
    static let kFontSanMedium = "SanFranciscoDisplay-Medium"
    static let kFontSanRegular = "SanFranciscoDisplay-Regular"
    static let kFontSanBold  = "SanFranciscoDisplay-Bold"
    static let kFontSanSemiBold = "SanFranciscoDisplay-Semibold"
    
    static let kFontNotoRegular = "NotoSerif"
    static let kFontNotoBold  = "NotoSerif-Bold"
    static let kFontNotoSemiBold = "NotoSerif-SemiBold"
    
    static let kArial = "Arial"
    static let kArialFontBold = "Arial-BoldMT"
    
    static let kMerriweatherBold = "Merriweather-Bold"
    static let kMerriweatherRegular = "Merriweather-Regular"
    
    static let kInterRegular = "Inter-Regular"
    static let kInterSemiBold = "Inter-Semibold"
    static let kInterBold = "Inter-Bold"
    
    static let kRoboto = "Roboto-Regular"
}
