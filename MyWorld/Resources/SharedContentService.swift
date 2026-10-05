//
//  SharedContentService.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 5/10/2026.
//

import Foundation

struct SharedContentService {
    static let appGroup = "group.com.gracechong.MyWorld"

    static var sharedContent: String? {
        UserDefaults(suiteName: appGroup)?.string(forKey: "sharedContent")
    }

    static var sharedContentDate: Date? {
        UserDefaults(suiteName: appGroup)?.object(forKey: "sharedContentDate") as? Date
    }

    static func clear() {
        let defaults = UserDefaults(suiteName: appGroup)
        defaults?.removeObject(forKey: "sharedContent")
        defaults?.removeObject(forKey: "sharedContentDate")
    }
}
