//
//  HTTP.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol HTTPProtocol {
    func get<T: Decodable>(endPoint: String, completion: @escaping (T?, NetworkError?) -> Void)
    func post<T: Decodable>(endPoint: String, params: Any, completion: @escaping (T?, NetworkError?) -> Void)
}

final class HTTP: HTTPProtocol {
    func get<T>(endPoint: String, completion: @escaping (T?, NetworkError?) -> Void) where T : Decodable {
        task(method: .get, endPoint: endPoint, params: nil) { (data: T?, error: NetworkError?) in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            }
        }
    }
    
    func post<T>(endPoint: String, params: Any, completion: @escaping (T?, NetworkError?) -> Void) where T : Decodable {
        task(method: .post, endPoint: endPoint, params: params) { (data: T?, error: NetworkError?) in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            }
        }
    }
}

extension HTTP {
    func task<T: Decodable>(method: HTTPMethod, endPoint: String, params: Any?, completion: @escaping(T?, NetworkError?) -> Void) {
        
        guard let url = URL(string: endPoint) else {
            completion(nil, .badUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let params = params {
            do {
                if let parametrs = params as? Data {
                    request.httpBody = parametrs
                } else {
                    let jsonData = try JSONSerialization.data(withJSONObject: params)
                    request.httpBody = jsonData
                }
            } catch {
                completion(nil, .badParams)
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as? URLError {
                if error.code == .timedOut {
                    completion(nil, .timeOut)
                } else if error.code == .notConnectedToInternet {
                    completion(nil, .internetConnection)
                } else if error.code == .badURL {
                    completion(nil, .badUrl)
                } else {
                    completion(nil, .unknown(error))
                }
            }
            
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode {
                    guard let data = data else {
                        completion(nil, .corruptedData)
                        return
                    }
                    
                    do {
                        print("--------------------------\(T.self)--------------------------")
                        print()
                        print("\(request.httpMethod!) - \(url)")
                        print()
                        if let body = request.httpBody {
                            print(try JSONSerialization.jsonObject(with: body))
                        }
                        print()
                        print(try JSONSerialization.jsonObject(with: data, options: .mutableContainers))
                        print()
                        print()
                        
                        let object = try JSONDecoder().decode(T.self, from: data)
                        completion(object, nil)
                    } catch {
                        completion(nil, .badParsing)
                    }
                } else {
                    completion(nil, .wrongCreditals)
                }
            }
        }.resume()
    }
}
