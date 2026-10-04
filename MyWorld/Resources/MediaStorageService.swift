//
//  MediaStorageService.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation

final class MediaStorageService {

    static let shared = MediaStorageService()

    private init() {}

    private var mediaDirectory: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directory = documentsDirectory.appendingPathComponent("Media", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }

        return directory
    }

    func save(data: Data, fileExtension: String) throws -> String {
        let fileName = "\(UUID().uuidString).\(fileExtension)"
        let fileURL = mediaDirectory.appendingPathComponent(fileName)

        try data.write(to: fileURL)

        return fileName
    }

    func fileURL(for fileName: String) -> URL {
        mediaDirectory.appendingPathComponent(fileName)
    }

    func delete(fileName: String) throws {
        let fileURL = fileURL(for: fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}
