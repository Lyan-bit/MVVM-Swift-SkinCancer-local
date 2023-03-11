	                  
import Foundation
import SwiftUI

class ImageRecognitionModel : ObservableObject {
		                      
	static var instance : ImageRecognitionModel? = nil
	private var modelParser : ModelParser? = ModelParser(modelFileInfo: ModelFile.modelInfo)
    var model : SkinViewModel = SkinViewModel ()

	static func getInstance() -> ImageRecognitionModel {
		if instance == nil
	     { instance = ImageRecognitionModel() }
	    return instance! }

    func imageRecognition(x : String) -> String {
        guard let obj = model.getSkinCancerByPK(val: x)
        else {
            return "Please selsect valid id"
        }
        
		let dataDecoded = Data(base64Encoded: obj.images, options: .ignoreUnknownCharacters)
		let decodedimage:UIImage = UIImage(data: dataDecoded! as Data)!
        		
    	guard let pixelBuffer = decodedimage.pixelBuffer() else {
        	return "Error"
    	}
    
        // Hands over the pixel buffer to ModelDatahandler to perform inference
        let inferencesResults = modelParser?.runModel(onFrame: pixelBuffer)
        
        // Formats inferences and resturns the results
        guard let firstInference = inferencesResults else {
          return "Error"
        }
        
        obj.outcome = firstInference[0].label
        model.persistSkinCancer(x: obj)
        
        return firstInference[0].label
        
    }
    
	func cancelImageRecognition() {
		//cancel function
	}

}
