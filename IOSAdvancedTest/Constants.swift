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
