//
//  NoteEditor.swift
//  Note'd
//
//  Created by Ariel on 12/29/22.
//

import SwiftUI

// Color extension from https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e

//text editor
struct NoteEditor: View {
    
    @ObservedObject var note: Note
    @AppStorage("colorkey") var color: Color = .black

    var body: some View {
        VStack{
            TextEditor(text: $note.text.toUnwrapped(defaultValue: ""))
                .foregroundColor(color) // text color
                .font(.custom("Futura", size: 20))
                .onReceive(
                    note.publisher(for: \.text)
                        .debounce(for: 0.5, scheduler: RunLoop.main)
                        .removeDuplicates()
                ){ _ in
                    try? PersistenceController.shared.saveContext() // saves text
                }
                .toolbar{
                    // note name displayed at top
                    ToolbarItem(placement: .primaryAction){
                        Text(note.name!)
                            .font(.system(size: 20, weight: .semibold))
                        
                    }
                    
                    ToolbarItem(placement: .primaryAction){
                        Text("    ")
                        
                    }
                    
                    ToolbarItem(placement: .primaryAction){
                        ColorPicker("Color", selection: $color)
                    }
                }
        }
        
    }
}

// code to pick text color
extension Color: RawRepresentable {

    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }

    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }
}

//used to unwrap text for note
extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
