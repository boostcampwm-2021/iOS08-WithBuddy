//
//  PictureUseCase.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/30.
//

import Foundation

final class PictureUseCase {
    
    func savePicture(sourceURL: URL) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var destinationURL = URL(fileURLWithPath: path)
        destinationURL.appendPathComponent(sourceURL.lastPathComponent)
        
        let fileManager = FileManager()
        do {
            try fileManager.moveItem(at: sourceURL, to: destinationURL)
        } catch {
            return nil
        }
        
        return destinationURL
    }
    
}
