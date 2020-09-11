//
//  Network.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/7/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation
import Alamofire

typealias Success<T> = (_ data: T) -> Void
typealias Failure = (_ error: ErrorModel, _ statusCode: Int) -> Void

class Network {
    
    // MARK: - constants
    
    static let shared = Network()
    
    // MARK: - Private Variables
    
    private let baseURL = "https://easyloan.humo.tj/v2/"
    private var headers = ["version": "201000"]
    
    
    // MARK: - Initialization
    
    private init() { }
    
    func request<T: Decodable>(url: String, method: HTTPMethod,
                               parameters: Parameters? = nil,
                               headers: [String: String]? = nil,
                               isQueryString: Bool = false,
                               success: @escaping Success<T>,
                               feilure: @escaping Failure) {
        
        if let headers = headers {
            self.headers.merge(headers) { (_, new) in new }
        }
        
        let fullPath = self.baseURL + url
        guard let url = URL(string: fullPath) else { return }
        
        Alamofire.request(
            url, method: method, parameters: parameters,
            encoding: (isQueryString ? URLEncoding.queryString : JSONEncoding.default),
            headers: self.headers)
            .responseData { (response) in
                
                if let request = response.request {
                    if let body = request.httpBody {
                        if let str = String(bytes: body, encoding: .utf8) {
                            //print("Request: \(request)")
                            //print("Body: " + str)
                        }
                    }
                    
                }
                
                if let json = response.result.value {
                    if let str = String(bytes: json, encoding: .utf8) {
                        //print(response.result)
                        //print("Code: \(response.response?.statusCode)")
                        //print("Json: " + str)
                        
                    }
                }
                
                switch (response.result) {
                case .success(let data):
                    guard let code = response.response?.statusCode else { return }
                    switch code {
                    case 200...299:
                        if let json = try? JSONDecoder().decode(T.self, from: data) {
                            success(json)
                        }
                        break
                    case 401:
                        UserDefaults.standard.setLoggedOutUser()
                        AppDelegate.shared.rootViewController.switchToLogout()
                        feilure(.init(msg: "Не авторизован", tj: ""), 401)
                        return
                    case 400...500:
                        if let errorJson = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                            guard let code = response.response?.statusCode else { return }
                            feilure(errorJson, code)
                            return
                        }
                        break
                    default: break
                    }
                    break
                case .failure(let error):
                    feilure(.init(msg: error.localizedDescription, tj: ""), 404)
                    break
                }
        }
    }
    
    
    func delete(url: String,
                headers: [String: String]? = nil,
                success: @escaping () -> Void,
                feilure: @escaping (Error) -> Void) {
        
        if let headers = headers {
            self.headers.merge(headers) { (_, new) in new }
        }
        
        let fullPath = self.baseURL + url
        guard let url = URL(string: fullPath) else { return }
        
        Alamofire.request(
            url, method: .delete, parameters: nil,
            encoding: JSONEncoding.default, headers: self.headers)
            .responseData { (response) in
                switch (response.result) {
                case .success( _):
                    guard let code = response.response?.statusCode else { return }
                    switch code {
                    case 200...299:
                        success()
                        break
                    case 401:
                        UserDefaults.standard.setLoggedOutUser()
                        AppDelegate.shared.rootViewController.switchToLogout()
                        break
                    case 400...500:
                        break
                    default: break
                    }
                    break
                case .failure(let error):
                    feilure(error)
                    break
                }
        }
    }
    
    func downloadImage(fileId: String, success: @escaping ((UIImage) -> Void)) {
        let headers = [ "version": "201000", "auth-token": UserDefaults.standard.getUser().token]
        let fullPath = self.baseURL + URLPath.downloadFile + "\(fileId)/"
        guard let url = URL(string: fullPath) else { return }
        Alamofire.request(
            url, method: .get, parameters: nil, encoding: JSONEncoding.default,
            headers: headers)
            .response { (response) in
                guard let data = response.data else { return }
                guard let image = UIImage(data: data) else { return }
                success(image)
        }
    }
    
    func uploadImage<T: Decodable>(id: Int, type: String, image: UIImage,
                                    success: @escaping Success<T>,
                                    feilure: @escaping Failure) {
        
        let fullPath = self.baseURL + URLPath.uploadFile + "\(id)/" + "\(type)/" + self.randomString(length: 8)
        let parametrs: [String: Any] = ["type": type]
        let headers = [ "version": "201000", "auth-token": UserDefaults.standard.getUser().token]
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        guard let url = URL(string: fullPath) else { return }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "img", fileName: "img.jpeg", mimeType: "image/jpeg")
            for (key, value) in parametrs {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }, to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(request: let uploaded, _, _):
                uploaded.responseJSON(completionHandler: { (response) in
                    guard let code = response.response?.statusCode else { return }
                    guard let data = response.data else { return }
                    switch code {
                    case 200...299:
                        if let json = try? JSONDecoder().decode(T.self, from: data) {
                            success(json)
                        }
                        break
                    case 400...500:
                        if let errorJson = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                            guard let code = response.response?.statusCode else { return }
                            feilure(errorJson, code)
                        }
                    default: break
                    }
                })
                break
            case .failure(let error):
                feilure(.init(msg: error.localizedDescription, tj: ""), 404)
                break
            }
        }
    }
    
    
    func syncWithCFT(id: String, success: @escaping () -> Void) {
        let fullPath = self.baseURL + URLPath.syncWithCFT + id
        let headers = [ "version": "201000", "auth-token": UserDefaults.standard.getUser().token]
        guard let url = URL(string: fullPath) else { return }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData(completionHandler: { (response) in
            switch response.result {
            case .success(_):
                guard let code = response.response?.statusCode else { return }
                switch code {
                case 200:
                    success()
                    break
                default: break
                }
                break
            case .failure(_):
                break
            }
        })
    }
    
    private func randomString(length: Int) -> String {
        let letters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM123456789"
        return String((0..<length).map{_ in letters.randomElement()!})
    }
}
