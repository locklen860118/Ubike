//
//  ViewController.swift
//  JsonTest
//
//  Created by Chris on 2020/5/13.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getBikeData()
    }
    var shopName:[String] = []
    var shopCity:[String] = []
    
    func getBikeData() {
        let address = "http://e-traffic.taichung.gov.tw/DataAPI/api/YoubikeAllAPI"
        
        
        if let url = URL(string: address) {
            // GET
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // 假如錯誤存在，則印出錯誤訊息（ 例如：網路斷線等等... ）
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                  // 取得 response 和 data
                } else if let response = response as? HTTPURLResponse,let data = data {
                    // 將 response 轉乘 HTTPURLResponse 可以查看 statusCode 檢查錯誤（ ex: 404 可能是網址錯誤等等... ）
                    print("Status code: \(response.statusCode)")
                    // 創建 JSONDecoder 解析 json 檔
                    let decoder = JSONDecoder()
                    // decode 從 json 解碼，返回一個指定類型的值，這個類型必須符合 Decodable 協議
                    
                    if let UBikeData = try? decoder.decode([uBikeData].self, from: data) {
                        
                        print("============== Bike data ==============")
                        print(UBikeData)
                        print("============== Bike data ==============")
                        
                    }
                    
                }
                }.resume()
        } else {
            print("Invalid URL.")
        }
    }

}

