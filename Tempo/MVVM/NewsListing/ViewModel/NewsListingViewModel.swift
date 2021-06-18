//
//  NewsListingViewModel.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class NewsListingViewModel {
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var searchBehavior = BehaviorRelay<String>(value: "apple")
    var offsetBehavior = BehaviorRelay<Int>(value: 1)
    var totalBehavior = BehaviorRelay<Int>(value: 0)
    var errorBehavior = BehaviorRelay<String>(value: "")
    
    private (set) public var newsSubject = BehaviorRelay<[Article]>(value: [])
    private (set) public var isTableHidden = BehaviorRelay<Bool>(value: true)
    
    var NewsListObservable: BehaviorRelay<[Article]> {
        return newsSubject
    }
    
    var isTableHiddenObservable: Observable<Bool> {
        return isTableHidden.asObservable()
    }
    
    func getAllNews() {
        loadingBehavior.accept(true)
        let request = APIRouter.getAllNews(page: offsetBehavior.value, searchText: searchBehavior.value)
        AF.request(request).responseDecodable { [weak self] (response:AFDataResponse<NewsListingModel>) in
            guard let self = self else {return}
            self.loadingBehavior.accept(false)
            switch response.result{
            case .success(let newsListing):
                
                guard let articles = newsListing.articles else {
                    self.isTableHidden.accept(true)
                    return
                }
                
                self.totalBehavior.accept(newsListing.totalResults ?? 0)
                
                self.isTableHidden.accept(false)
                                
                if self.offsetBehavior.value == 1 {
                    self.newsSubject.accept(articles)
                }else{
                    self.newsSubject.accept(self.newsSubject.value + articles)
                }
                
            case .failure(let error):
                print("error in getting news:\(error)")
                self.errorBehavior.accept("\(error.localizedDescription)")
            }
        }
    }
    
}
