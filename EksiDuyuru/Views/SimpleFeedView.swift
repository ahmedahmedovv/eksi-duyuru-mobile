//
//  SimpleFeedView.swift
//  EksiDuyuru
//

import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let appGreen = Color(red: 0.22, green: 0.56, blue: 0.24)
    static let appBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
}

// MARK: - Main Feed View
struct SimpleFeedView: View {
    @State private var posts: [Post] = []
    @State private var isLoading = false
    @State private var isLoadingMore = false
    @State private var errorMessage: String?
    @State private var hasMorePages = true
    @State private var scrollToTop = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollViewReader { proxy in
                    List {
                        ForEach(posts) { post in
                            PostCard(post: post)
                                .id(post.id)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                        }
                        
                        // Load more
                        if hasMorePages {
                            LoadMoreSection(isLoading: isLoadingMore) {
                                await loadMore()
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await refresh()
                    }
                    .onChange(of: scrollToTop) { _ in
                        if let firstId = posts.first?.id {
                            withAnimation {
                                proxy.scrollTo(firstId, anchor: .top)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ekşi Duyuru")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        scrollToTop.toggle()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title3)
                            .foregroundColor(.appGreen)
                    }
                    .disabled(posts.isEmpty)
                }
            }
        }
        .task {
            await refresh()
        }
        .overlay {
            if isLoading && posts.isEmpty {
                LoadingOverlay()
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
            withAnimation(.easeOut(duration: 0.3)) {
                posts = newPosts
            }
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
            withAnimation(.easeOut(duration: 0.3)) {
                posts.append(contentsOf: newPosts)
            }
            hasMorePages = !newPosts.isEmpty
        } catch {
            hasMorePages = false
        }
        
        isLoadingMore = false
    }
}

// MARK: - Post Card
struct PostCard: View {
    let post: Post
    
    var body: some View {
        NavigationLink(destination: PostDetailView(post: post)) {
            VStack(alignment: .leading, spacing: 0) {
                // Title section
                Text(post.title)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                // Content preview
                if !post.content.isEmpty {
                    Text(post.content)
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }
                
                // Footer with author and stats
                HStack(spacing: 12) {
                    // Author
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                            .font(.caption)
                            .foregroundColor(.appGreen)
                        Text(post.author)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.appGreen)
                    }
                    
                    Spacer()
                    
                    // Comments count
                    if post.commentCount > 0 {
                        CommentBadge(count: post.commentCount)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appGreen.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Comment Badge
struct CommentBadge: View {
    let count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "bubble.left.fill")
                .font(.system(size: 11))
            Text("\(count)")
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.appGreen)
        )
    }
}

// MARK: - Load More Section
struct LoadMoreSection: View {
    let isLoading: Bool
    let action: () async -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            if isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(1.0)
                    Text("Yükleniyor...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
            } else {
                Button {
                    Task { await action() }
                } label: {
                    HStack(spacing: 6) {
                        Text("Daha Fazla")
                            .font(.system(size: 15, weight: .semibold))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.appGreen)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.appGreen.opacity(0.12))
                    )
                }
                .padding(.vertical, 16)
            }
            
            Spacer()
        }
    }
}

// MARK: - Post Detail View
struct PostDetailView: View {
    let post: Post
    @State private var comments: [Comment] = []
    @State private var isLoadingComments = false
    @State private var commentsError: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Post Header Card
                VStack(alignment: .leading, spacing: 16) {
                    Text(post.title)
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .lineSpacing(2)
                    
                    // Author row
                    HStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundColor(.appGreen)
                        
                        Text(post.author)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.appGreen)
                        
                        Spacer()
                        
                        if post.commentCount > 0 {
                            CommentBadge(count: post.commentCount)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Post Content
                if !post.content.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("İçerik")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        Text(post.content)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .lineSpacing(6)
                            .foregroundColor(.primary)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                
                // Comments Section
                VStack(alignment: .leading, spacing: 0) {
                    // Comments header
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 14))
                            Text("Yorumlar")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if isLoadingComments {
                            ProgressView()
                                .scaleEffect(0.9)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Comments content
                    if comments.isEmpty && !isLoadingComments {
                        VStack(spacing: 12) {
                            Image(systemName: "bubble.left")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary.opacity(0.5))
                            
                            if let error = commentsError {
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Henüz yorum yok")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                    
                    ForEach(Array(comments.enumerated()), id: \.element.id) { index, comment in
                        CommentRow(comment: comment, isFirst: index == 0, isLast: index == comments.count - 1)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadComments()
        }
    }
    
    private func loadComments() async {
        isLoadingComments = true
        commentsError = nil
        
        do {
            comments = try await APIService.shared.fetchComments(for: post.id)
        } catch {
            commentsError = "Yorumlar yüklenemedi."
        }
        
        isLoadingComments = false
    }
}

// MARK: - Comment Row
struct CommentRow: View {
    let comment: Comment
    let isFirst: Bool
    let isLast: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Author
            HStack(spacing: 6) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 14))
                Text(comment.author)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.appGreen)
            
            // Content
            Text(comment.content)
                .font(.system(size: 15, weight: .regular))
                .lineSpacing(4)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.clear)
        .overlay(
            // Separator line for all but last item
            Group {
                if !isLast {
                    VStack {
                        Spacer()
                        Divider()
                            .padding(.leading, 20)
                    }
                }
            }
        )
    }
}

// MARK: - Loading Overlay
struct LoadingOverlay: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.appGreen)
            
            Text("Yükleniyor...")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 4)
        )
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Gösterilecek gönderi yok")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding(40)
    }
}

#Preview {
    SimpleFeedView()
}
