//
//  PageViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import UIKit

// 정렬
// 기존 데이터 수정하기

class PageViewController: UIViewController {
    
    // isModalType == false && 기존에 존재하는 데이터를 들고올 때
    var route: RouteFinding?
    
    // isModalType == true && 새롭게 데이터를 추가하는 경우
    var routeInfoForUI: RouteInfo!
    
    // 새롭게 추가할 Page에 대한 배열
    var newPageInfo: [PageInfo] = []
    
    // 새롭게 추가할 Point에 대한 배열
    var newPointInfo: [Page : [BodyPointInfo]] = [:]
    
    // 기존에 존재하는 Page의 Point 데이터 중 삭제할 Point에 대한 배열
    var updatePointInfo: [Page: [(BodyPoint, BodyPointInfo)]] = [:]
    
    // 기존에 존재하는 데이터 중 삭제할 Page에 대한 배열
    var removePageList: [Page] = []
    
    // 기존에 존재하는 데이터 중 삭제할 BodyPoint에 대한 배열
    var removePointList: [Page : [BodyPoint]] = [:]
    
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
    
    private lazy var updatePointButton = {
        let button = UIButton()
        button.setTitle("UPDATE POINT", for: .normal)
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
        [pageTableView, seperatorView, addPageButton, saveRouteButton, removePointButton, updatePointButton].forEach({
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
            updatePointButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            updatePointButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            updatePointButton.bottomAnchor.constraint(equalTo: removePointButton.topAnchor, constant: -margin),
            updatePointButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: updatePointButton.topAnchor, constant: -margin),
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
        
        removePointButton.addTarget(self, action: #selector(removeBodyPointButtonClickedObjc), for: .touchUpInside)
        
        updatePointButton.addTarget(self, action: #selector(updatePointDataObjc), for: .touchUpInside)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "MAKE NEW ROUTE VC"
    }
}

extension PageViewController {
    
    // MARK: CREATE PAGE
    @objc func addPageButtonClicked() {
        let pageInfo = PageInfo(rowOrder: routeInfoForUI.pages.count , points: [])
        
        routeInfoForUI.pages.append(pageInfo)
        newPageInfo.append(pageInfo)
        
        pageTableView.reloadData()
    }
    
    // MARK: SAVE DATA(ROUTE)
    @objc func saveRouteButtonClicked() {
        if isModalType {
            DataManager.shared.addRoute(routeInfo: routeInfoForUI)
            dismiss(animated: true)
        } else {
            if let route = route {
                
                // CREATE & UPDATE
                // 기존 데이터에 새로운 페이지(+ 하위의 새로운 포인트) 추가
                DataManager.shared.updatePageData(pageInfo: newPageInfo, routeFinding: route)
                // 기존 데이터, 기존 페이지에 새로운 포인트 추가
                DataManager.shared.addPointData(pointInfo: newPointInfo)
                
                // DELETE
                // 기존 데이터의 페이지 제거
                DataManager.shared.deletePagesData(pages: removePageList, routeFinding: route)
                //  기존 데이터, 기존 페이지에 존재하는 포인트 제거
                DataManager.shared.deletePointsData(removePointList: removePointList)
                
                // UPDATE
                // 기존 데이터, 기존 페이지에 존재하는 포인트 수정
                if updatePointInfo.isEmpty == false {
                    DataManager.shared.updatePointData(pointInfo: updatePointInfo)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: CREATE POINT
    func addBodyPointButtonClicked(index: Int) {
        
        let point = BodyPointInfo(footOrHand: FootOrHand.foot, isForce: false, primaryPosition: CGPoint(x: 0, y: 0), secondaryPosition: CGPoint(x:0, y:0))
        routeInfoForUI.pages[index].points?.append(point)
        
        // UI를 구성하는 데이터에 추가
        guard route != nil else { return }
        let indices = newPageInfo.filter({ $0.rowOrder == routeInfoForUI.pages[index].rowOrder}).indices
        
        // 페이지가 '추가될 데이터'에 존재하는 경우
        if indices.count > 0 {
            newPageInfo[indices[0]].points?.append(point)
        
        // 페이지가 '기존의 데이터'에 존재하는 경우
        } else {
            if newPointInfo[pages[index]] == nil {
                newPointInfo[pages[index]] = []
            }
            newPointInfo[pages[index]]?.append(point)
            print(newPointInfo[pages[index]]?.count)
        }
    }
    
    // MARK: DELETE POINT
    @objc func removeBodyPointButtonClickedObjc() {
        
        // UI를 구성하는 데이터에서 삭제
        guard let points = routeInfoForUI.pages[currentPageIndex].points else { return }
        if points.count == 0 { return }
        let pointIndex = Int.random(in: 0..<points.count)
        if points.count > 0 {
            routeInfoForUI.pages[currentPageIndex].points?.remove(at: pointIndex)
        }
        
        // 포인트에 대한 페이지가 '기존에 데이터'로 존재하는 경우
        if pages.count > currentPageIndex {
            print("기존 데이터입니다.")
            let points = Array(pages[currentPageIndex].points as! Set<BodyPoint>)
            if points.count > pointIndex {
                let removePointData = points[pointIndex]
                if removePointList[pages[currentPageIndex]] == nil {
                    removePointList[pages[currentPageIndex]] = []
                }
                removePointList[pages[currentPageIndex]]?.append(removePointData)
            }
        
        // 포인트에 대한 페이지가 '추가될 데이터'로 존재하는 경우
        }  else {
            print("추가될 데이터입니다.")
            guard route != nil else { return }
            let indices = newPageInfo.filter({ $0.rowOrder == routeInfoForUI.pages[currentPageIndex].rowOrder}).indices
            if indices.count > 0 {
                newPageInfo[indices[0]].points?.remove(at: pointIndex)
            } else {
            }
        }
    }
    
    // MARK: UPDATE POINT
    @objc func updatePointDataObjc() {
        
        let pageIndex = 0
        let page = routeInfoForUI.pages[pageIndex]
        let before: BodyPointInfo = routeInfoForUI.pages[pageIndex].points![0]
        let afterPoint: BodyPointInfo = BodyPointInfo(footOrHand: FootOrHand.foot, isForce: true, primaryPosition: CGPoint(x: 3, y: 3), secondaryPosition: CGPoint(x: 4, y: 4))
        
        // 기존 Page인가?
        if pages.filter({$0.rowOrder == page.rowOrder}).count > 0 {

            let points = Array(pages[pageIndex].points as! Set<BodyPoint>)
            let point = points.filter({ CGPoint(x: $0.primaryXCoordinate, y: $0.primaryYCoordinate) == before.primaryPosition })
            
            // 기존 Page에 존재하는 기존 Point
            if point.count > 0 {
                if updatePointInfo[pages[pageIndex]] == nil {
                    updatePointInfo[pages[pageIndex]] = []
                }
                updatePointInfo[pages[pageIndex]]?.append((point[0], afterPoint))
            } else {
                guard let indices = newPointInfo[pages[pageIndex]]?.filter({$0 == before}).indices else { return }
   
                newPointInfo[pages[pageIndex]]?[indices[0]] = afterPoint
            }
        } else {
            print("기존에 존재하지 않는 페이지입니다.")
            let indices = newPageInfo.filter({ $0.rowOrder == page.rowOrder }).indices
            if indices.count > 0 {
                guard let pointIndices = newPageInfo[indices[0]].points?.filter({ $0 == before }).indices else { return }
                newPageInfo[indices[0]].points?[pointIndices[0]] = afterPoint
            }
        }
        
        // UI를 구성하는 데이터에서 업데이트(수정)
        guard let routeInfoForUIIndex = routeInfoForUI.pages[pageIndex].points?.firstIndex(of: before) else { return }
        routeInfoForUI.pages[pageIndex].points?[routeInfoForUIIndex] = afterPoint
        
        
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let index = indexPath.row
        addBodyPointButtonClicked(index: index)
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
