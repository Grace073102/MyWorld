//
//  MediaItemModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation

struct MediaItemModel: Identifiable, Equatable {
    let id: UUID
    var fileName: String
    var mediaType: String
    var createdDate: Date
    var placeID: UUID
}
