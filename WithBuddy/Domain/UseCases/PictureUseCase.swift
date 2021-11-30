//
//  PictureUseCase.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/30.
//

import Foundation

final class PictureUseCase {
    
    func savePicture(sourceUrl: URL) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var destinationUrl = URL(fileURLWithPath: path)
        destinationUrl.appendPathComponent(sourceUrl.lastPathComponent)
        
        let fileManager = FileManager()
        do {
            try fileManager.moveItem(at: sourceUrl, to: destinationUrl)
        } catch {
            return nil
        }
        
        return destinationUrl
    }
    
}
