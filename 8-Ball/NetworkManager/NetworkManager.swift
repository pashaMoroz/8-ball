//
//  NetworkManager.swift
//  8-Ball
//
//  Created by Pasha Moroz on 9/4/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    var link = "https://8ball.delegator.com/magic/JSON/%3Cquestion_string%3E"
    
    func fetchData(url: String, completion: @escaping (Answer?) -> ()) {
        
        request(url).responseData { (dataResponse) in
            
            switch dataResponse.result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode(Answer.self, from: data) else {
                    completion(nil)
                    return 
                }
                completion(data)
            case .failure :
                completion(nil)
            }
        }
    }
}

struct NetworkState {
    
    var isConnected: Bool {
        
        let networkManager = NetworkManager()
        return NetworkReachabilityManager(host: networkManager.link)!.isReachable
    }
}
