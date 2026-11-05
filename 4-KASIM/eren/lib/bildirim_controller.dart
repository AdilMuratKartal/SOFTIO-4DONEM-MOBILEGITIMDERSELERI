import 'package:flutter_local_notifications/flutter_local_notifications.dart'; //cihazın kendi yerel bildirimlerini (status bar/notification shade) yönetmek ve göstermek için yerel bildirim paketini import ediyoruz.
import 'package:firebase_messaging/firebase_messaging.dart'; //FCM üzerinden gelen RemoteMessage bildirim mesajı modelini ve özelliklerini kullanabilmek için firebase_messaging import ediyoruz.

class YerelBildirimController {
  //cihazın yerel bildirim mekanizmasını yöneteceğimiz controller sınıfımızı oluşturuyoruz.
  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      FlutterLocalNotificationsPlugin(); //yerel bildirim eklentisinin metodlarına erişebilmek için FlutterLocalNotificationsPlugin nesnesi üretiyoruz. static yaparak her yerden tek bir örnek üzerinden erişiyoruz.

  static Future<void> kurulum() async {
    //yerel bildirimlerin çalışabilmesi için cihaz başlangıç ayarlarını (initialization) yapacağımız asenkron metodumuz.
    //Android ayarlar
    const androidAyarlar = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    ); //logo resimleri var app/src/main/run/ßmipmap
    const iosAyarlar = DarwinInitializationSettings(); //iOS (Apple Darwin) cihazlar için bildirim başlangıç ayarlarını oluşturuyoruz.
    const ayarlar = InitializationSettings(
      //hem Android hem de iOS için oluşturduğumuz ayarları tek bir çatı altında birleştiren genel başlangıç ayar nesnemiz.
      android: androidAyarlar, //Android ayarlarını parametre olarak veriyoruz.
      iOS: iosAyarlar, //iOS ayarlarını parametre olarak veriyoruz.
    );
    await _yerelBildirim.initialize(settings: ayarlar); //hazırladığımız ayarlar ile yerel bildirim servisini başlatıyoruz. işlem bitene kadar await ile bekliyoruz.
  }

  static Future<void> bildirimGoster(RemoteMessage message) async {
    //gelen RemoteMessage mesajını yerel bildirim olarak ekranda gösterecek metodumuz.
    const androidDetay = AndroidNotificationDetails(
      //Android'e özel bildirim kanal detaylarını belirliyoruz (Android 8.0+ için bildirim kanalı zorunludur).
      'softito_kanal_id', //bildirim kanalının benzersiz kimliği (channel id)
      'Softito Bildirimleri', //kullanıcının telefon ayarlarında göreceği bildirim kanal adı (channel name)
      importance: Importance.max, //bildirimin önem seviyesini en yükseğe ayarlıyoruz ki ekranda anlık banner (heads-up) olarak açılsın
      priority: Priority.high, //öncelik seviyesini yüksek yapıyoruz
      playSound: true, //bildirim sesi çıkması için true veriyoruz
    );
    const detaylar = NotificationDetails(android: androidDetay); //oluşturduğumuz Android ayarlarını genel NotificationDetails nesnesine bağlıyoruz.
    await _yerelBildirim.show(
      //yerel bildirimi ekranda gösteren metod
      id: message.hashCode, //message.messageId var o değilde bu olması gerekiyor. o mesajın ıd'sidir. normal id'yi hash olarak gönderiyor.
      title: message.notification?.title ?? 'Yeni Bildirim', //bildirimin başlığı null gelirse varsayılan olarak 'Yeni Bildirim' yazdırıyoruz.
      body: message.notification?.body ?? '', //bildirimin gövde metni null gelirse boş bırakıyoruz.
      notificationDetails: detaylar, //yukarıda tanımladığımız kanal ve bildirim detaylarını metoda iletiyoruz.
    );
  }
}

//flutter çalışırken ios ve android ayrı derleyip çalıştırıyor, bizde burda ios ve android için ayrı ayrı ayar kodları yazıyoruz.
//static kullanımı ise sınıfın öğrneğini oluşturmadan ismi ile metod kullanabiliyoruz mesela YerelBildirimController.kurulum() diye. Genellikle uygulamanın her yerinde kullanabileceğimiz sabit değişkenler ve metodlar için static kullanırız. işlevi aynı yapıcak bir işlem yapucak aynı metod üzerinden yapcak o yüznde. Ek olarak gene sınıfın objesini oluşturup kullanabilirdik ama static kullanmak daha pratik olabilioyr yukarıdaki gibi gene instance'si ile sınıflara ulaşabiliriz.
//neden importance ve priorty de girdik ikisinide ? -> ikside birbiriyle bağlantılı android için android
