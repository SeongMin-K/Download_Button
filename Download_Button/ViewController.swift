//
//  ViewController.swift
//  Download_Button
//
//  Created by SeongMinK on 2022/01/13.
//

import UIKit
import Loady
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var myDownloadBtn: LoadyButton!
    @IBOutlet weak var uberLikeBtn: LoadyButton!
    @IBOutlet weak var fourPhaseBtn: LoadyFourPhaseButton!
    @IBOutlet weak var downloadingBtn: LoadyButton!
    @IBOutlet weak var indicatorViewBtn: LoadyButton!
    @IBOutlet weak var androidBtn: LoadyButton!
    @IBOutlet weak var fillingBtn: LoadyButton!
    @IBOutlet weak var circleBtn: LoadyButton!
    @IBOutlet weak var appStoreBtn: LoadyButton!
    @IBOutlet var myBtns: [LoadyButton]!
    
    override func loadView() {
        super.loadView()
        myDownloadBtn.layer.cornerRadius = 8
        myBtns.forEach { (btnItem: LoadyButton) in
            btnItem.layer.cornerRadius = 8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDownloadBtn.setAnimation(LoadyAnimationType.backgroundHighlighter())
        myDownloadBtn.backgroundFillColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        myDownloadBtn.addTarget(self, action: #selector(onBtnClicked(sender:)), for: .touchUpInside)
        
        uberLikeBtn.setAnimation(LoadyAnimationType.topLine())
        
        let normalPhase = (title: "대기 중", image: UIImage(systemName: "stopwatch"), background: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        let loadingPhase = (title: "진행 중", image: UIImage(systemName: "paperplane.fill"), background: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        let successPhase = (title: "완료", image: UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal), background: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        let errorPhase = (title: "실패", image: UIImage(systemName: "stopwatch"), background: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        fourPhaseBtn.loadingColor = .yellow
        fourPhaseBtn.setPhases(phases: .init(normalPhase: normalPhase,
                                             loadingPhase: loadingPhase,
                                             successPhase: successPhase,
                                             errorPhase: errorPhase))
        
        let downloadingLabel = (title: "다운로드 중...", font: UIFont.boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1))
        let percentageLabel = (font: UIFont.boldSystemFont(ofSize: 14), textColor: #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1))
        let downloadedLabel = (title: "다운로드 완료! 👏", font: UIFont.boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        downloadingBtn.backgroundFillColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        downloadingBtn.setAnimation(LoadyAnimationType.downloading(with: .init(downloadingLabel: downloadingLabel, percentageLabel: percentageLabel, downloadedLabel: downloadedLabel)))
        
        indicatorViewBtn.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .light)))
        
        androidBtn.setAnimation(LoadyAnimationType.android())
        androidBtn.backgroundFillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        androidBtn.loadingColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        fillingBtn.setAnimation(LoadyAnimationType.backgroundHighlighter())
        fillingBtn.backgroundFillColor = #colorLiteral(red: 0.9254902005, green: 0.5, blue: 0.1019607857, alpha: 1)
        
        circleBtn.setAnimation(LoadyAnimationType.circleAndTick())
        circleBtn.backgroundFillColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        circleBtn.loadingColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.9411764706, alpha: 1)
        
        appStoreBtn.setAnimation(LoadyAnimationType.appstore(with: .init(shrinkFrom: .fromLeft)))
        appStoreBtn.pauseImage = UIImage(systemName: "pause.circle")?.withTintColor(UIColor.lightGray).withRenderingMode(.alwaysOriginal)
        appStoreBtn.backgroundFillColor = .white
        appStoreBtn.loadingColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        myBtns.forEach { (btnItem: LoadyButton) in
            btnItem.addTarget(self, action: #selector(onBtnClicked(sender:)), for: .touchUpInside)
        }
    }
    
    @objc fileprivate func onBtnClicked(sender: LoadyButton) {
        print(#fileID, #function, "called")
        
        sender.stopLoading()

        // 들어온 버튼 설정
        sender.startLoading()
        if let button = sender as? LoadyFourPhaseButton {
            button.normalPhase()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                button.loadingPhase()
            }
        }
        
        // 더미 데이터 다운로드 API
        let downloadUrl = "http://ipv4.download.thinkbroadband.com/1MB.zip"
        
        let progressQueue = DispatchQueue(label: "com.Download_Button.progressQueue", qos: .utility)
        
        // 파일이 저장될 경로
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // 해당 경로에 파일이 존재한다면 지우기, 중간 폴더 만들기
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(downloadUrl, to: destination)
            .downloadProgress(queue: progressQueue) { progress in
                let loadingPercent = (Int)(progress.fractionCompleted * 100)
                print("Download Progress: \(loadingPercent) %")
                
                DispatchQueue.main.async {
                    sender.update(percent: CGFloat(loadingPercent))
                }
            }
            .response { response in
                debugPrint(response)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    sender.stopLoading()
                    if let button = sender as? LoadyFourPhaseButton {
                        button.successPhase()
                    }
                }
        }
    }
}
