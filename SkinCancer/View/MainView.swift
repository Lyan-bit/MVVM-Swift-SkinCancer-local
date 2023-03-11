//
//  MainView.swift
//  Diet Pro
//
//  Created by Lyan Alwakeel on 26/09/2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = SkinViewModel()
    @ObservedObject var recognition = ImageRecognitionModel()
    
    var body: some View {
        TabView {
            CreateSkinCancerScreen (model: model).tabItem {
                        Image(systemName: "1.square.fill")
                        Text("+SkinCancer")}
            ListSkinCancerScreen (model: model).tabItem {
                        Image(systemName: "2.square.fill")
                        Text("ListSkinCancer")}
            EditSkinCancerScreen (model: model).tabItem {
                        Image(systemName: "3.square.fill")
                        Text("EditSkinCancer")}
            DeleteSkinCancerScreen (model: model).tabItem {
                        Image(systemName: "4.square.fill")
                        Text("-SkinCancer")}
            SearchSkinCancerdatesScreen (model: model).tabItem {
                        Image(systemName: "5.square.fill")
                        Text("SearchSkinCancerdates")}
            ImageRecognitionScreen (recognition: recognition, model: model).tabItem {
                        Image(systemName: "6.square.fill")
                        Text("ImageRecognition")}
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
