//
//  DepartamentoCollectionViewController.swift
//  SGalindoEcommerce
//

import UIKit

private let reuseIdentifier = "AreaDepartamentoCell"

class DepartamentoCollectionViewController: UICollectionViewController {
    
    var idArea : Int = 0
    
    var result = Result()
    var departamento  = Departamento()
    var departamentos : [Departamento] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(idArea)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        LoadData()
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "AreaDepartamentoCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }

    
    
    // MARK: - LoadData
    
    func LoadData(){
        
        do {
            result = try! Departamento.GetByArea(idArea)
            if result.Correct {
                departamentos = result.Objects as! [Departamento]
                collectionView.reloadData()
            }
        }catch {
            
            print("Ocurrio un error")
        }
    }
    
    
   
   
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return departamentos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AreaDepartamentoCell
    
        departamento = departamentos[indexPath.row]
        cell.labelNombre.text = departamento.Nombre
    
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

        self.departamento = self.departamentos[indexPath.row]
        print(self.departamento.IdDepartamento)
        self.performSegue(withIdentifier: "filtroDepartamento", sender: self)
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "filtroDepartamento" {
                let idDepartamentoSend = segue.destination as? ProductoCollectionViewController
                idDepartamentoSend?.idDepartamento = self.departamento.IdDepartamento
                
                
                
            }
        }
}
