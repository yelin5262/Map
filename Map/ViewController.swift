//
//  ViewController.swift
//  Map
//
//  Created by 김예린 on 2022/04/05.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도를 최고로 설정
        locationManager.requestWhenInUseAuthorization()           // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.startUpdatingLocation()                   // 위치 업데이트를 시작
        myMap.showsUserLocation = true                            // 위치 보기 값 true
    }

    func goLocation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtitudeValue)      // 위도값, 경도값
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)     // 범위값
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    // 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
    func setAnnotation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtitudeValue: longtitudeValue, delta: span)
        
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longtitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)  // 1의 값보다 지도를 100배 확대
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            
            if pm!.locality != nil {    // pm 상수에서 도로 값이 존재하면
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
        })
        
        locationManager.stopUpdatingLocation()     // 위치 업데이트 멈춤
    }
    
    // 세그먼트 컨트롤을 선택하였을 때 호출
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // 현재 위치 표시
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        }
        else if sender.selectedSegmentIndex == 1 { // 폴리텍대학 표시
            setAnnotation(latitudeValue: 37.751853, longtitudeValue: 128.87605740000004, delta: 1, title: "한국폴리텍대학 강릉캠퍼스", subtitle: "강원도 강릉시 남산초교길 121")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "한국폴리텍대학 강릉캠퍼스"
        }
        else if sender.selectedSegmentIndex == 2 { // 이지스퍼블리싱 표시
            setAnnotation(latitudeValue: 37.556876, longtitudeValue: 126.914066, delta: 0.1, title: "이지스퍼블리싱", subtitle: "서울시 마포구 잔다리로 109 이지스 빌딩")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "이지스퍼블리싱 출판사"
        }
        else if sender.selectedSegmentIndex == 3 {
            setAnnotation(latitudeValue: 37.552519726543196, longtitudeValue: 126.9095893500982, delta: 0.01, title: "우리학교", subtitle: "서울특별시 마포구 와우산로 94")
            self.lblLocationInfo1.text = "우리학교"
            self.lblLocationInfo2.text = "홍익대학교"
        }
    }
}
