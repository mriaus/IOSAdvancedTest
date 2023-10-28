//
//  Constants.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation

//MARK: -KEYCHAIN VALUES-
enum KeychainValues {
    static let TOKEN = "KEYCHAIN_TOKEN"
}
//MARK: - API URL -
let APIBASEURL = "https://dragonball.keepcoding.education/api"

// MARK: - ENDPOINTS -
enum ENDPOINTS {
    static let LOGIN = "/auth/login"
    static let HEROES = "/heros/all"
    static let LOCATION = "/heros/locations"
}
// MARK: -Notification center names-
extension NotificationCenter {
    static let APILOGINNOTIFICATION = Notification.Name("NOTIFICATION_API_LOGIN")
    static let APILOGINFAILEDNOTIFICATION = Notification.Name("NOTIFICATION_API_LOGIN_FAILED")
    static let TOKENKEY = Notification.Name("TOKEN_KEY")
    static let ERRORLOGIN = Notification.Name("LOGIN_ERROR")
    static let STATUSCODEERROR = Notification.Name("STATUS_CODE_ERROR")
}

//MARK: - SEGUES NAMES -
enum  SegueIdentifiersValues {
    static let LOGINtoCHARACTERS = "LOGIN_TO_CHARACTERS"
    static let SPLASHtoLOGIN = "SPLASH_TO_LOGIN"
    static let CHARACTERStoLOGIN = "CHARACTERS_TO_LOGIN"
    static let SPLASHtoCHARACTERS = "SPLASH_TO_CHARACTERS"
    static let CHARACTERStoDETAIL = "CHARACTERS_TO_DETAIL"
    static let DETAILtoLOGIN = "DETAIL_TO_LOGIN"
    static let TABBARtoCHARACTERS = "TAB_TO_CHARACTERS"
    static let TABBARtoLOCATIONS = "TAB_TO_LOCATIONS"
    static let SPLASHtoTABS = "SPLASH_TO_TABS"
    static let LOGINtoTABS = "LOGIN_TO_TABS"
}

//MARK: -NETWORK ERRORS -
enum NetworkError: Error {
    case unknown
    case malformedUrl
    case decodingFailed
    case noData
    case StatusCode(code: Int?)
    case noToken
    case encodingFailed
}
