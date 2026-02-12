# App Store Submission Guide

## App Information

### Basic Information
- **App Name**: Ekşi Duyuru
- **Subtitle**: Her Bir Şey Okuyucu
- **Bundle ID**: com.eksiduyuru.app
- **Version**: 1.0
- **Build**: 1

### Pricing and Availability
- **Price**: Free
- **Availability**: Turkey (TR)

## App Store Connect Metadata

### Description (Turkish)
```
Ekşi Duyuru, eksiduyuru.com üzerindeki her bir şey gönderilerini okumanızı sağlayan minimal bir uygulamadır.

Özellikler:
• Son gönderileri görüntüleyin
• Yorumları okuyun
• Tarayıcıda açın
• Çevrimdışı okuma yok - her zaman güncel içerik

Not: Bu uygulama resmi bir Ekşi Duyuru uygulaması değildir. Sadece kamuya açık içeriği görüntüler.
```

### Keywords
```
eksi, duyuru, eksiduyuru, forum, okuyucu, her bir şey, duyurular
```

### Support URL
https://github.com/ahmedahmedovv/eksi-duyuru-mobile

### Marketing URL (Optional)
https://github.com/ahmedahmedovv/eksi-duyuru-mobile

## Privacy Details

### Data Collection
- **Collected Data Types**: None
- **Tracking**: No
- **Third-party SDKs**: None

### Privacy Policy URL (Required)
You need to provide a privacy policy URL. Options:
1. Create a simple privacy policy page on GitHub
2. Use a privacy policy generator
3. Host on your own website

Sample privacy policy text:
```
Privacy Policy for Ekşi Duyuru

Last updated: [Date]

Ekşi Duyuru does not collect any personal data from users. 
The app only displays publicly available content from eksiduyuru.com.

Contact: [your-email@example.com]
```

## Screenshots Required

### iPhone (6.7" Display - iPhone 14 Pro Max / 15 Pro Max)
- 1290 x 2796 pixels (portrait)
- Required: 2-10 screenshots

### iPhone (6.5" Display - iPhone 11 Pro Max / XS Max)
- 1242 x 2688 pixels (portrait)
- Required if supporting older devices

### iPad (12.9" Display)
- 2048 x 2732 pixels (portrait)
- Required if supporting iPad

## Build and Archive

### Using Xcode GUI
1. Open EksiDuyuru.xcodeproj in Xcode
2. Select Product → Archive
3. Once archived, click "Distribute App"
4. Select "App Store Connect"
5. Upload

### Using Command Line (xcodebuild)
```bash
cd EksiDuyuruApp

# Clean build
xcodebuild clean -project EksiDuyuru.xcodeproj -scheme EksiDuyuru

# Archive
xcodebuild archive \
  -project EksiDuyuru.xcodeproj \
  -scheme EksiDuyuru \
  -destination 'generic/platform=iOS' \
  -archivePath build/EksiDuyuru.xcarchive

# Export IPA (requires ExportOptions.plist)
xcodebuild -exportArchive \
  -archivePath build/EksiDuyuru.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/
```

## Pre-Submission Checklist

- [ ] Update App Icon (all sizes complete)
- [ ] Verify bundle identifier
- [ ] Update version number if needed
- [ ] Test on physical device
- [ ] Check for memory leaks
- [ ] Verify network error handling
- [ ] Test dark mode appearance
- [ ] Test different device sizes
- [ ] Create screenshots for App Store
- [ ] Write privacy policy
- [ ] Prepare App Store metadata
- [ ] Archive and validate

## Important Notes

### App Store Guidelines Compliance
- **Guideline 5.2.3**: Web scraping - Apple may reject apps that scrape websites without permission
- **Recommendation**: Contact eksiduyuru.com for permission or API access before submission
- **Alternative**: Position as a "reader app" that aggregates publicly available content

### Review Preparation
- Be prepared to explain the relationship with eksiduyuru.com
- Have documentation ready showing permission or that content is public
- Consider adding a disclaimer in the app description

### Common Rejection Reasons to Avoid
1. No privacy policy URL
2. Broken links in metadata
3. App crashes during review
4. Misleading app name or description
5. Web content that doesn't work properly
