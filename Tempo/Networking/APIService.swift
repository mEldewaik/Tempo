//
//  APIService.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    @discardableResult
    private func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route).responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
            completion(response.result)
        }
    }
    
    
    /*==============================================================================*/
    
    //MARK:- Public
    
    func getAllNews(page:Int, searchtext: String,completion: @escaping  (AFResult<NewsListingModel>)->Void){
        performRequest(route: .getAllNews(page: page, searchText: searchtext), completion: completion)
    }
    
    /*==============================================================================*/
}
