//
//  Services.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation

class Services {
    static let shared = Services()
    
    func fetchWord(_ word: String, completion: @escaping([Word]?, Error?) -> Void) {
        var url = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        url = url.replacingOccurrences(of: " ", with: "-")
        guard let URL = URL(string: url) else { return }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let httpRequest = session.dataTask(with: request) { result in
            switch result {
            case .success((_, let data)):
                do {
                    let decoder = JSONDecoder()
                    let word = try decoder.decode([Word].self, from: data)
                    completion(word, nil)
                    return
                } catch {
                    completion(nil, error)
                    return
                }
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
        httpRequest.resume()
    }
    
    func downloadAudioFromAPI(url: URL, completion: @escaping(URL?)->Void){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
            completion(URL)
        })
        downloadTask.resume()
    }
}
