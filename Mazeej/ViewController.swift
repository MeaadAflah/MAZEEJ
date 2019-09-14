//
//  ViewController.swift
//  Mazeej
//
//  Created by Fahad Almasmoum on 13/09/2019.
//  Copyright © 2019 Fahad Almasmoum. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var image1 : UIImage?
    var foodName : String?
    var calories = 0.0
    var healthLAbels : [String]?
    var diet : [String]?
    var ingrd : [String]?
    
    struct Root : Decodable {
        let hits : [hits_parse]
    }
    
    struct hits_parse : Codable{
        let recipe : recipes
        struct recipes: Codable {
            let label:String
            let ingredientLines:[String]
            let healthLabels:[String]
            let calories:Double
            let dietLabels:[String]
        }
    } // recipe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        
        
        
            }
    
    @IBAction func take_pic(_ sender: Any) {
        showPicker()
    }
    
    private func showPicker() {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        present(imagePicker, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "segue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ViewController2
        {
            let vc = segue.destination as? ViewController2
            vc?.image = image1
            vc?.food =  self.foodName
            vc?.calories = self.calories
            vc?.ingrd = self.ingrd
            vc?.diet = self.diet
            vc?.healthLAbels = self.healthLAbels
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            try? detect(image: pickedImage)
            self.image1 = pickedImage
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "segue", sender: self)}
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    

    func detect(image: UIImage) throws {
        
        let model = try VNCoreMLModel(for: MazeejML().model)
        let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    print(error as Any)
                    return
            }
            
            DispatchQueue.main.async {
                if((topResult.confidence*100) < 70.00){
                    self.foodName = "we couldnt find it"
                    }else{
                    self.foodName = "name: \(topResult.identifier) conf \(topResult.confidence*100)"
                    print(topResult.identifier)
                    
                    
                    
                    
                    // 1#
                    // POST REQUEST FROM ML  TO GET THE SEARCH LABEL AND ASSIGN IT.
                    
                    
                    let input_label = topResult.identifier
                    let search_label = input_label.replacingOccurrences(of: " ", with: "%20")
                    //print("HELLO \(search_label)")
                    // search_label  =>  topResult.identifier (HERE)
                    
                    
                    
                    let url = URL(string: "https://api.edamam.com/search?q=\(search_label)&app_id=d61f6372&app_key=98c485137718f0d4089c80dc16cfe178")!
                    URLSession.shared.dataTask(with: url) {(data, response, error) in
                        do{
                            let recs = try JSONDecoder().decode(Root.self, from: data!) // hits
                            
                            for rec in recs.hits{
                                
                                
                                
                                // 2#
                                // rec.recipe.label==search_label->
                                
                                if(rec.recipe.label==input_label){
                                     self.calories = rec.recipe.calories
                                     self.healthLAbels = rec.recipe.healthLabels
                                     self.ingrd = rec.recipe.ingredientLines
                                     self.diet = rec.recipe.dietLabels
                                    print(rec.recipe.label)
                                    print(rec.recipe.ingredientLines)
                                    print(rec.recipe.calories)
                                    print(rec.recipe.dietLabels)
                                    print(rec.recipe.healthLabels)
                                    break;
                                }
                                
                                
                                
                            }
                            
                            
                            //var hist
                        }catch{
                            print("error: \(error)")
                        }
                        
                        }.resume()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    }
                
            }
        })
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
//        extension ViewController: UIImagePickerController, UINavigationControllerDelegate {
//
//            func imagepickerController(_ picker: UIImagePickerController){
//                foodImg.image =
//            }
//        }
    }


}
