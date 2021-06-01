//
//  HTTPClient.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

class HTTPClient {
    
    static let shared = HTTPClient()
    private init() {}
    
    class HTTPClient {
        func downloadImageFromURL(_ url: String) -> UIImage? {
            let url = URL(string: url)
            guard let data = try? Data(contentsOf: url!),
              let imageObtained = UIImage(data: data) else {
                return nil
            }
            return imageObtained
        }
    }
}
