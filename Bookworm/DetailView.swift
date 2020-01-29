//
//  DetailView.swift
//  Bookworm
//
//  Created by Sarvad shetty on 1/27/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import CoreData
import SwiftUI

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert.toggle()
        }){
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Notice"), message: Text("Are you sure you want to delete this book?"), primaryButton: .destructive(Text("Delete"), action: {
                self.deleteBook()
            }), secondaryButton: .cancel())
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Sarvad is lit"
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
