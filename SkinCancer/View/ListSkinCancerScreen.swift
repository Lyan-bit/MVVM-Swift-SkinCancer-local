
import SwiftUI

struct ListSkinCancerScreen: View {
    @ObservedObject var model : SkinViewModel = SkinViewModel.getInstance()

     var body: some View
     { List(model.currentSkinCancers){ instance in 
     	ListSkinCancerRowScreen(instance: instance) }
       .onAppear(perform: { model.listSkinCancer() })
     }
    
}

struct ListSkinCancerScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListSkinCancerScreen(model: SkinViewModel.getInstance())
    }
}

