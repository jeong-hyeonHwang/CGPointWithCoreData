//
//  RouteViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//

import UIKit

class RouteViewController: UIViewController {
   
    private lazy var routeTableView = {
        let view = UITableView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager.shared.deleteAllData()
        
        layoutConfigure()
        navigationBarConfigure()
    }
    
    func layoutConfigure() {
        [routeTableView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide

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
        print("Click: ADD BUTTON")
        
        let route: Route = Route(dataWrittenDate: Date(), gymName: "아띠", problemLevel: 3, isChallengeComplete: false)
        CoreDataManager.shared.createRouteFindingData(info: route)
        print(CoreDataManager.shared.readData().count)
        routeTableView.reloadData()
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.readData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for: indexPath) as! RouteTableViewCell
        
        let index = indexPath.row
        let date = CoreDataManager.shared.readData()[index].dataWrittenDate
        cell.labelConfigure(writtenDateText: date.dateToString())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print(index)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
