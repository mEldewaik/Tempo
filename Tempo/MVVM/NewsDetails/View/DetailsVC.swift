//
//  DetailsVC.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 18/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsVC: UIViewController {

    @IBOutlet weak var img_article: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_author: UILabel!
    @IBOutlet weak var lbl_source: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var btn_showSource: UIButton!
    
    
    var articleObservable = BehaviorRelay<Article?>(value: nil)
    private (set) public var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribeToArticleObservable()
        self.subscribeToShowSourceButton() 
    }
    
    private
    func subscribeToArticleObservable() {
        articleObservable.subscribe(onNext: { [weak self] article in
            guard let self = self else {return}
            HelperMethods.configureImage(article?.urlToImage, self.img_article, "")
            self.lbl_title.text = article?.title
            self.lbl_desc.text = article?.articleDescription
            self.lbl_author.text = article?.author
            self.lbl_source.text = article?.source?.name
            self.lbl_content.text = article?.content
            guard let publishDate = article?.publishedAt, !(publishDate.isEmpty) else {return}
            self.lbl_date.text = Date().timeAgo(from: self.convertStringToDate(stringDate: publishDate))
        }).disposed(by: disposeBag)
    }
    
    private
    func subscribeToShowSourceButton() {
        btn_showSource
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                
                guard let urlString = self.articleObservable.value?.url else { return }
                if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let url = URL(string: encoded) {
                    UIApplication.shared.open(url)
                }

            }).disposed(by: disposeBag)
    }
    
    private
    func convertStringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:stringDate)!
        
        return date
    }

}

extension DetailsVC {
    static func instantiate() -> DetailsVC {
        let sb = UIStoryboard(name: "Details", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        return vc
    }
}
