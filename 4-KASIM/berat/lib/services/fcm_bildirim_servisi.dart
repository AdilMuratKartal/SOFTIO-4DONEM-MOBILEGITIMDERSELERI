import 'dart:io'; //Web uygulamaları dışında olan, mobil ,masaüstü uygulamaları için kullandığımız, http, json, tarih , dosya yönetimi File , socket'i kullanbildiğimiz pakettir import ediyoruz aşağıda File kulla

import 'package:firebase_messaging/firebase_messaging.dart'; //firebase'in mesajlaşma servisini kullanabilmek için firebase_messaging import ediyoruz.

import 'package:firebase_core/firebase_core.dart'; //firebase_core paketini import ediyoruz
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; //flutter'ın yerel bildirimler için kullandığımız flutter_local_notifications paketini import ediyoruz

@pragma('vm:entry-point') //. pragma herşeyden bağımısız telefonu arka planda çalışmamızı sağlar. derleyicinin bu fonksiyonu kullanılmıyor zannedip silmesini (tree-shaking) engeller.pragma derleyeciye yada sanal makineye ne yapacağını söylediğimiz komutlar aslında.
Future<void> fcmBackgroundHandler(RemoteMessage message) async {} //arka planda mesaj yakalıyor

class FcmBildirimServisi {
  // bildirimleri yöneteceğimiz sınıfımızı yazıyoruz
  final FirebaseMessaging _fcm = FirebaseMessaging.instance; //firebase mesajlaşma servisinin özelliklerini kullanabilmemiz için .instance ile sınfın örneğini oluşturuyoruz
  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin(); //cihazın kendi yerel bildirimlerini göstermek için FlutterLocalNotificationsPlugin sınıfından bir nesne örneği alıyoruz

  Future<void> baslat({
    //bildirim dinlemeyi başlattğımız metod dönüş olarak birşey döndürmeecek sadece işlem yapacak
    required Function(RemoteMessage message) onMesajGeldi, //mesaj geldiğinde çalıştırılacak fonksiyonuzumu girdi olarak alıyoruz
  }) async {
    await _fcm.requestPermission(
      alert: true, //bildirim yapmak için izin istiyoruz
      badge: true, //bildirimde resimler için izin istiyoruz
      sound: true, //bildirim sesi için izin istiyoruz
    ); //BİLDİRİMİ için kullanıcıdan izin istiyoruz.

    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher'); //Android tarafında bildirim ikonu olarak uygulamanın varsayılan logosunu (ic_launcher) ayarlıyoruz
    const iosSetting = DarwinInitializationSettings(); //iOS cihazlar için bildirim izin ve gösterim ayarlarını tanımlıyoruz
    const initSettings = InitializationSettings(
      //hem Android hem de iOS ayarlarını tek bir başlatma nesnesinde topluyoruz
      android: androidSetting, //Android ayarını veriyoruz
      iOS: iosSetting, //iOS ayarını veriyoruz
    );

    await _localPlugin.initialize(initSettings); //yerel bildirim eklentisini hazırladığımız ayarlar ile başlatıp hazır hale getiriyoruz
    FirebaseMessaging.onMessage.listen((message) {
      //uygulama ön planda açıkken (foreground) FCM'den gelen bildirimleri anlık olarak dinliyoruz
      _yerelBildirimGoster(message); //gelen bildirimi kullanıcının üst bildirim çubuğunda görebilmesi için yerel bildirim olarak fırlatıyoruz
      onMesajGeldi(message); //gelen mesaj bilgisini parametre olarak gelen fonksiyona aktarıp arayüzün (UI) güncellenmesini sağlıyoruz
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler); //uygulama arka plandayken veya kapalıyken gelen bildirimleri yakalayacak arka plan fonksiyonunu kaydediyoruz
  }

  Future<void> konuyaAboneOl(String konu) async {
    //belirli bir bildirim konusuna (topic) abone olarak o konuya gönderilen toplu bildirimleri almak için fonksiyon
    await _fcm.subscribeToTopic(konu); //Firebase üzerinden verilen konu başlığına cihazı abone ediyoruz
  }

  Future<void> konudanAyril(String konu) async {
    //abone olunan bildirim konusundan ayrılmak ve artık o konudan bildirim almamak için fonksiyon
    await _fcm.unsubscribeFromTopic(konu); //Firebase üzerinden ilgili konunun aboneliğini iptal ediyoruz
  }

  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    //FCM'den gelen bildirimi yerel bildirim olarak ekranda göstermek için kullandığımız özel yardımcı metod
    const androidDetails = AndroidNotificationDetails(
      //Android platformuna özel bildirim kanalı detaylarını belirliyoruz
      'softit_fcm_channel_id', //bildirim kanalının benzersiz id değeri
      'Softito bildirimleri', //kullanıcının telefon ayarlarında göreceği kanal ismi
      channelDescription: 'Fcm Push Bildirimleri', //kanalın ne amaçla kullanıldığını belirten açıklama metni
      importance: Importance.max, //bildirimin önem derecesini maksimum yaparak ekranda banner (heads-up) şeklinde açılmasını sağlıyoruz
      priority: Priority.high, //Android bildirim önceliğini yüksek olarak belirliyoruz
    );

    const details = NotificationDetails(
      //Android ve iOS bildirim özelliklerini tek bir NotificationDetails nesnesi içinde birleştiriyoruz
      android: androidDetails, //Android kanal ayarlarımızı bağlıyoruz
      iOS: DarwinNotificationDetails(), //iOS için varsayılan bildirim detaylarını ekliyoruz
    );

    await _localPlugin.show(
      //yerel bildirimi cihazın bildirim çubuğunda tetikleyip gösteriyoruz
      message.hashCode, //bildirimin benzersiz olması için gelen mesajın hashCode değerini bildirim id'si yapıyoruz
      message.notification?.title ?? 'Yeni Bildirim', //gelen bildirimin başlığı, eğer null gelirse varsayılan olarak 'Yeni Bildirim' yazdırıyoruz
      message.notification?.body ?? '', //gelen bildirimin gövde metni, eğer null gelirse boş bırakıyoruz
      details, //yukarıda oluşturduğumuz kanal ve ses/öncelik detaylarını metoda veriyoruz
    );
  }
}
