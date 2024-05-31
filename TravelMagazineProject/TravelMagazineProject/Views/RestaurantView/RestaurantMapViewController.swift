//
//  RestaurantMapViewController.swift
//  TravelMagazineProject
//
//  Created by user on 5/30/24.
//

import MapKit
import UIKit

final class RestaurantMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, RestaurantListDelegate, UISheetPresentationControllerDelegate {
    
    let restaurantMapView: MKMapView = MKMapView()
    
    let searchBar: UISearchBar = UISearchBar()
    let searchButton: UIButton = UIButton()
    
    let buttonScrollView: UIScrollView = UIScrollView()
    var buttonStackView: UIStackView = UIStackView()
    
    let restaurantList: [Restaurant] = RestaurantList().restaurantArray
    lazy var filteredRestaurantList: [Restaurant] = restaurantList
    
    lazy var filteredAnnotations: [MKAnnotation] = []
    
    lazy var initialMapCenter = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Coordinate.sesacLatitude, longitude: Coordinate.sesacLongitude), latitudinalMeters: Coordinate.defaultLatitudinalMeters, longitudinalMeters: Coordinate.defaultLongitudinalMeters)
    
    let sheetVC = RestaurantListViewController()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutMapView()
        layoutSearchBarArea()
        layoutButtonScrollView()
        
        configureMapData()
        
        
        searchBar.delegate = self
        sheetVC.delegate = self
        sheetVC.sheetPresentationController?.delegate = self
        
        restaurantMapView.region = initialMapCenter
        
        showRestaurantList()
    }
    
    private func layoutMapView() {
        self.view.addSubview(restaurantMapView)
        
        restaurantMapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restaurantMapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            restaurantMapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            restaurantMapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            restaurantMapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func layoutSearchBarArea() {
        layoutSearchBar()
        layoutSearchButton()
    }
    
    private func layoutSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        restaurantMapView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: restaurantMapView.topAnchor, constant: ScreenSize.navigationBarConstant),
            searchBar.leadingAnchor.constraint(equalTo: restaurantMapView.leadingAnchor, constant: 16),
        ])
    }
    
    private func layoutSearchButton() {
        restaurantMapView.addSubview(searchButton)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: restaurantMapView.trailingAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 1),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 1)
        ])
        
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.image = UIImage(systemName: "arrow.turn.up.right")
        config.title = "길찾기"
        config.titleAlignment = .center
        
        
        searchButton.configuration = config
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = .systemBlue
        searchButton.layer.cornerRadius = 8
    }
    
    // MARK: 버튼 스크롤뷰 우측 끝으로 이동하면 버튼들이 튕기는 현상 -> CollectionView로 해결
    // MARK: 연산 줄이기
    private func layoutButtonScrollView() {
        for i in 0..<RestaurantList.shared.numberOfCategories {
            let category = RestaurantList.shared.categories[i]
            
            let button = UIButton()
            button.backgroundColor = .white
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray5.cgColor
            button.setTitle(category, for: .normal)
            button.setTitleColor(.black, for: .normal)
            
            button.addTarget(self, action: #selector(filterButtonTapepd), for: .touchUpInside)
            button.tag = i
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 100)
            ])
            
            buttonStackView.addArrangedSubview(button)
        }
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        
        buttonScrollView.addSubview(buttonStackView)
        
        restaurantMapView.addSubview(buttonScrollView)
        
        buttonScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonScrollView.frameLayoutGuide.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            buttonScrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            buttonScrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: restaurantMapView.trailingAnchor),
            buttonScrollView.heightAnchor.constraint(equalTo: restaurantMapView.heightAnchor, multiplier: 0.1),
            
            
            buttonScrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
            buttonScrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor, constant: 16)
        ])
        
        buttonScrollView.showsHorizontalScrollIndicator = false
        buttonScrollView.alwaysBounceHorizontal = false
        buttonScrollView.alwaysBounceVertical = false
    }
    
    private func configureMapData() {
        configureAnnotations()
        addAnnotationsToMap()
    }
    
    private func configureAnnotations() {
        restaurantMapView.removeAnnotations(filteredAnnotations)
        filteredAnnotations = []
        filteredRestaurantList.forEach { restaurant in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            filteredAnnotations.append(annotation)
        }
    }
    
    private func addAnnotationsToMap() {
        filteredAnnotations.forEach { annotation in
            restaurantMapView.addAnnotation(annotation)
        }
    }
    
    
    @objc
    func filterButtonTapepd(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            filterRestaurant(with: text)
        }
    }
    
    private func filterRestaurant(with filter: String) {
        if filter.isEmpty || filter == "전체" {
            filteredRestaurantList = restaurantList
        } else {
            filteredRestaurantList = restaurantList.filter {
                $0.name.localizedStandardContains(filter) || $0.category.localizedStandardContains(filter)
            }
        }
        
        configureMapData()
        sheetVC.fetchRestaurantListFromDelegate()
    }
    
    // MARK: 왜 storyboard로 init한게 아닌 그냥 init한 viewController들은 background들이 없지
    private func showRestaurantList() {
        sheetVC.isModalInPresentation = true
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large(), .custom(resolver: {context in
                return 50
            })]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        
        self.present(sheetVC, animated: true)
    }
    
    internal func fetchFilteredList() -> [Restaurant] {
        return filteredRestaurantList
    }
    
    internal func moveToAnnotation(for restaurant: Restaurant) {
        let coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        restaurantMapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: Coordinate.defaultLatitudinalMeters, longitudinalMeters: Coordinate.defaultLongitudinalMeters)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            filterRestaurant(with: text)
        }
        searchBar.resignFirstResponder()
    }
}
