//
//  APIRouter.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import Foundation
import Alamofire

enum ServerMode {
    case live
    case stage
    case imgesBaseUrl
}

enum APIRouter:URLRequestConvertible{
    
    static var serverMode: ServerMode = .live
    
    static func baseURL() -> URL {
        if APIRouter.serverMode == .live {
            return URL(string: "https://newsapi.org/v2/")!
        }else{
            return URL(string: "")!
        }
    }
    /*==========================================================================================*/
    
    case getAllNews(page:Int, searchText: String)

    
    /*==========================================================================================*/
    
    var method: HTTPMethod {
        switch self {

        case .getAllNews: return .get
        }
    }
    
    /*==========================================================================================*/
    
    private var path: URL {
        let base = APIRouter.baseURL()
        
        switch self {
        case .getAllNews:
            return base.appendingPathComponent("everything")
        }
    }
    
    /*==========================================================================================*/
    
    func asURLRequest() throws -> URLRequest {
        
        var params = Parameters()
        var urlRequest = URLRequest(url: path)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        
        case .getAllNews(page: let page, searchText: let search):
            params = [
                "q": search,
                "page": page,
                "apiKey": Constants.AppSetting.API_KEY
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }

        return urlRequest
    }
}

