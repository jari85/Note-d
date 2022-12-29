//
//  AddFolderView.swift
//  Note'd
//
//  Created by Ariel on 12/29/22.
//

import SwiftUI

struct AddFolderView: View {
    // pop up when you press button to create new folder
    @Environment(\.presentationMode) var presentationMode
    @State private var newFolderName: String = ""
    var Save: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing:20){
            HStack{
                
                //lets you cancel out of making new folder
                Button("Cancel"){
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                //saves new folder
                Button("Done"){
                    Save(newFolderName)
                    presentationMode.wrappedValue.dismiss()
                }
                //Disables Done button if textfield is empty
                .disabled(newFolderName.isEmpty)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack{
                TextField("Folder Name", text: $newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.949, green: 0.946, blue: 0.966))
    }
}
