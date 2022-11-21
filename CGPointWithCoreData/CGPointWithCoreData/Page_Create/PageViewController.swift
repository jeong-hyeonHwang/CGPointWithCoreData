//
//  PageViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import UIKit

class PageViewController: UIViewController {
    
    // isModalType == false && 기존에 존재하는 데이터를 들고올 때
    var route: RouteFinding?
    
    // isModalType == true && 새롭게 데이터를 추가하는 경우
    var routeInfoForUI: RouteInfo!
    
    // 새롭게 추가할 Page에 대한 배열
    var newPageInfo: [PageInfo] = []
    
    // 새롭게 추가할 Point에 대한 배열
    var newPointInfo: [(page: Page, bodyPointInfo: [BodyPointInfo])] = []
    
    // 기존에 존재하는 데이터 중 삭제할 Page에 대한 배열
    var removePageList: [Page] = []
    
    // 기존에 존재하는 데이터 중 삭제할 BodyPoint에 대한 배열
    var removePointList: [(Page, BodyPoint)] = []
    
    // isModalType == true -> 데이터 추가를 위해 PageVC를 띄운 경우
    // isModalType == false -> 데이터 수정 및 삭제를 위해 PageVC를 띄운 경우
    var isModalType: Bool!
    
    // isModalType == false로 데이터 수정 및 삭제를 위해
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
            seperatorView.bottomAnchor.constraint(equalTo: removePointButton.topAnchor, constant: -margin),
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
        let pageInfo = PageInfo(rowOrder: routeInfoForUI.pages.count , points: [])
        routeInfoForUI.pages.append(pageInfo)
        newPageInfo.append(pageInfo)
        pageTableView.reloadData()
    }
    
    @objc func saveRouteButtonClicked() {
        if isModalType {
            DataManager.shared.addRoute(routeInfo: routeInfoForUI)
            dismiss(animated: true)
        } else {
            if let route = route {
                
                // 기존 데이터에 페이지 및 포인트 추가
                DataManager.shared.updatePageData(pageInfo: newPageInfo, routeFinding: route)
                DataManager.shared.updatePointData(pointInfo: newPointInfo)
                
                // 기존 데이터에 페이지 및 포인트 제거
                DataManager.shared.removePagesData(pages: removePageList, routeFinding: route)
                for point in removePointList
                {
                    DataManager.shared.removePointsData(points: [point.1], page: point.0)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func addBodyPointButtonClicked(index: Int) {
        let point = BodyPointInfo(footOrHand: FootOrHand.foot, isForce: false, primaryPostion: CGPoint(x: 0, y: 0), secondaryPositon: nil)
        routeInfoForUI.pages[index].points?.append(point)
        
        guard route != nil else { return }
        let indices = newPageInfo.filter({ $0.rowOrder == routeInfoForUI.pages[index].rowOrder}).indices
        
        // 페이지가 '추가될 데이터'에 존재하는 경우
        if indices.count > 0 {
            newPageInfo[indices[0]].points?.append(point)
        
        // 페이지가 '기존의 데이터'에 존재하는 경우
        } else {
            newPointInfo.append((page: pages[index], bodyPointInfo: [point]))
        }
    }
    
    @objc func removeBodyPoitButtonClickedObjc() {
        
        let pointIndex = 0
        routeInfoForUI.pages[currentPageIndex].points?.remove(at: pointIndex)
        
        // 포인트에 대한 페이지가 '기존에 데이터'로 존재하는 경우
        if pages.count > currentPageIndex {
            let points = Array(pages[currentPageIndex].points as! Set<BodyPoint>)
            if points.count > pointIndex {
                let removePointData = points[pointIndex]
                removePointList.append((pages[currentPageIndex], removePointData))
            }
        
        // 포인트에 대한 페이지가 '추가될 데이터'로 존재하는 경우
        }  else {
            guard route != nil else { return }
            let indices = newPageInfo.filter({ $0.rowOrder == routeInfoForUI.pages[currentPageIndex].rowOrder}).indices
            if indices.count > 0 {
                newPageInfo[indices[0]].points?.remove(at: pointIndex)
            }
        }
        
    }
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeInfoForUI.pages.count
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
        vc.pageInfo = routeInfoForUI.pages[index]
        
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
        let removePageInfoData = routeInfoForUI.pages[index]
        if route != nil && pages.count > index {
            let removePageData = pages[index]
            removePageList.append(removePageData)
        }
        if editingStyle == .delete {
            routeInfoForUI.pages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let indices = newPageInfo.filter({ $0.rowOrder == removePageInfoData.rowOrder}).indices
            if indices.count > 0 {
                newPageInfo.remove(at: indices[0])
            }
        }
    }
}
