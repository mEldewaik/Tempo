//
//  NewsListingTableViewCell.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import UIKit
import Kingfisher

class NewsListingTableViewCell: UITableViewCell {

    @IBOutlet weak var img_news: UIImageView!
    @IBOutlet weak var lbl_descr: UILabel!
    @IBOutlet weak var lbl_source: UILabel!
    
    
    var article: Article? {
        didSet{
            HelperMethods.configureImage(article?.urlToImage, self.img_news, "")
            self.lbl_descr.text = article?.articleDescription
            self.lbl_source.text = article?.source?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.img_news.layer.cornerRadius = 3.3
    }
    
}
