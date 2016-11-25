//
//  ViewController.swift
//  savePicture
//
//  Created by zero plus on 2016/11/25.
//  Copyright © 2016年 zeroplus. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITableViewDataSource {

    var photoArray: [String] = []
    
    @IBOutlet weak var photoTableView: UITableView!
    var img: UIImage?
    
    //拍照
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    //手機相簿
    @IBAction func getAlbum(_ sender: Any) {
        //建立一個ImagePickerController
        let imagePicker = UIImagePickerController()
        // 設定影像來源 這裡設定為相簿
        imagePicker.sourceType = .photoLibrary
        // 設置 delegate
        imagePicker.delegate = self
        // 顯示相簿
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //取得照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print("info \(info)")
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        img = image
        
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let interval = Date.timeIntervalSinceReferenceDate
        let name = "\(interval).jpg"
        
        let url = docUrl?.appendingPathComponent(name)
        let data = UIImageJPEGRepresentation(image, 0.9)
        try! data?.write(to: url!)

        self.dismiss(animated:true, completion: nil)
        
        //儲存
        photoArray.append(name)
        saveFile()
        
        //重整Table
        photoTableView.reloadData()
    }
    
    
    //儲存紀錄位址的photoArray
    func saveFile(){
        let fileManager = FileManager.default
        
        let docUrls = fileManager.urls(for: .documentDirectory, in:
                .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("photoArray.txt")
        let array = photoArray
        (array as NSArray).write(to: url!, atomically: true)
    }
    
    //讀取紀錄位址的photoArray
    func loadFile(){
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in:
                .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("photoArray.txt")
        
        if let array = NSArray(contentsOf: url!){
           photoArray = array as! [String]
        }
//        print("read")
//        print(url!)
//        print(photoArray)
        
        photoTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let cells = ceil(Double(photoArray.count)/3)
        return Int(cells)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //與UI連結
        let cell = tableView.dequeueReusableCell(withIdentifier: "showPhotos", for: indexPath)
        let imageView1 = cell.contentView.viewWithTag(1) as! UIImageView
        let imageView2 = cell.contentView.viewWithTag(2) as! UIImageView
        let imageView3 = cell.contentView.viewWithTag(3) as! UIImageView
        
        //計算圖片在畫面上的位置
        let photoIndex1 = ((indexPath.row + 1) * 3) - 3
        let photoIndex2 = ((indexPath.row + 1) * 3) - 2
        let photoIndex3 = ((indexPath.row + 1) * 3) - 1
        
        //讀取圖片
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first

        //把圖片放到Table
        if indexPath.row + 1 == Int(ceil(Double(photoArray.count)/3)){
            let url1 = docUrl?.appendingPathComponent(photoArray[photoIndex1])
            imageView1.image = UIImage(contentsOfFile: (url1?.path)!)
            
            if (photoArray.count) % 3 == 0 || (photoArray.count) % 3 == 2 {
                let url2 = docUrl?.appendingPathComponent(photoArray[photoIndex2])
                imageView2.image = UIImage(contentsOfFile: (url2?.path)!)
            }
            
            if (photoArray.count) % 3 == 0 {
                let url3 = docUrl?.appendingPathComponent(photoArray[photoIndex3])
                imageView3.image = UIImage(contentsOfFile: (url3?.path)!)
            }
        }else{
            let url1 = docUrl?.appendingPathComponent(photoArray[photoIndex1])
            imageView1.image = UIImage(contentsOfFile: (url1?.path)!)
            
            let url2 = docUrl?.appendingPathComponent(photoArray[photoIndex2])
            imageView2.image = UIImage(contentsOfFile: (url2?.path)!)
            
            let url3 = docUrl?.appendingPathComponent(photoArray[photoIndex3])
            imageView3.image = UIImage(contentsOfFile: (url3?.path)!)
        }
    
        return cell
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

