//
//  APIService.swift
//  EksiDuyuru
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://www.eksiduyuru.com"
    private let session: URLSession
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.httpAdditionalHeaders = [
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)"
        ]
        self.session = URLSession(configuration: config)
    }
    
    func reset() {
        currentPage = 1
        hasMorePages = true
        isLoading = false
    }
    
    func fetchNextPage() async throws -> [Post] {
        guard !isLoading && hasMorePages else {
            return []
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let urlString = "\(baseURL)/herbirsey?p=\(currentPage)"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        let (data, _) = try await session.data(from: url)
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Invalid encoding", code: -1)
        }
        
        let posts = try parsePostsFromHTML(html)
        
        // Check if there are more pages by looking for next page link
        hasMorePages = checkHasMorePages(html)
        
        if !posts.isEmpty {
            currentPage += 1
        }
        
        return posts
    }
    
    func fetchAllPages() async throws -> [Post] {
        reset()
        var allPosts: [Post] = []
        
        while hasMorePages {
            let posts = try await fetchNextPage()
            if posts.isEmpty {
                break
            }
            allPosts.append(contentsOf: posts)
        }
        
        return allPosts
    }
    
    private func checkHasMorePages(_ html: String) -> Bool {
        // Look for pagination link to next page
        let nextPagePattern = #"href=\"\?p=\d+\""#
        let regex = try? NSRegularExpression(pattern: nextPagePattern)
        let matches = regex?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html)) ?? []
        
        // Check if there's a link to currentPage + 1
        let nextPageString = "?p=\(currentPage + 1)"
        return html.contains(nextPageString)
    }
    
    private func parsePostsFromHTML(_ html: String) throws -> [Post] {
        var posts: [Post] = []
        
        let entryPattern = #"<div\s+id=\"t(\d+)\"\s+class=\"entry\d+\s+[^\"]*\"[^>]*>"#
        let titlePattern = #"<h2[^>]*class=\"title[^\"]*\"[^>]*>(.+?)</h2>"#
        let authorPattern = #"<div\s+class=\"poster[^\"]*\"[^>]*>.*?<span[^>]*title=\"([^\"]+)\""#
        let excerptPattern = #"<div\s+class=\"excerpt[^\"]*\"[^>]*>(.+?)</div>"#
        let bodyPattern = #"<div\s+class=\"body[^\"]*\"[^>]*>(.+?)</div>"#
        let commentPattern = #"<span\s+class=\"cnt\s+e\d+\s+[^\"]*\"[^>]*>\((\d+)\)</span>"#
        
        let entryRegex = try? NSRegularExpression(pattern: entryPattern, options: [.dotMatchesLineSeparators])
        let titleRegex = try? NSRegularExpression(pattern: titlePattern, options: [.dotMatchesLineSeparators])
        let authorRegex = try? NSRegularExpression(pattern: authorPattern, options: [.dotMatchesLineSeparators])
        let excerptRegex = try? NSRegularExpression(pattern: excerptPattern, options: [.dotMatchesLineSeparators])
        let bodyRegex = try? NSRegularExpression(pattern: bodyPattern, options: [.dotMatchesLineSeparators])
        let commentRegex = try? NSRegularExpression(pattern: commentPattern, options: [])
        
        let entryMatches = entryRegex?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html)) ?? []
        
        for (index, entryMatch) in entryMatches.enumerated() {
            guard let idRange = Range(entryMatch.range(at: 1), in: html) else { continue }
            let idString = String(html[idRange])
            guard let id = Int(idString) else { continue }
            
            let entryStart = entryMatch.range.location
            let nextEntryStart = (index + 1 < entryMatches.count) ? entryMatches[index + 1].range.location : html.count
            let entryLength = nextEntryStart - entryStart
            guard let entryRange = Range(NSRange(location: entryStart, length: entryLength), in: html) else { continue }
            let entrySection = String(html[entryRange])
            
            let titleMatch = titleRegex?.firstMatch(in: entrySection, options: [], range: NSRange(entrySection.startIndex..., in: entrySection))
            var title = extractGroup(from: titleMatch, at: 1, in: entrySection) ?? "Başlıksız"
            title = title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            
            let authorMatch = authorRegex?.firstMatch(in: entrySection, options: [], range: NSRange(entrySection.startIndex..., in: entrySection))
            let author = extractGroup(from: authorMatch, at: 1, in: entrySection) ?? "anonim"
            
            let bodyMatch = bodyRegex?.firstMatch(in: entrySection, options: [], range: NSRange(entrySection.startIndex..., in: entrySection))
            var content = ""
            if let bodyContent = extractGroup(from: bodyMatch, at: 1, in: entrySection) {
                content = bodyContent
            } else {
                let excerptMatch = excerptRegex?.firstMatch(in: entrySection, options: [], range: NSRange(entrySection.startIndex..., in: entrySection))
                content = extractGroup(from: excerptMatch, at: 1, in: entrySection) ?? ""
            }
            content = cleanHTML(content)
            
            let commentMatch = commentRegex?.firstMatch(in: entrySection, options: [], range: NSRange(entrySection.startIndex..., in: entrySection))
            let commentCount = Int(extractGroup(from: commentMatch, at: 1, in: entrySection) ?? "0") ?? 0
            
            let post = Post(
                id: id,
                title: title,
                content: content,
                author: author,
                commentCount: commentCount,
                createdAt: Date(),
                url: "\(baseURL)/duyuru/\(id)/"
            )
            
            posts.append(post)
        }
        
        return posts
    }
    
    private func cleanHTML(_ html: String) -> String {
        var text = html
        
        text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        let entities = [
            "&quot;": "\"",
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&#039;": "'",
            "&#39;": "'",
            "&nbsp;": " ",
            "&#91;": "[",
            "&#93;": "]",
            "&ldquo;": "\"",
            "&rdquo;": "\"",
            "&lsquo;": "'",
            "&rsquo;": "'",
            "&hellip;": "...",
            "&ndash;": "–",
            "&mdash;": "—"
        ]
        
        for (entity, replacement) in entities {
            text = text.replacingOccurrences(of: entity, with: replacement)
        }
        
        text = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func extractGroup(from match: NSTextCheckingResult?, at index: Int, in string: String) -> String? {
        guard let match = match else { return nil }
        guard index < match.numberOfRanges else { return nil }
        let range = match.range(at: index)
        guard range.location != NSNotFound else { return nil }
        guard let swiftRange = Range(range, in: string) else { return nil }
        return String(string[swiftRange])
    }
}
