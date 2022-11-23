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
    
    private lazy var routeInfoUpdateButton = {
        let button = UIButton()
        button.setTitle("Route Info Update", for: .normal)
        button.setTitleColor(.yellow, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        layoutConfigure()
        componentConfigure()
        navigationBarConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        routeList = DataManager.shared.getRouteFindingList().sorted(by: { $0.dataWrittenDate > $1.dataWrittenDate })
        routeTableView.reloadData()
    }
    
    func layoutConfigure() {
        [routeTableView, routeInfoView, routeInfoUpdateButton].forEach({
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
            routeInfoUpdateButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            routeInfoUpdateButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            routeInfoUpdateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin),
            routeInfoUpdateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            routeInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            routeInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            routeInfoView.bottomAnchor.constraint(equalTo: routeInfoUpdateButton.topAnchor, constant: -margin),
            routeInfoView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            pointsNumberLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            pointsNumberLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            pointsNumberLabel.bottomAnchor.constraint(equalTo: routeInfoView.bottomAnchor),
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
    
    func componentConfigure() {
        routeInfoUpdateButton.addTarget(self, action: #selector(routeInfoUpdateButtonClicked), for: .touchUpInside)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "ROUTE VC"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addRouteButtonClicked))
    }
}

extension RouteViewController {
    
    @objc func addRouteButtonClicked() {
        let rootVC = RenewalPageViewController()
        rootVC.routeDM = RouteDataManager(routeFinding: nil)
//        rootVC.routeInfoForUI = RouteInfo(dataWrittenDate: Date.randomBetween(start: Date(timeIntervalSince1970: 0), end: Date(timeIntervalSince1970: 30000)), gymName: "", problemLevel: 0, isChallengeComplete: false, pages: [PageInfo(rowOrder: 0, points: [])])
//        rootVC.isModalType = true
        
        
        let modalTypeNavigationVC = UINavigationController(rootViewController: rootVC)
        modalTypeNavigationVC.modalPresentationStyle = .fullScreen
        self.present(modalTypeNavigationVC, animated: true, completion: nil)
    }
    
    @objc func routeInfoUpdateButtonClicked() {
        if routeList.count > 0 {
            let index = Int.random(in: 0..<routeList.count)
            
            let tempRouteInfo = RouteInfo(dataWrittenDate: Date.randomBetween(start: Date(timeIntervalSince1970: 100000), end: Date(timeIntervalSince1970: 200000)), gymName: "클라라", problemLevel: 5, isChallengeComplete: true, pages: [])
            DataManager.shared.updateRoute(routeInfo: tempRouteInfo, route: routeList[index])
            
            print("ROUTE INFO UPDATE!")
            routeTableView.reloadData()
        }

    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.getRouteFindingList().count
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
        
        let vc = RenewalPageViewController()
        let pageArray = Array(route.pages as! Set<Page>)
        var pageInfo: [PageInfo] = []
        var points2dimensionArray: [[BodyPointInfo]] = []
        for i in 0..<pageArray.count {
            let pointsArray = Array(pageArray[i].points as! Set<BodyPoint>)
            var pointInfo: [BodyPointInfo] = []
            for j in 0..<pointsArray.count {
                let temp = BodyPointInfo(footOrHand: FootOrHand(rawValue: pointsArray[j].footOrHand) ?? FootOrHand.hand, isForce: pointsArray[j].isForce, primaryPosition: CGPoint(x: pointsArray[j].primaryXCoordinate, y: pointsArray[j].primaryYCoordinate), secondaryPosition: CGPoint(x: pointsArray[j].secondaryXCoordinate, y: pointsArray[j].secondaryYCoordinate))
                pointInfo.append(temp)
            }
            points2dimensionArray.append(pointInfo)
            pageInfo.append(PageInfo(rowOrder: Int(pageArray[i].rowOrder), points: points2dimensionArray[i]))
        }
        
        vc.routeDM = RouteDataManager(routeFinding: route)
        vc.routeDM.routeInfoForUI = RouteInfo(dataWrittenDate: route.dataWrittenDate, gymName: route.gymName, problemLevel: Int(route.problemLevel), isChallengeComplete: route.isChallengeComplete, pages: pageInfo)
        vc.routeDM.route = route
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let index = indexPath.row
            DataManager.shared.deleteRouteData(route: routeList[index])
            routeList.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}
