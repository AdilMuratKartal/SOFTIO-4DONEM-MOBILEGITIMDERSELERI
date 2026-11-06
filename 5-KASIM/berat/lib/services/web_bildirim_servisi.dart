import 'package:firebase_messaging/firebase_messaging.dart'; //firebase'in mesajlaşma servisini kullanabilmek için firebase_messaging kütüphanesini import ediyoruz.
import '../constants/fcm_web_config.dart'; //git'e gönderilmeyen ve VAPID anahtarımızı güvenle sakladığımız konfigürasyon dosyamızı import ediyoruz.

// Web platformu için özel olarak hazırladığımız bildirim servisi sınıfı
class WebBildirimServisi {
  // FirebaseMessaging servisinin fonksiyonlarını kullanabilmek için singleton instance örneğini alıyoruz
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Web bildirim servisini başlatan ana fonksiyonumuz
  Future<void> baslat({
    // Bir bildirim mesajı geldiğinde çalışacak olan ve arayüzü güncelleyecek fonksiyon parametresi
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
    // 1. ADIM: Tarayıcıdan bildirim göndermek için izin istiyoruz
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true, // Ekranda bildirim banner'ı çıkması için izin
      badge: true, // Tarayıcı sekmesinde veya ikonunda rozet/sayı için izin
      sound: true, // Bildirim geldiğinde ses çalması için izin
    );

    // Kullanıcının izin verip vermediğini konsola yazdırıyoruz
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Web: Kullanıcı bildirim iznini verdi.');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Web: Kullanıcı geçici bildirim izni verdi.');
    } else {
      print('Web: Kullanıcı bildirim iznini reddetti.');
    }

    // 2. ADIM: Ön planda (web sekmesi açıkken) gelen bildirimleri dinliyoruz
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Web Ön Planda Bildirim Geldi: ${message.notification?.title}');
      print('İçerik: ${message.notification?.body}');

      // Arayüzün haberdar olması için dışarıdan gelen fonksiyonu tetikliyoruz
      onMesajGeldi(message);
    });

    // 3. ADIM: Kullanıcı arka plandaki bildirime tıkladığında uygulamayı açan dinleyici
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Web: Kullanıcı bildirime tıklayarak sekmeyi açtı: ${message.data}');
    });
  }

  // Web için FCM token alma fonksiyonumuz (VAPID key burada kullanılır)
  Future<String?> tokenAl() async {
    try {
      // Web tarayıcısında FCM token üretilirken Firebase Console'dan aldığımız Web Push VAPID anahtarını vermek zorunludur.
      final String? token = await _fcm.getToken(
        vapidKey: FcmWebConfig.vapidKey, // fcm_web_config.dart dosyasından güvenle okuyoruz
      );
      print('Web FCM Token Başarıyla Alındı: $token');
      return token;
    } catch (e) {
      print('Web FCM Token Alınırken Hata Oluştu: $e');
      return null;
    }
  }

  // Konuya abone olma fonksiyonu (Web için bilgilendirme ve güvenli geçiş)
  Future<void> konuyaAboneOl(String konu) async {
    // Firebase Web SDK'sı istemci üzerinden doğrudan subscribeToTopic() desteklemez (UnimplementedError verir).
    // Bu nedenle hata fırlatıp uygulamayı çökertmek yerine kullanıcıya konsoldan bilgi veriyoruz.
    print(
      'Bilgi: Web istemcisinde doğrudan konuya abone olma (subscribeToTopic) Firebase tarafından desteklenmez. '
      'Web kullanıcıları için konu aboneliği sunucu (Firebase Admin SDK / Cloud Functions) üzerinden token ile yapılır.',
    );
  }

  // Konudan ayrılma fonksiyonu (Web için bilgilendirme ve güvenli geçiş)
  Future<void> konudanAyril(String konu) async {
    print('Bilgi: Web istemcisinde unsubscribeFromTopic desteklenmez.');
  }
}
