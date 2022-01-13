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
    @IBOutlet var myDownloadBtn: LoadyButton!
    
    override func loadView() {
        super.loadView()
        myDownloadBtn.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDownloadBtn.setAnimation(LoadyAnimationType.backgroundHighlighter())
        myDownloadBtn.backgroundFillColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        myDownloadBtn.addTarget(self, action: #selector(onBtnClicked(sender:)), for: .touchUpInside)
    }
    
    @objc fileprivate func onBtnClicked(sender: LoadyButton) {
        print(#fileID, #function, "called")
        
        // 들어온 버튼 설정
        sender.startLoading()
        
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
        }
    }
}
