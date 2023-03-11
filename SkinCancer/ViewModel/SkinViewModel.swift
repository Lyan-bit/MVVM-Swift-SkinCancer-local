//
//  SkinViewModel.swift
//  Diet Pro
//
//  Created by Lyan Alwakeel on 26/09/2022.
//

import Foundation

/* This code requires OclFile.swift */

func initialiseOclFile()
{
  createByPKOclFile(key: "System.in")
  createByPKOclFile(key: "System.out")
  createByPKOclFile(key: "System.err")
}

/* This metatype code requires OclType.swift */

func initialiseOclType()
{ let intOclType = createByPKOclType(key: "int")
  intOclType.actualMetatype = Int.self
  let doubleOclType = createByPKOclType(key: "double")
  doubleOclType.actualMetatype = Double.self
  let longOclType = createByPKOclType(key: "long")
  longOclType.actualMetatype = Int64.self
  let stringOclType = createByPKOclType(key: "String")
  stringOclType.actualMetatype = String.self
  let sequenceOclType = createByPKOclType(key: "Sequence")
  sequenceOclType.actualMetatype = type(of: [])
  let anyset : Set<AnyHashable> = Set<AnyHashable>()
  let setOclType = createByPKOclType(key: "Set")
  setOclType.actualMetatype = type(of: anyset)
  let mapOclType = createByPKOclType(key: "Map")
  mapOclType.actualMetatype = type(of: [:])
  let voidOclType = createByPKOclType(key: "void")
  voidOclType.actualMetatype = Void.self
    
  let skinCancerOclType = createByPKOclType(key: "SkinCancer")
  skinCancerOclType.actualMetatype = SkinCancer.self

  let skinCancerId = createOclAttribute()
        skinCancerId.name = "id"
        skinCancerId.type = stringOclType
        skinCancerOclType.attributes.append(skinCancerId)
  let skinCancerDates = createOclAttribute()
        skinCancerDates.name = "dates"
        skinCancerDates.type = stringOclType
        skinCancerOclType.attributes.append(skinCancerDates)
  let skinCancerImages = createOclAttribute()
        skinCancerImages.name = "images"
        skinCancerImages.type = stringOclType
        skinCancerOclType.attributes.append(skinCancerImages)
  let skinCancerOutcome = createOclAttribute()
        skinCancerOutcome.name = "outcome"
        skinCancerOutcome.type = stringOclType
        skinCancerOclType.attributes.append(skinCancerOutcome)
}

func instanceFromJSON(typeName: String, json: String) -> AnyObject?
    { let jdata = json.data(using: .utf8)!
      let decoder = JSONDecoder()
      if typeName == "String"
      { let x = try? decoder.decode(String.self, from: jdata)
          return x as AnyObject
      }
  return nil
    }

class SkinViewModel: ObservableObject {
    var db : DB?
        
    // path of document directory for SQLite database (absolute path of db)
    let dbpath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    var fileSystem : FileAccessor = FileAccessor()
    static var instance : SkinViewModel? = nil

    static func getInstance() -> SkinViewModel {
        if instance == nil
         { instance = SkinViewModel() }
        return instance! }
                              
    init() {
        // init
        db = DB.obtainDatabase(path: "\(dbpath)/myDatabase.sqlite3")
        loadSkinCancer()
    }
          
    @Published var currentSkinCancer : SkinCancerVO? = SkinCancerVO.defaultSkinCancerVO()
    @Published var currentSkinCancers : [SkinCancerVO] = [SkinCancerVO]()

    func createSkinCancer(x : SkinCancerVO) {
          let res : SkinCancer = createByPKSkinCancer(key: x.id)
                res.id = x.id
        res.dates = x.dates
        res.images = x.images
        res.outcome = x.outcome
          currentSkinCancer = x
          do { try db?.createSkinCancer(skinCancervo: x) }
          catch { print("Error creating SkinCancer") }
    }
        
    func cancelCreateSkinCancer() {
        //cancel function
    }
    
    func deleteSkinCancer(id : String) {
          if db != nil
          { db!.deleteSkinCancer(val: id) }
             currentSkinCancer = nil
    }
        
    func cancelDeleteSkinCancer() {
        //cancel function
    }
            
    func cancelEditSkinCancer() {
        //cancel function
    }

    func cancelSearchSkinCancer() {
    //cancel function
    }
    
    func loadSkinCancer() {
        let res : [SkinCancerVO] = listSkinCancer()
        
        for (_,x) in res.enumerated() {
            let obj = createByPKSkinCancer(key: x.id)
            obj.id = x.getId()
        obj.dates = x.getDates()
        obj.images = x.getImages()
        obj.outcome = x.getOutcome()
            }
         currentSkinCancer = res.first
         currentSkinCancers = res
        }
        
          func listSkinCancer() -> [SkinCancerVO] {
            if db != nil
            { currentSkinCancers = (db?.listSkinCancer())!
              return currentSkinCancers
            }
            currentSkinCancers = [SkinCancerVO]()
            let list : [SkinCancer] = SkinCancerAllInstances
            for (_,x) in list.enumerated()
            { currentSkinCancers.append(SkinCancerVO(x: x)) }
            return currentSkinCancers
        }
                
        func stringListSkinCancer() -> [String] {
            currentSkinCancers = listSkinCancer()
            var res : [String] = [String]()
            for (_,obj) in currentSkinCancers.enumerated()
            { res.append(obj.toString()) }
            return res
        }
                
        func getSkinCancerByPK(val: String) -> SkinCancer? {
            var res : SkinCancer? = SkinCancer.getByPKSkinCancer(index: val)
            if res == nil && db != nil
            { let list = db!.searchBySkinCancerid(val: val)
            if list.count > 0
            { res = createByPKSkinCancer(key: val)
            }
          }
          return res
        }
                
        func retrieveSkinCancer(val: String) -> SkinCancer? {
            let res : SkinCancer? = getSkinCancerByPK(val: val)
            return res
        }
                
        func allSkinCancerids() -> [String] {
            var res : [String] = [String]()
            for (_,item) in currentSkinCancers.enumerated()
            { res.append(item.id + "") }
            return res
        }
                
        func setSelectedSkinCancer(x : SkinCancerVO)
            { currentSkinCancer = x }
                
        func setSelectedSkinCancer(i : Int) {
            if 0 <= i && i < currentSkinCancers.count
            { currentSkinCancer = currentSkinCancers[i] }
        }
                
        func getSelectedSkinCancer() -> SkinCancerVO?
            { return currentSkinCancer }
                
        func persistSkinCancer(x : SkinCancer) {
            let vo : SkinCancerVO = SkinCancerVO(x: x)
            editSkinCancer(x: vo)
        }
            
        func editSkinCancer(x : SkinCancerVO) {
            let val : String = x.id
            let res : SkinCancer? = SkinCancer.getByPKSkinCancer(index: val)
            if res != nil {
            res!.id = x.id
        res!.dates = x.dates
        res!.images = x.images
        res!.outcome = x.outcome
        }
        currentSkinCancer = x
            if db != nil
             { db!.editSkinCancer(skinCancervo: x) }
         }
            
        func cancelSkinCancerEdit() {
            //cancel function
        }
    
          
     func searchBySkinCancerdates(val : String) -> [SkinCancerVO]
          {
              if db != nil
                { let res = (db?.searchBySkinCancerdates(val: val))!
                  return res
                }
            currentSkinCancers = [SkinCancerVO]()
            let list : [SkinCancer] = SkinCancerAllInstances
            for (_,x) in list.enumerated()
            { if x.dates == val
              { currentSkinCancers.append(SkinCancerVO(x: x)) }
            }
            return currentSkinCancers
          }
          

}
