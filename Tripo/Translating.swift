//
//  Translating.swift
//  Tripo
//
//  Created by Huiying Lin on 2/5/2023.
//

import UIKit
import Foundation



class Translating: UIViewController {
    @IBOutlet weak var userInput: UITextField!
    
    @IBOutlet weak var outputText: UITextView!

    
    @IBAction func translate(_ sender: Any) {
        Task {
            URLSession.shared.invalidateAndCancel()
            await requestoutput(userInput.text!)
        }
        
    }
    
    var FROM :String = "en"
    var TO :String = "ja"
    
    let REQUEST_STRING = "https://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=hello"
    
    
    func requestoutput(_ inputText: String) async {
        
        print(inputText)
        
        
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "fanyi.youdao.com"
        searchURLComponents.path = "/translate"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "doctype", value: "json"),
            URLQueryItem(name: "type", value: "AUTO"),
            URLQueryItem(name: "i", value: inputText)
        ]



        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }
        print(requestURL)
        let urlRequest = URLRequest(url: requestURL)

        do {
            let  (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            let trans = try decoder.decode(TranslatedText.self, from: data)
            let inner:Translation_inner = trans.text![0][0]
            outputText.text = inner.translated
            print(inner.text)

        }
        catch let error {
            print(error)
        }
        
    }
}
