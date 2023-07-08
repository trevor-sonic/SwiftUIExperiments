//
//  ListWithNavigation.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 06/03/2023.
//

import SwiftUI

struct ListWithNavigation: View {
    
    //let bookmarks: [Bookmark] = [.example1, .example2, .example3]
    
    let bookmark: Bookmark
    
    var body: some View {
        NavigationStack{
            List(bookmark.items!) { bookmark in
                
                //NavigationLink(row.title, value: row)
                NavigationLink(value: bookmark) {
                    BookmarkView(bookmark: bookmark)
                }
                
                
            }
            .navigationDestination(for: Bookmark.self, destination: BookmarkDetails.init)
            
            .navigationTitle("Select")
            
        }.accentColor(.green)
    }
    
}
struct BookmarkView: View {
    
    let bookmark: Bookmark
    
    var body: some View {
        HStack {
            Image(systemName: bookmark.icon)
            Text(bookmark.name)
        }.padding(.vertical, 10).font(.title3).foregroundColor(.orange)
    }
}
struct BookmarkDetails: View {
    let bookmark: Bookmark

    var body: some View {
       
        List(bookmark.items!) { bookmark in
            
            //NavigationLink(row.title, value: row)
            NavigationLink(value: bookmark) {
                BookmarkView(bookmark: bookmark)
            }
            
            
        }
        .navigationDestination(for: Bookmark.self, destination: BookmarkDetails.init)
        
//        List{
//            Text(bookmark.title)
//            Text(bookmark.id.debugDescription)
//        }
    }
}

struct ListWithNavigation_Previews: PreviewProvider {
    static var previews: some View {
        let bookmark = Bookmark(name: "", icon: "", items: [.example1, .example2, .example3])
        ListWithNavigation(bookmark: bookmark)
    }
}
