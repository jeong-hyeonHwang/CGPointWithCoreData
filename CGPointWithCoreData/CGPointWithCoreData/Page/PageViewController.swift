//
//  PageViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import UIKit

class PageViewController: UIViewController {

    var routeFinding: RouteFinding!
    
    private lazy var rowLastIndex: Int = {
        return CoreDataManager.shared.readPageData(routeFinding: routeFinding).count
    }()
    
    private lazy var pageTableView = {
        let view = UITableView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        navigationBarConfigure()
    }
    
    func layoutConfigure() {
        [pageTableView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            pageTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pageTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pageTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            pageTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        pageTableView.delegate = self
        pageTableView.dataSource = self
        pageTableView.register(PageTableViewCell.self,
                      forCellReuseIdentifier: PageTableViewCell.identifier)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "PAGE VC"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPageButtonClicked))
    }
}

extension PageViewController {
    @objc func addPageButtonClicked() {
        CoreDataManager.shared.createPageData(rowOrder: rowLastIndex, routeFinding: routeFinding)
        rowLastIndex += 1
        pageTableView.reloadData()
    }
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.readPageData(routeFinding: routeFinding).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PageTableViewCell.identifier, for: indexPath) as! PageTableViewCell
        
        let index = indexPath.row
        cell.numberLabel.text = String(index)
//        CoreDataManager.shared.readPageData(routeFinding: routeFinding)[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
