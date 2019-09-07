//
//  NetworkManager.swift
//  8-Ball
//
//  Created by Pasha Moroz on 9/4/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    var link = "https://8ball.delegator.com/magic/JSON/%3Cquestion_string%3E"
    
    func fetchDataWithAlamofire(url: String, completion: @escaping (Answer) -> ()) {
        
        request(url).responseData { (dataResponse) in
            
            switch dataResponse.result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode(Answer.self, from: data) else {
                    return
                }
                completion(data)
            case .failure(let error):
                print(error)
                
            }
        }
    }
}

struct NetworkState {
    
    var isConnected: Bool {
        
        return NetworkReachabilityManager(host: NetworkManager.shared.link)!.isReachable
    }
}
