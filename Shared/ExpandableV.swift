//
//  ExpandableV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 03/03/2023.
//

import SwiftUI

struct Bookmark: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var items: [Bookmark]?
    
    // some example websites
    static let apple = Bookmark(name: "Apple", icon: "1.circle")
    static let bbc = Bookmark(name: "BBC", icon: "square.and.pencil")
    static let swift = Bookmark(name: "Swift", icon: "bolt.fill")
    static let twitter = Bookmark(name: "Twitter", icon: "1.square")
    
    // some example groups
    static let example1 = Bookmark(name: "Favourites", icon: "star", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
    static let example2 = Bookmark(name: "Recent", icon: "timer", items: [Bookmark.swift, Bookmark.apple, Bookmark.bbc, Bookmark.twitter])
    static let example3 = Bookmark(name: "Recommended", icon: "hand.thumbsup", items: [Bookmark.twitter, Bookmark.apple, Bookmark.bbc, Bookmark.swift])
    
}

extension Bookmark:  Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
            return lhs.id == rhs.id
        }
    
}

struct ExpandableV: View {
    let items: [Bookmark] = [.example1, .example2, .example3]
    
    var body: some View {
        List(items, children: \.items) { row in
            HStack {
                Image(systemName: row.icon)
                Text(row.name)
            }.padding(.vertical, 10).font(.title3).foregroundColor(.cyan)
        }.accentColor(.cyan)
    }
}

struct ExpandableV_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableV()
    }
}
