//
//  AreaCollectionViewController.swift
//  SGalindoEcommerce
//


import UIKit

private let reuseIdentifier = "AreaDepartamentoCell"

class AreaCollectionViewController: UICollectionViewController {
    
    
    var result = Result()
    var area = Area()
    var areas : [Area] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        LoadData()  
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "AreaDepartamentoCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.

    }
    
    
    func LoadData(){
        
        do{
            result = try! Area.GetAll()
            if result.Correct{
                areas = result.Objects as! [Area]
                collectionView.reloadData()
                
            }
        }catch {
            print("Ocurrio un error")
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return areas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AreaDepartamentoCell
        
        area = areas[indexPath.row]
        cell.labelNombre.text = area.Nombre
    
        
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)    {

        self.area = self.areas[indexPath.row]
        print(self.area.IdArea)
        self.performSegue(withIdentifier: "filtroArea", sender: self)
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "filtroArea" {
                let idAreaSend = segue.destination as? DepartamentoCollectionViewController
                idAreaSend?.idArea = self.area.IdArea
                
                
                
            }
        }

}
