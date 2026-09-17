GÖREV 1:
![15-09-ODEV1-SORU1-FLOWCHART](RESIMLER/15-09-ODEV1-SORU1-FLOWCHART.png)
<img src="RESIMLER/15-09-ODEV1-SORU1-FLOWCHART.png" alt="Logo" width="200" />


GÖREV 2:

1.
HTTP METODU: POST
URL/Endpoirt: https://api.kahvezinciri.com/api/v1/siparisler
Headers:
	Content-Type: application/json
	Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…
Request Body(JSON):
{
  "urunler": [
    {
      "urunId": "KHF-101",
      "ad": "Latte",
      "boyut": "Grande",
      "adet": 2,
      "birimFiyat": 110.0
    },
    {
      "urunId": "KHF-204",
      "ad": "Filtre Kahve",
      "boyut": "Venti",
      "adet": 1,
      "birimFiyat": 85.0
    }
  ],
  "toplamTutar": 305.0,
  "teslimatNoktasi": "Kadıköy Şubesi"
}


BAŞARILI DURUMLAR 201 CREATED
Sipariş oluşturdu onayı atılır ve bakiyeden tutar düşer

{
  "durum": "BASARILI",
  "siparisId": "SIP-2026-9812",
  "kalanBakiye": 145.0,
  "mesaj": "Siparişiniz hazırlanıyor."
}

GİRİŞ YAPILAMAMIŞ 401 UNAUTHORİZED
	Header’da geçerli bir token olmayınca döner.

{
  "hata": "UNAUTHORIZED",
  "mesaj": "Bu işlem için oturum açmanız gerekmektedir."
}


2.
HTTP METODU: GET
URL / Endpoint: https://api.kahvezinciri.com/api/v1/kullanici/bakiye 
Headers:
	Content-Type: application/json
	Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…

BAŞARILI SONUÇ 200 OK
{
  "bakiye": 185.50,
  "para_birimi": "TRY"
}

BEKLENMEYEN HATA DURUMU 500 Internal Server Error
{
  "hata": "INTERNAL_SERVER_ERROR",
  "mesaj": "Sunucu tarafında beklenmeyen bir hata meydana geldi, lütfen tekrar deneyiniz."
}

MİNİ MÜLAKAT SORUCU CEVAPI:
GET isteği Idempont, Post isteği Idempont değildir. Post isteği kullanıcın sipari durumuna göre kayıt açıp bakiyeyi her defasında düşürür değiştirir; Get isteği ise arka arkaya kaç kez çağırılsa çağrılsın sunucu üzerindeki veriyi değiştirmez, var olanı okumamızı sağlar.



GÖREV 3:
SORU 1:
	Tek bir sipariş yönetimi altında sınıfa birden fazla sorumluluk verilmiştir; sepet ve indirim hesaplamaları , ödeme yöntemleri , veri tabanına yapılan işlemler, bilgilendirme işlemleri ayrı sınıflara ait olmalıdır.
SORU 2:
	OCP’yi ihlal etmiştir, her bir müşteri tipi için çalışan kodun içerisine girip zorunda kaldığımız için, IndirimKurali adlı abstract bir sınıf açıp her bir müşteri tipi yada indirim tipi ayrı override edip hesaplatma yapmalıyız.

