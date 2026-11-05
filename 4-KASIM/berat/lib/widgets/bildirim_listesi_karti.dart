import 'package:flutter/material.dart'; //flutter temel arayüz (UI) bileşenlerini ve widget'larını kullanabilmek için material kütüphanesini import ediyoruz.

import '../models/bildirim_modeli.dart'; //bildirim verilerini temsil eden BildirimModeli sınıfımızı kullanabilmek için dosyamızı import ediyoruz.

class BildirimListesiKarti extends StatelessWidget {
  //bildirimleri, token bilgisini ve konu aboneliğini ekranda kart şeklinde gösterecek olan stateless widget'ımız.
  final List<BildirimModeli> bildirimler; //ekranda listelenecek olan BildirimModeli tipindeki bildirim listemiz.
  final String? token; //cihazın FCM token değeri, ilk başta null gelebileceği için nullable String olarak tanımlıyoruz.
  final bool konuyaAboneMi; //kullanıcının konuya (topic) abone olup olmadığını tuttuğumuz mantıksal değer.
  final ValueChanged<bool> onAboneDegisti; //switch butonuna basıldığında tetiklenecek ve yeni bool değerini üst widget'a iletecek geri arama (callback) fonksiyonumuz.

  const BildirimListesiKarti({
    super.key, //widget'ın Flutter ağacındaki kimliğini belirtmek için key değerini üst sınıfa iletiyoruz.
    required this.bildirimler, //bildirimler listesinin zorunlu olarak verilmesini istiyoruz.
    this.token, //token değeri opsiyonel olduğu için required vermiyoruz.
    required this.konuyaAboneMi, //abone durumunun zorunlu girilmesini istiyoruz.
    required this.onAboneDegisti, //switch değiştiğinde çalışacak fonksiyonu zorunlu istiyoruz.
  });

  @override
  Widget build(BuildContext context) {
    //widget'ın ekrandaki görüntüsünü inşa eden build metodumuz.
    return Card(
      //içeriği modern bir kart görünümünde göstermek için Card widget'ı döndürüyoruz.
      shape: RoundedRectangleBorder(
        //kartın köşelerini yuvarlatmak ve kenarlık vermek için şekil tanımlıyoruz.
        borderRadius: BorderRadius.circular(16), //kartın kenarlarını 16 piksel ovallikte yuvarlıyoruz.
        side: BorderSide(color: Colors.grey.shade300), //kartın etrafına açık gri renkte ince bir çerçeve çizgisi çiziyoruz.
      ),
      child: Padding(
        //kartın içerisindeki elemanların kenarlara yapışmaması için boşluk (padding) veriyoruz.
        padding: const EdgeInsets.all(20), //her yönden (üst, alt, sağ, sol) 20 piksel iç boşluk tanımlıyoruz.
        child: Column(
          //kartın içerisindeki widget'ları yukarıdan aşağıya alt alta dizmek için Column kullanıyoruz.
          crossAxisAlignment: CrossAxisAlignment
              .stretch, //ortadan başlatıp her iki tarafa esniyor
          children: [
            //Column içerisine yerleştireceğimiz alt widget'lar dizisi
            Row(
              //kartın başlık satırı için ikon, başlık yazısı ve switch butonunu yan yana dizmek amacıyla Row kullanıyoruz.
              children: [
                const Icon(
                  Icons.notifications_active_outlined, //başlığın soluna bildirim ikonu koyuyoruz.
                  color: Color(0xFF006C4A), //ikona koyu yeşil renk veriyoruz.
                ),
                const SizedBox(width: 8), //ikon ile başlık metni arasına 8 piksel yatay boşluk bırakıyoruz.
                const Expanded(
                  //başlık metninin satırda kalan tüm boşluğu kaplamasını ve switch'i sağa itmesini sağlıyoruz.
                  child: Text(
                    'FCM Bildirim Merkezi', //kartın ana başlık metni
                    style: TextStyle(
                      fontSize: 16, //yazı boyutu 16 piksel
                      fontWeight: FontWeight.bold, //yazıyı kalın (bold) yapıyoruz
                      color: Color(0XFFF172A), //başlığın metin rengi
                    ),
                  ),
                ),
                Switch(
                  //kullanıcının konuya abone olup olmama durumunu değiştirebileceği açma/kapama anahtarı
                  value: konuyaAboneMi, //switch'in açık veya kapalı olma durumunu değişkene bağlıyoruz
                  onChanged: onAboneDegisti, //switch durumu değiştiğinde tetiklenecek fonksiyonu veriyoruz
                  activeColor: const Color.fromARGB(15, 160, 40, 50), //switch açık olduğunda alacağı rengi belirliyoruz
                ),
              ],
            ),
            Text(
              //abone olunma durumuna göre ekranda durum mesajını koşullu (ternary) olarak yazdırıyoruz
              konuyaAboneMi ? 'Tüm sınıf yanını aktif' : 'Yayın kapalı',
              style: TextStyle(
                fontSize: 12, //durum yazısının boyutu 12 piksel
                color: konuyaAboneMi
                    ? const Color.fromARGB(15, 24, 59, 17) //abone iken gösterilecek yazı rengi
                    : Colors.grey.shade600, //abone değilken gösterilecek gri renk
                fontWeight: FontWeight.w600, //yazı kalınlığı yarı kalın (semi-bold)
              ),
            ),
            const SizedBox(height: 12), //durum metni ile token kutusu arasına 12 piksel dikey boşluk koyuyoruz
            Container(
              //FCM token bilgisini şık koyu renkli bir kutu içerisinde göstermek için Container kullanıyoruz
              padding: const EdgeInsets.all(10), //kutu içeriğine her yönden 10 piksel iç boşluk veriyoruz
              decoration: BoxDecoration(
                //kutuya arka plan rengi ve köşe yuvarlatması ekliyoruz
                color: const Color(0xFF0F172A), //kutunun arka planına koyu renk veriyoruz
                borderRadius: BorderRadius.circular(8), //kutunun köşelerini 8 piksel yuvarlatıyoruz
              ),
              child: Column(
                //kutu içindeki başlık ve token metnini ortalayarak alt alta diziyoruz
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Cihazın FCM tokeni", //token kutusunun küçük başlık etiketi
                    style: TextStyle(
                      color: Color.fromARGB(255, 26, 40, 52), //başlık yazısının rengi
                      fontSize: 11, //başlık yazı boyutu 11 piksel
                    ),
                  ),
                  const SizedBox(height: 2), //başlık ile token değeri arasına 2 piksel boşluk koyuyoruz
                  SelectableText(
                    //kullanıcının cihaz tokenini ekrandan kolayca seçip kopyalayabilmesi için normal Text yerine SelectableText kullanıyoruz
                    token ?? 'token alınıyor', //eğer token henüz gelmediyse (null ise) 'token alınıyor' mesajı gösteriyoruz
                    style: const TextStyle(
                      color: Color(0xFF38888), //token yazısının rengi
                      fontSize: 11, //yazı boyutu 11 piksel
                      fontFamily: 'monospace', //token uzun bir kod dizisi olduğu için sabit genişlikli kod yazı tipi (monospace) ile gösteriyoruz
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14), //token kutusu ile bildirimler başlığı arasına 14 piksel dikey boşluk bırakıyoruz
            Text(
              'Gelen Bildirimşer (${bildirimler.length}):', //gelen toplam bildirim sayısını başlıkta dinamik olarak gösteriyoruz
              style: const TextStyle(
                fontWeight: FontWeight.bold, //başlığı kalın yapıyoruz
                fontSize: 14, //yazı boyutu 14 piksel
                color: Color.fromARGB(0, 5, 249, 253), //başlık metin rengi
              ),
            ),
            const SizedBox(height: 8), //liste başlığı ile liste içeriği arasına 8 piksel dikey boşluk bırakıyoruz
            bildirimler.isEmpty
                ? Container(
                    //eğer bildirim listesi boşsa kullanıcıya gösterilecek boş durum kutusu
                    padding: const EdgeInsets.all(24), //kutu içine 24 piksel boşluk veriyoruz
                    alignment: Alignment.center, //içindeki metni merkeze hizalıyoruz
                    child: Text(
                      'Henüz Gelen Bildirim Yok', //boş durum bilgilendirme metni
                      textAlign: TextAlign.center, //metni ortalıyoruz
                      style: TextStyle(
                        fontSize: 12, //yazı boyutu 12 piksel
                        color: Colors.grey.shade500, //açık gri renk veriyoruz
                      ),
                    ),
                  )
                : ListView.separated(
                    //bildirimler varsa elemanların arasına çizgi koyarak listeleyen widget
                    shrinkWrap: true, //listenin sonsuz uzamasını engelleyip sadece elemanları kadar alan kaplamasını sağlıyoruz
                    physics: const NeverScrollableScrollPhysics(), //kartın içinde ayrıca kaydırma olmaması, sayfa ile birlikte kayması için kapatıyoruz
                    itemCount: bildirimler.length, //listelenecek toplam bildirim elemanı sayısı
                    separatorBuilder: (_, _) => const Divider(height: 1), //her bildirim elemanının arasına 1 piksel yüksekliğinde ince ayırıcı çizgi çekiyoruz
                    itemBuilder: (BuildContext context, int index) {}, //her bir elemanın ekranda nasıl çizileceğini belirleyen fonksiyon
                  ), //builder'dan farkı her bir eleman arasına boşluk veriyor gap gibi
          ],
        ),
      ),
    );
  }
}
