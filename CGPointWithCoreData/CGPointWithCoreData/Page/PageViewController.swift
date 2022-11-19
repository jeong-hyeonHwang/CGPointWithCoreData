//
//  PageViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import UIKit

class PageViewController: UIViewController {

    var routeInfo: RouteInfo!
    
    private lazy var pageTableView = {
        let view = UITableView()
        
        return view
    }()
    
    private lazy var seperatorView = {
        let view = UIView()
        view.backgroundColor = .yellow
        
        return view
    }()
    
    private lazy var addPageButton = {
        let button = UIButton()
        button.setTitle("ADD PAGE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.yellow.cgColor
    
        return button
    }()
    
    private lazy var saveRouteButton = {
        let button = UIButton()
        button.setTitle("SAVE ROUTE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.yellow.cgColor
    
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        componentConfigure()
        navigationBarConfigure()
    }
    
    func layoutConfigure() {
        [pageTableView, seperatorView, addPageButton, saveRouteButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide

        let margin: CGFloat = 16
        let buttonHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            saveRouteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            saveRouteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            saveRouteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            saveRouteButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            addPageButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            addPageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            addPageButton.bottomAnchor.constraint(equalTo: saveRouteButton.topAnchor, constant: -margin),
            addPageButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: addPageButton.topAnchor, constant: -margin),
            seperatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        
        NSLayoutConstraint.activate([
            pageTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pageTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pageTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            pageTableView.bottomAnchor.constraint(equalTo: seperatorView.topAnchor, constant: -margin)
        ])
        

    }
    
    func componentConfigure() {
        pageTableView.delegate = self
        pageTableView.dataSource = self
        pageTableView.register(PageTableViewCell.self,
                      forCellReuseIdentifier: PageTableViewCell.identifier)
        
        view.backgroundColor = .black
        pageTableView.backgroundColor = .black
        
        addPageButton.addTarget(self, action: #selector(addPageButtonClicked), for: .touchUpInside)
        
        saveRouteButton.addTarget(self, action: #selector(saveRouteButtonClicked), for: .touchUpInside)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "MAKE NEW ROUTE VC"
    }
}

extension PageViewController {
    @objc func addPageButtonClicked() {
        routeInfo.pages.append(PageInfo(rowOrder: routeInfo.pages.count , points: []))
        print(routeInfo.pages.count)
        pageTableView.reloadData()
    }
    
    @objc func saveRouteButtonClicked() {
        CoreDataManager.shared.createRouteFindingData(routeInfo: routeInfo)
        dismiss(animated: true)
    }
    func addBodyPointButtonClicked(index: Int) {
        routeInfo.pages[index].points?.append(BodyPointInfo(footOrHand: FootOrHand.foot, isForce: false, primaryPostion: CGPoint(x: 0, y: 0), secondaryPositon: nil))
        print("ADD POINTS FOR \(routeInfo.pages[index].points?.count)")
    }
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeInfo.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PageTableViewCell.identifier, for: indexPath) as! PageTableViewCell
        
        let index = indexPath.row
        cell.numberLabel.text = "PAGE \(index)"
//        CoreDataManager.shared.readPageData(routeFinding: routeFinding)[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("CURRENT SELECTED PAGE: \(index)")
        let vc = BodyPointListViewController()
        vc.pageInfo = routeInfo.pages[index]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let index = indexPath.row
        addBodyPointButtonClicked(index: index)
    }
}
