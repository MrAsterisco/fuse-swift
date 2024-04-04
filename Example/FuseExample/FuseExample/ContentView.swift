//
//  ContentView.swift
//  FuseExample
//
//  Created by Alessio Moiso on 04/04/24.
//

import SwiftUI
import Fuse

struct Item: Identifiable {
	let id: UUID
	let name: String
	
	let score: Double?
	
	init(id: UUID = .init(), name: String, score: Double? = nil) {
		self.id = id
		self.name = name
		self.score = score
	}
}

private let dataSource: [Item] = [
	.init(name: "To Kill a Mockingbird"),
	 .init(name: "1984"),
	 .init(name: "The Great Gatsby"),
	 .init(name: "Pride and Prejudice"),
	 .init(name: "The Catcher in the Rye"),
	 .init(name: "The Hobbit"),
	 .init(name: "Fahrenheit 451"),
	 .init(name: "Animal Farm"),
	 .init(name: "Brave New World"),
	 .init(name: "The Lord of the Rings"),
	 .init(name: "The Chronicles of Narnia"),
	 .init(name: "Harry Potter and the Philosopher's Stone"),
	 .init(name: "The Da Vinci Code"),
	 .init(name: "The Hunger Games"),
	 .init(name: "The Catcher in the Rye"),
	 .init(name: "The Alchemist"),
	 .init(name: "The Fault in Our Stars"),
	 .init(name: "Gone with the Wind"),
	 .init(name: "The Kite Runner"),
	 .init(name: "The Book Thief")
 ]

struct ContentView: View {
	@State private var query = ""
	
	@State private var content: [Item] = dataSource
	
	var body: some View {
		List($content) { $item in
			HStack {
				if let score = item.score {
					Text("\(score)")
						.foregroundStyle(.secondary)
				}
				
				Text(item.name)
			}
		}
		.searchable(text: $query)
		.onChange(of: query) {
			filter()
		}
	}
}

private extension ContentView {
	func filter() {
		let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard
			!trimmedQuery.isEmpty
		else {
			self.content = dataSource
			return
		}
		
		let fuse = Fuse()
		let pattern = fuse.createPattern(from: trimmedQuery)
		
		self.content = dataSource
			.compactMap { item in
				guard
					let result = fuse.search(pattern, in: item.name)
				else {
					return nil
				}
				
				return Item(
					id: item.id,
					name: item.name,
					score: result.score
				)
			}
			.sorted { lhs, rhs in
				guard
					let lhsScore = lhs.score,
					let rhsScore = rhs.score
				else {
					return lhs.name < rhs.name
				}
				
				return lhsScore < rhsScore
			}
	}
}

#Preview {
	ContentView()
}
