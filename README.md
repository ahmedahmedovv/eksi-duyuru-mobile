# Eksi Duyuru iOS App

A minimal, read-only iOS app for [Eksi Duyuru](https://www.eksiduyuru.com/).

## Features

- 📱 **Simple & Clean**: Just shows the latest posts from eksiduyuru.com
- 🌐 **Live Data**: Fetches real data from the website
- 📖 **Read-Only**: No login, no search, no settings - just browse
- ⬇️ **Pull to Refresh**: Swipe down to get the latest posts

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Project Structure

```
EksiDuyuru/
├── EksiDuyuruApp.swift         # App entry point
├── Models/
│   └── Post.swift              # Post model
├── Views/
│   └── SimpleFeedView.swift    # Main feed + detail view
├── Services/
│   └── APIService.swift        # HTML parsing from eksiduyuru.com
├── Assets.xcassets/            # App icons
└── Preview Content/
```

## How to Run

1. Open `EksiDuyuru.xcodeproj` in Xcode
2. Select iPhone simulator or device
3. Press ⌘+R to build and run

## What It Does

1. Fetches posts from `https://www.eksiduyuru.com/herbirsey`
2. Parses HTML to extract post title, content, author
3. Displays posts in a scrollable list
4. Tap any post to see full content
5. Pull down to refresh

## Technical Notes

- Uses HTML parsing (web scraping) since there's no public API
- No user interaction - read-only browsing
- No categories, search, or filters
- No mock data - always fetches from live website
