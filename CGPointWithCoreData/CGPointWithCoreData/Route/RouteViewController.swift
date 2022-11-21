//
//  RouteViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//

import UIKit

class RouteViewController: UIViewController {
    
    private var routeList: [RouteFinding] = DataManager.shared.getRouteFindingList()
    
    private lazy var routeTableView = {
        let view = UITableView()
        
        return view
    }()
    
    private lazy var rowLastIndex: Int = {
        return DataManager.shared.getRouteFindingList().count
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
    
    override func viewWillAppear(_ animated: Bool) {
        routeList = DataManager.shared.getRouteFindingList()
        routeTableView.reloadData()
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
        rootVC.routeInfoForUI = RouteInfo(dataWrittenDate: Date.randomBetween(start: Date(timeIntervalSince1970: 0), end: Date(timeIntervalSince1970: 30000)), gymName: "", problemLevel: 0, isChallengeComplete: false, pages: [PageInfo(rowOrder: 0, points: [])])
        rootVC.isModalType = true
        rootVC.route = nil
        
        let modalTypeNavigationVC = UINavigationController(rootViewController: rootVC)
        modalTypeNavigationVC.modalPresentationStyle = .fullScreen
        self.present(modalTypeNavigationVC, animated: true, completion: nil)
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for: indexPath) as! RouteTableViewCell
        
        let index = indexPath.row
        cell.labelConfigure(routeInfo: routeList[index])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let route = routeList[index]
        let pages = route.pages as! Set<Page>
        let pageNum = pages.count
        let indices = pages.indices.map{$0}
        print("PAGE NUM: \(pageNum)")
        
        var pointsNumStr = "POINTS NO ORDER\n[ "
        for i in 0..<pageNum {
            let pointsNum = pages[indices[i]].points?.count
            pointsNumStr += " \(String(describing: pointsNum))"
        }
        pointsNumStr += " ]"
        
        pageNumberLabel.text = "PAGE FOR \(pageNum)"
        pointsNumberLabel.text = pointsNumStr
        
        let vc = PageViewController()
        let pageArray = Array(route.pages as! Set<Page>)
        var pageInfo: [PageInfo] = []
        var points2dimensionArray: [[BodyPointInfo]] = []
        for i in 0..<pageArray.count {
            let pointsArray = Array(pageArray[i].points as! Set<BodyPoint>)
            var pointInfo: [BodyPointInfo] = []
            for j in 0..<pointsArray.count {
                let temp = BodyPointInfo(footOrHand: FootOrHand(rawValue: pointsArray[j].footOrHand) ?? FootOrHand.hand, isForce: pointsArray[j].isForce, primaryPostion: pointsArray[j].primaryPostion as! CGPoint, secondaryPosition: pointsArray[j].secondaryPosition as? CGPoint)
                pointInfo.append(temp)
            }
            points2dimensionArray.append(pointInfo)
            pageInfo.append(PageInfo(rowOrder: Int(pageArray[i].rowOrder), points: points2dimensionArray[i]))
        }
        
        vc.routeInfoForUI = RouteInfo(dataWrittenDate: route.dataWrittenDate, gymName: route.gymName, problemLevel: Int(route.problemLevel), isChallengeComplete: route.isChallengeComplete, pages: pageInfo)
        vc.isModalType = false
        vc.route = route
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print(indexPath)
            let index = indexPath.row
            DataManager.shared.deleteRouteData(route: routeList[index])
            routeList.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
