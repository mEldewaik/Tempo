//
//  NewsListingVC.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListingVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private lazy var viewModel: NewsListingViewModel = {
        return NewsListingViewModel()
    }()
    
    private (set) public var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNewsData()
        self.subscribeToLoading()
        self.subscribeToNewsResponse()
        self.bindToHiddenTableView()
        self.registerCells()
        self.bindTextFieldsToViewModel()
        self.subscribeToTextFieldSearchTitle()
    }
    
    private
    func getNewsData() {
        viewModel.getAllNews()
    }
    
    private
    func bindToHiddenTableView() {
        viewModel.isTableHiddenObservable.bind(to: view_main.rx.isHidden).disposed(by: disposeBag)
    }
    
    private
    func registerCells() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.registerNibForTable(ofType: NewsListingTableViewCell.self)
    }
    
    private
    func subscribeToNewsResponse() {
        
        viewModel.NewsListObservable.bind(to: tableView.rx.items){ [weak self] (tableView, row, article) -> UITableViewCell in
            guard let self = self else {return UITableViewCell()}
            let cell = self.tableView.dequeueCellForTable(ofType: NewsListingTableViewCell.self)
            cell.article = article
            return cell
        }.disposed(by: disposeBag)
        
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Article.self))
            .bind { [unowned self] indexPath, article in
                // go to details viewcontroller
                let vc = DetailsVC.instantiate()
                vc.articleObservable.accept(article)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let self = self else {return}
                self.loadMoreData(for: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private
    func loadMoreData(for indexPath: IndexPath) {
        let count = self.viewModel.NewsListObservable.value.count
        if indexPath.row == count - 1 {
            if self.viewModel.totalBehavior.value > count {
                self.searchBar.text == "" ? self.viewModel.searchBehavior.accept("apple") : self.viewModel.searchBehavior.accept(self.searchBar.text!)
                self.viewModel.offsetBehavior.accept(self.viewModel.offsetBehavior.value + 1)
                self.getNewsData()
            }
        }
    }
    
    private
    func subscribeToLoading() {
        viewModel.loadingBehavior.subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else {return}
            if isLoading {
                self.startAnimate()
            }else{
                self.stopAnimate()
            }
        }).disposed(by: disposeBag)

    }

}

extension NewsListingVC {
    // // For searchBar bind & subscribe
    
    private
    func bindTextFieldsToViewModel() {
        searchBar.rx.text.orEmpty.bind(to: viewModel.searchBehavior).disposed(by: disposeBag)
    }
    
    private
    func subscribeToTextFieldSearchTitle() {
        searchBar
            .rx.text // Observable property
            .orEmpty // Make it non-optional
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty.
                self.viewModel.searchBehavior.accept(query)
                self.viewModel.offsetBehavior.accept(1)
                self.getNewsData()
            })
            .disposed(by: disposeBag)

    }
}
