//
//  Translating.swift
//  Tripo
//
//  Created by Huiying Lin on 2/5/2023.
//

import UIKit

struct TranslatedText: Codable {
    var translatedText: String
}


class Translating: UIViewController {
    @IBOutlet weak var userInput: UITextField!
    
    @IBOutlet var ouputText: UILabel!
    
    @IBAction func translate(_ sender: Any) {
        Task {
            URLSession.shared.invalidateAndCancel()
            await requestoutput(userInput.text!)
        }
        
    }
    
    var FROM :String = "en"
    var TO :String = "ja"
    
    let REQUEST_STRING = "https://libretranslate.com/translate"
    
    
    func requestoutput(_ inputText: String) async {
        
        print(inputText)
        
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "libretranslate.com"
        searchURLComponents.path = "/translate"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "source", value: "\(FROM)"),
            URLQueryItem(name: "target", value: "\(TO)"),
            URLQueryItem(name: "format", value: "text"),
            URLQueryItem(name: "api_key", value: ""),
            URLQueryItem(name: "q", value: inputText)
        ]
        
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        let urlRequest = URLRequest(url: requestURL)
        
        do {
            let  (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            let trans = try decoder.decode(TranslatedText.self, from: data)
            
            ouputText?.text = trans.translatedText
            print(trans.translatedText)
 
        }
        catch let error {
            print(error)
        }
        
    }
}
