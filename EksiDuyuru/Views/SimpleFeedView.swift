//
//  SimpleFeedView.swift
//  EksiDuyuru
//

import SwiftUI

struct SimpleFeedView: View {
    @State private var posts: [Post] = []
    @State private var isLoading = false
    @State private var isLoadingMore = false
    @State private var errorMessage: String?
    @State private var hasMorePages = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(posts) { post in
                    NavigationLink(destination: SimpleDetailView(post: post)) {
                        SimplePostRow(post: post)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                }
                
                // Load more button / indicator
                if hasMorePages {
                    LoadMoreView(isLoading: isLoadingMore) {
                        await loadMore()
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Ekşi Duyuru")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await refresh()
            }
        }
        .task {
            await refresh()
        }
        .overlay {
            if isLoading && posts.isEmpty {
                ProgressView("Yükleniyor...")
                    .scaleEffect(1.2)
            } else if posts.isEmpty {
                EmptyStateView(message: errorMessage ?? "Gönderiler yüklenemedi.")
            }
        }
    }
    
    private func refresh() async {
        isLoading = true
        errorMessage = nil
        APIService.shared.reset()
        
        do {
            let newPosts = try await APIService.shared.fetchNextPage()
            posts = newPosts
            hasMorePages = !newPosts.isEmpty
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func loadMore() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        do {
            let newPosts = try await APIService.shared.fetchNextPage()
            posts.append(contentsOf: newPosts)
            hasMorePages = !newPosts.isEmpty
        } catch {
            // Silently fail on load more, keep existing posts
            hasMorePages = false
        }
        
        isLoadingMore = false
    }
}

struct SimplePostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text(post.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Text(post.author)
                    .font(.caption)
                    .foregroundColor(.green)
                
                Spacer()
                
                if post.commentCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                            .font(.caption)
                        Text("\(post.commentCount)")
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct LoadMoreView: View {
    let isLoading: Bool
    let action: () async -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.0)
            } else {
                Button("Daha Fazla Yükle") {
                    Task {
                        await action()
                    }
                }
                .font(.subheadline)
                .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
}

struct SimpleDetailView: View {
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Text(post.author)
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    if post.commentCount > 0 {
                        Label("\(post.commentCount)", systemImage: "bubble.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                Text(post.content)
                    .font(.body)
                    .lineSpacing(4)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Gönderi Yok")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    SimpleFeedView()
}
