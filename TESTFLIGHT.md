# TestFlight Beta Açıklamaları

## 1. Beta App Description (Test Uygulama Açıklaması)

```
Ekşi Duyuru - Her Bir Şey Okuyucu

Bu uygulama, eksiduyuru.com üzerindeki gönderileri okumanızı sağlayan minimal bir okuyucu uygulamasıdır.

Beta testinde olup test etmenizi istediğim özellikler:
• Ana sayfada gönderilerin düzgün yüklenmesi
• Gönderi detaylarında içeriğin ve yorumların görüntülenmesi
• Safari ile tarayıcıda açma özelliği
• "Daha Fazla Yükle" ile eski gönderilerin yüklenmesi
• Pull-to-refresh ile yenileme

Uygulama sadece okuma amaçlıdır, giriş/yorum yapma desteği yoktur.

Not: Bu uygulama resmi bir Ekşi Duyuru uygulaması değildir. Kamuya açık içeriği görüntüler.
```

## 2. What to Test (Neleri Test Etmeli)

```
Lütfen aşağıdaki özellikleri test edin ve geri bildirim verin:

1. Gönderi Listesi
   - Gönderiler düzgün yükleniyor mu?
   - Scroll performansı nasıl?
   - "Daha Fazla Yükle" çalışıyor mu?

2. Gönderi Detayı
   - İçerik tam görünüyor mu?
   - Yorumlar yükleniyor mu?
   - Safari'de açma çalışıyor mu?

3. Genel
   - Uygulama çöküyor mu?
   - Yavaşlama var mı?
   - Herhangi bir hata mesajı alıyor musunuz?

Geri bildirimlerinizi TestFlight üzerinden veya GitHub Issues'a yazabilirsiniz.
```

## 3. Beta App Review Information (Beta İnceleme Bilgileri)

### Contact Information
- **First Name**: [Adınız]
- **Last Name**: [Soyadınız]
- **Email Address**: [email@example.com]
- **Phone Number**: [+90 XXX XXX XXXX]

### Review Information
- **Sign-in required?**: No (Giriş gerekmez)
- **Is your app restricted to users that already have an account?**: No
- **Demo account - Username**: (Boş bırakın)
- **Demo account - Password**: (Boş bırakın)
- **Notes**: 
```
Bu uygulama eksiduyuru.com sitesinden herkese açık gönderileri okur. Giriş gerektirmez.

Uygulama çalışırken:
1. Ana sayfa otomatik olarak gönderileri yükler
2. Bir gönderiye tıklayarak detayını ve yorumlarını görebilirsiniz
3. Sağ üstteki Safari butonu ile tarayıcıda açabilirsiniz
4. Alt taraftaki "Daha Fazla Yükle" ile eski gönderileri yükleyebilirsiniz

Not: Bu bir okuyucu uygulamasıdır, gönderi/yorum yapılamaz.
```

## 4. TestFlight Kullanım Kılavuzu (Kullanıcılar için)

TestFlight'a davet edilen kullanıcılar için gönderilecek mesaj:

```
Merhaba!

Ekşi Duyuru uygulamasının beta testine hoş geldiniz.

Test etmek için:
1. TestFlight uygulamasını indirin (App Store'dan ücretsiz)
2. Davet e-postasındaki "View in TestFlight" butonuna tıklayın
3. Uygulamayı indirin ve test edin
4. Sorun/önerilerinizi TestFlight içinden "Send Beta Feedback" ile gönderin

Test edebileceğiniz özellikler:
✓ Gönderi listesi görüntüleme
✓ Gönderi detayı ve yorumlar
✓ Safari'de açma
✓ Sonsuz scroll (pagination)

Teşekkürler!
```

## 5. Beta Sürüm Notları (Release Notes)

### Version 1.0 (Build 1) - İlk Beta
```
İlk beta sürüm:
• eksiduyuru.com gönderileri görüntüleme
• Yorumları okuma
• Safari ile tarayıcıda açma
• Pull-to-refresh ve pagination desteği
```

### Version 1.0 (Build 2) - Güncelleme (gerekirse)
```
Düzeltmeler:
• [Düzeltilen hata 1]
• [Düzeltilen hata 2]

İyileştirmeler:
• [İyileştirme 1]
```

## 6. SSS (Kullanıcıların Sorabileceği Sorular)

**S: Bu resmi Ekşi Duyuru uygulaması mı?**
C: Hayır, bu bağımsız bir okuyucu uygulamasıdır.

**S: Giriş yapabilir miyim?**
C: Hayır, uygulama sadece okuma amaçlıdır.

**S: Yorum yazabilir miyim?**
C: Hayır, sadece mevcut yorumları okuyabilirsiniz.

**S: Neden bazı gönderiler eksik?**
C: Uygulama pagination ile çalışır, "Daha Fazla Yükle" butonuna basarak eski gönderileri yükleyebilirsiniz.

**S: Uygulama çöktü, ne yapmalıyım?**
C: Lütfen TestFlight üzerinden "Send Beta Feedback" ile bildirin.

---

## Checklist: TestFlight'a Yüklemeden Önce

- [ ] App Store Connect'te Internal Testing grubu oluşturuldu
- [ ] Test kullanıcılarının e-posta adresleri eklendi
- [ ] Beta App Description dolduruldu
- [ ] What to Test dolduruldu
- [ ] Beta App Review Information dolduruldu
- [ ] Uygulama arşivlendi ve yüklendi
- [ ] Beta Review için gönderildi
- [ ] Onay sonrası test kullanıcılarına bildirim gönderildi
