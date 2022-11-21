//
//  PageViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import UIKit

class PageViewController: UIViewController {
    
    var route: RouteFinding?
    var routeInfo: RouteInfo!
    var newPageInfo: [PageInfo] = []
    var newPointInfo: [(page: Page, bodyPointInfo: [BodyPointInfo])] = []
    var removePage: [Page] = []
    var removePoint: [(Page, BodyPoint)] = []
    var isModalType: Bool!
    private var pages: [Page] = []
    
    private var addPointMode: Bool = true
    
    private var currentPageIndex: Int = 0
    
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
    
    private lazy var removePointButton = {
        let button = UIButton()
        button.setTitle("REMOVE POINT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.blue.cgColor
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if route != nil {
            pages = Array(route?.pages as! Set<Page>)
        }
        
        layoutConfigure()
        componentConfigure()
        navigationBarConfigure()
    }
    
    func layoutConfigure() {
        [pageTableView, seperatorView, addPageButton, saveRouteButton, removePointButton].forEach({
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
            removePointButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            removePointButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            removePointButton.bottomAnchor.constraint(equalTo: addPageButton.topAnchor, constant: -margin),
            removePointButton.heightAnchor.constraint(equalToConstant: buttonHeight)
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
        
        removePointButton.addTarget(self, action: #selector(removeBodyPoitButtonClickedObjc), for: .touchUpInside)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "MAKE NEW ROUTE VC"
    }
}

extension PageViewController {
    @objc func addPageButtonClicked() {
        let pageInfo = PageInfo(rowOrder: routeInfo.pages.count , points: [])
        routeInfo.pages.append(pageInfo)
        newPageInfo.append(pageInfo)
        pageTableView.reloadData()
    }
    
    @objc func saveRouteButtonClicked() {
        if isModalType {
            DataManager.shared.addRoute(routeInfo: routeInfo)
            dismiss(animated: true)
        } else {
            DataManager.shared.updatePageData(pageInfo: newPageInfo, routeFinding: route!)
            DataManager.shared.updatePointData(pointInfo: newPointInfo)
            if let route = route {
                DataManager.shared.removePagesData(pages: removePage, routeFinding: route)
                for temp in removePoint
                {
                    DataManager.shared.removePointsData(points: [temp.1], page: temp.0)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func addBodyPointButtonClicked(index: Int) {
        let point = BodyPointInfo(footOrHand: FootOrHand.foot, isForce: false, primaryPostion: CGPoint(x: 0, y: 0), secondaryPositon: nil)
        routeInfo.pages[index].points?.append(point)
        
        guard route != nil else { return }
        let indices = newPageInfo.filter({ $0.rowOrder == routeInfo.pages[index].rowOrder}).indices
        if indices.count > 0 {
            newPageInfo[indices[0]].points?.append(point)
        } else {
            newPointInfo.append((page: pages[index], bodyPointInfo: [point]))
        }
    }
    
    func removeBodyPointButtonClicked(pageIndex: Int, pointIndex: Int) {
        
        let points = Array(pages[pageIndex].points as! Set<BodyPoint>)
        if points.count > pointIndex {
            let removePointData = points[pointIndex]
            removePoint.append((pages[pageIndex], removePointData))
        } else {
            let indices = newPointInfo.filter({ $0.page.rowOrder == pages[pageIndex].rowOrder}).indices
            if indices.count > 0 {
                newPointInfo.remove(at: indices[0])
            }
        }
    }
    
    @objc func removeBodyPoitButtonClickedObjc() {
        
        let pointIndex = 0
        if pages.count > currentPageIndex {
            let points = Array(pages[currentPageIndex].points as! Set<BodyPoint>)
            if points.count > pointIndex {
                let removePointData = points[pointIndex]
                removePoint.append((pages[currentPageIndex], removePointData))
            }
        }  else {
            guard route != nil else { return }
            let indices = newPageInfo.filter({ $0.rowOrder == routeInfo.pages[currentPageIndex].rowOrder}).indices
            if indices.count > 0 {
                routeInfo.pages[currentPageIndex].points?.remove(at: pointIndex)
                newPageInfo[indices[0]].points?.remove(at: pointIndex)
            }
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = BodyPointListViewController()
        vc.pageInfo = routeInfo.pages[index]
        
        navigationController?.pushViewController(vc, animated: true)
        currentPageIndex = index
        print("CURRENT PAGE INDEX IS \(currentPageIndex)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let index = indexPath.row
        addBodyPointButtonClicked(index: index)
//        removeBodyPointButtonClicked(pageIndex: index, pointIndex: 0)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let removePageInfoData = routeInfo.pages[index]
        if route != nil && pages.count > index {
            let removePageData = pages[index]
            removePage.append(removePageData)
        }
        if editingStyle == .delete {
            routeInfo.pages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let indices = newPageInfo.filter({ $0.rowOrder == removePageInfoData.rowOrder}).indices
            if indices.count > 0 {
                newPageInfo.remove(at: indices[0])
            }
        }
    }
}
