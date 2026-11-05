import 'package:firebase_messaging/firebase_messaging.dart'; //firebase'in mesajlaşma servisini kullanabilmek için firebase_messaging import ediyoruz.

//ARKA PLANDA DİNLEYEBİLMEMİZ İÇİN HER ZAMAN EN ÜSTE TOP LEVEL OLMAK ZORUNDADIR . pragma herşeyden bağımısız telefonu arka planda çalışmamızı sağlar.izinleride aldık requestPermission dan sonra ön tarafa tada dinlemek için bekleyebiliriz.

@pragma('vm:entry-point') //. pragma herşeyden bağımısız telefonu arka planda çalışmamızı sağlar. derleyicinin bu fonksiyonu kullanılmıyor zannedip silmesini (tree-shaking) engeller.pragma derleyeciye yada sanal makineye ne yapacağını söylediğimiz komutlar aslında.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //arka planda dinlediğimiz bildirimleri burada yakalıyoruz bu fonksiyondada bildirimi sadece yazdırdık konsola. RemoteMessage türündsen değiken alıcağımızı belirtiyoruz.
  print(
    "Arka planda bildirim geldi: ${message.notification?.title}",
  ); //yakalanan mesajın başlığını yazdırıyoruz
}

class BildirimServisi {
  // bildirimleri yöneteceğimiz sınıfımızı yazıyoruz
  final FirebaseMessaging _fcm = FirebaseMessaging.instance; //firebase mesajlaşma servisinin özelliklerini kullanabilmemiz için .instance ile sınfın örneğini oluşturuyoruz

  Future<void> baslat() async {
    //bildirim dinlemeyi başlattğımız metod dönüş olarak birşey döndürmeecek sadece işlem yapacak
    NotificationSettings settings = await _fcm.requestPermission(
      //kullanıcıdan bildirim izinlerini aldığımız metoddur
      alert: true, //bildirim yapmak için izin istiyoruz
      badge: true, //bildirimde resimler için izin istiyoruz
      sound: true, //bildirim sesi için izin istiyoruz
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //kullanıcının bildirime izin verip vermediğini AuthorizationStatus.authorized ile kontrol ediyoruz
      print(
        "Kullanıcı Bildirim iznini verdi",
      ); //kullanıcı izin vermişse ekrana bu yazıyı yazdırıyoruz
    }
    final token = await _fcm.getToken(); //firebase den bu servisimizi için kullanamak için token istiyoruz. await ile cevap gelene kadar bekletiyoruz
    print('Cihazın FCM tokenı: $token'); //sınıfın dışındada okunması için pragma tanımlayacağız. GELEN BU TOKENİ EKRANA YAZDIRIYORUZ
  }
}
