//
//  Sidebar.swift
//  Note'd
//
//  Created by Ariel on 12/29/22.
//

import SwiftUI
import Firebase

// folders view 
struct Sidebar: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [])
    private var folders: FetchedResults<Folder>
    @State private var isPresented: Bool = false
    @State var selectedFolder: Folder? = nil
    @AppStorage("log_Status") var status = false
    
    var body: some View {
        
        Button(){ //add folder button
            isPresented = true
        } label: {
            HStack{
                Image(systemName: "folder.badge.plus")
                Text("Add Folder")
                
            }
            .cornerRadius(50)
           
        
        }
        .sheet(isPresented: $isPresented){
            AddFolderView{ name in
                viewContext.addFolder(name)
            }
        }
        .padding(.top, 20)
        
        Text("Folders")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.top,10)
        Divider()
        
        // lists all created folders
        List(selection: $selectedFolder){
            ForEach(folders, id: \.self){ folder in
                VStack(alignment: .leading){
                    NavigationLink( destination: NoteView(folder: folder, selectedFolder: $selectedFolder)){
                        HStack {
                            Text(folder.name!)
                            Spacer()
                            Text("\(folder.notesArray.count)") // displays amount of notes in folder
                                
                        }
                        
                    }
                    Text(formatDate(folder.date)) // shows date folder was created
                        .font(.system(size: 10))
                }
                
            }
        }
        
        .toolbar{
            
            
            
            ToolbarItem(placement: .primaryAction){
                Button(action: toggleSidebar){
                    Label("Toggle Sidebar", systemImage: "sidebar.left") //makes sidebar dissapear
                }
            }
            
            ToolbarItem(placement: .primaryAction){
                Button(action: {viewContext.deleteFolder(selectedFolder!)
                }, label:{ Label("Delete note", systemImage: "trash")} )
            }
            
            ToolbarItem(placement: .primaryAction){ // logs out user 
                Button(action: logout){
                    Text("Logout")
                }
            }
        }
    }
    
    private func logout(){
        try? Auth.auth().signOut()
                    withAnimation{status = false}
    }
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    private func formatDate(_ date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, MMM d y"
        if let date = date{
            return formatter.string(from: date)
        }
        return "Unknown"
        
    }
}
