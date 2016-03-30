//
//  ViewController.swift
//  Raiz Pic
//
//  Created by Marco on 8/11/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

// dados das keys de id e cliente do Parse
// https://www.parse.com/apps/quickstart?#parse_data/mobile/ios/swift/existing

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView ()
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBAction func buttonPause(sender: AnyObject) {

        // o (0,0) é relativo à posição que ele está, no caso, o centro da tela
        activityIndicator = UIActivityIndicatorView (frame: CGRectMake(0, 0, 50, 50))
        
        // centraliza no meio da tela o activity indicator
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true

        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        // adiciona na View
        view.addSubview (activityIndicator)
        
        activityIndicator.startAnimating ()
        
        // desabilita os cliques e outros eventos. porém, se fizer isso, trava tudo e não dá pra voltar
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    @IBAction func buttonRestore(sender: AnyObject) {
        activityIndicator.stopAnimating()
        
        //UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @IBAction func buttonCreateAlert(sender: AnyObject) {
    
        var alert = UIAlertController (title: "Hey There!", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction (title: "OK", style: .Default, handler: {
            action in
            
            self.dismissViewControllerAnimated (true, completion: nil)
        }))
        
        self.presentViewController (alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonPickImage(sender: AnyObject) {
        var image = UIImagePickerController ()
        
        image.delegate   = self
        
        // pega da câmera do iPhone. No simulador dá erro e crasha o app
        //image.sourceType = UIImagePickerControllerSourceType.Camera
        
        // pega a imagem da galeria de fotos
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

        // users cannot change the image (pan, crop)
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    // função que é chamada depois que a imagem é escolhida
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imagePicked.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // salvando no parse (PF = Parse Object)
        var score = PFObject (className: "score")
        
        // coloca 2 variáveis dentro do objeto
        score.setObject ("Marco", forKey: "name")
        score.setObject (95,      forKey: "number")

        // outra maneira de salvar objetos
        // score ["name"] = "Marco"
        // score ["number"] = 95
        
        // salva no backend do Parse
        score.saveInBackgroundWithBlock {
            
            (success : Bool, error : NSError?) -> Void in
            
            if success == true {
                // The object has been saved
                println ("Score created with ID: \(score.objectId!)")
            } else {
                // There was a problem, check error.description
                println (error)
            }
        }
        
        // obtendo dados do Parse
        var query = PFQuery (className: "score")
        
        // em caso de sucesso, retorna o objeto
        query.getObjectInBackgroundWithId("iCeHlClvdS") {
            
            (score: PFObject?, error: NSError?) -> Void in
            
            // o erro é nulo caso não ocorra nenhum erro
            if error != nil || score == nil {
                println (error)
                
            // pq precisa do score = score???????
            } else if let score = score {
                
                // obter elemento
                println (score.objectForKey("name") as! NSString)
                
                score ["name"]   = "Robert"
                score ["number"] = 137
                
                // tem a função .save() também que pode ser usada
                score.saveInBackground()
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
