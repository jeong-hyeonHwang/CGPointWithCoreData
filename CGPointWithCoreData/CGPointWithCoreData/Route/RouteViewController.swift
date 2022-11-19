//
//  RouteViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//

import UIKit

class RouteViewController: UIViewController {
   
    var routeFindingList: [RouteFinding] = CoreDataManager.shared.readRouteFindingData()
    
    private lazy var routeTableView = {
        let view = UITableView()
        
        return view
    }()
    
    private lazy var rowLastIndex: Int = {
        return routeFindingList.count
    }()
    
    private lazy var routeInfoView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var pageNumberLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var pointsNumberLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 5
        
        return label
    }()
    
    override func viewDidLoad() {
        
        layoutConfigure()
        navigationBarConfigure()
        
    }
    
    func layoutConfigure() {
        [routeTableView, routeInfoView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [pageNumberLabel, pointsNumberLabel].forEach({
            routeInfoView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide
        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([
            routeInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            routeInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            routeInfoView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            routeInfoView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            pointsNumberLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            pointsNumberLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            pointsNumberLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            pointsNumberLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            pageNumberLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            pageNumberLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            pageNumberLabel.bottomAnchor.constraint(equalTo: pointsNumberLabel.topAnchor, constant: -margin),
            pageNumberLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            routeTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            routeTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            routeTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            routeTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        routeTableView.delegate = self
        routeTableView.dataSource = self
        routeTableView.register(RouteTableViewCell.self,
                      forCellReuseIdentifier: RouteTableViewCell.identifier)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "ROUTE VC"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addRouteButtonClicked))
    }
}

extension RouteViewController {
    @objc func addRouteButtonClicked() {
        let rootVC = PageViewController()
        rootVC.routeInfo = RouteInfo(dataWrittenDate: Date(), gymName: "", problemLevel: 0, isChallengeComplete: false, pages: [PageInfo(rowOrder: 0, points: [])])
        
        let modalTypeNavigationVC = UINavigationController(rootViewController: rootVC)
        modalTypeNavigationVC.modalPresentationStyle = .fullScreen
        self.present(modalTypeNavigationVC, animated: true, completion: nil)
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeFindingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for: indexPath) as! RouteTableViewCell
        
        let index = indexPath.row
        cell.labelConfigure(routeIndex: index)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let route = CoreDataManager.shared.readRouteFindingData()[index]
        let pages = route.pages as! Set<Page>
        let pageNum = pages.count
        let indices = pages.indices.map{$0}
        print("TABLE VIEW ROW TOUCHED")
        print("PAGE NUM: \(pageNum)")
        
        var pointsNumStr = "POINTS NO ORDER\n[ "
        for i in 0..<pageNum {
            let pointsNum = pages[indices[i]].points?.count
            pointsNumStr += " \(pointsNum)"
        }
        pointsNumStr += " ]"
        
        pageNumberLabel.text = "PAGE FOR \(pageNum)"
        pointsNumberLabel.text = pointsNumStr
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
