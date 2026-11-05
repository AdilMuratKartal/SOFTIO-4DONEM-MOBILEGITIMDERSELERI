import 'dart:io'; //Web uygulamaları dışında olan, mobil ,masaüstü uygulamaları için kullandığımız, http, json, tarih , dosya yönetimi File , socket'i kullanbildiğimiz pakettir import ediyoruz aşağıda File kullanıcaz..

import 'package:firebase_storage/firebase_storage.dart'; //GOOGLE'IN bize sağladığı bir bulut depolamadır. içerisine resim,video,pdf vs. büyük boyutlu dosyalar koyabilmizi sağlar.
import 'package:image_picker/image_picker.dart'; //Kamera ve galeriye erişmek için kullandığımız kütüphane import ettik

class StorageServisi {
  //depomuzla ilgile verileri getirme silme işlmelerimizi yapacağımız sınıfı oluşturuyoruz
  final FirebaseStorage _storage = FirebaseStorage.instance; //bu depolama servisini kullanabilmek adına FirebaseStorage.instance ile bir örneği, kopyasını alıyoruz
  final ImagePicker _picker = ImagePicker(); //resimleri secme için gereklen ImagePicker sınıfımızın örneğini üretiyoruz.

  Future<File?> gorselSec({bool kameradan = false}) async {
    //görselleri kameradanmı yoksa galleriden seçeceğimiz, ve bu resimleri alacağımız metodumuz dönüş olarak seçtiğimiz foto yada hiçbir şey seçmezsek yada bulunamazsa vs. diye null? .ne zaman biteceği belli olmayan bir iş olduğu için arka planda çalışacak olan future ve async metod olduğunu belirtiyoruz. varsayılan olarak görselin kameradan gelmediğini belirtiyoruz.
    final XFile? xFile = await _picker.pickImage(
      //resimlerimizi  çekmek için pickImage metodumuzu başlatıyoruz, ve bu metod işlemi için await kullanarak sistemin dosyayı getirmesini bekleticez.
      source: kameradan ? ImageSource.camera : ImageSource.gallery, //seçilecek resmin cihazın kamerasından gelme durumunu kontrol ediyoruz eğer kamerdan gelmezse galerisinden olacağını söylüyoruz.
      imageQuality: 80, //resim kalitesini int olarak aldığı oran kadar ayarlıyor burda 0-100 arası 80 verdik
      maxWidth:
          1200, //resmin maks genişliğinin 1200 piksel olacağını söylüyoruz.
    );
    if (xFile == null) return null; //eğer seçtiğimiz dosya null ise birşey döndürmeden metoddan çıkıyoruz
    return File(xFile.path); //secilen null gelmediğine göre seçilen dosyanın path(yolunu alıp)ve File(dosyamızı geri döndürüyoruz) ile
  }

  UploadTask yuklemeBaslat({
    //servisimize dosya yükleme işlemlerini yapacağımız fonksiyon
    required File dosya, //yükleyeceğimiz dosya File türünde
    required String dosyaAdi, //yükleyeceğimiz dosyaya vereceğimiz ad. verinin girilmesi zorunlu diyoruz
    String klasor = 'yuklemeler', //yükleyeceğimiz dosyanın storage'de bulunmasını istediğimiz dosya yolu. biz burda veri bunun verisini almama durumunda varsayılan olarak yuklemeler klasöründe olsun diyoruz.
  }) {
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi'); //storage servisimizden .ref() ile ilk olarak boş verip storage'nin kök yolunu(dizini)(path'ini)alıyoruz. daha sonra child() ' a dosyanın dizin yolunu aldığımız hedefDizin ve dosyaAdi parametreleri ile dosyanın storage'deki yerini(yolunu)belirliyoruz Reference türünde.
    final metadata = SettableMetadata(
      //dosyamızla ilgili ek bilgileri vermek için fonksiyonumuzu açıyoruz, burda dosya dili ,türü, kendi oluşturduğumuz ekstra bilgiler varsa buraya ekliyoruz.
      contentType: 'image/png', //burda dosya türümüzün image ve png türünde olduğunu belirttik.
      customMetadata: {'ekleyen': 'Berat Atmaca'}, //kendi oluşturduğumuz bir metadeta verisi ekledik daha sonra dosyayı ararken bunlara özel filtre ile daha hızlı bulabiliriz.
    );
    return ref.putFile(dosya, metadata); //yukarıdaki dosya dizinimi ile  oluşturduğumuz bu ref'ransa File türündeki dosyamızı ve metadata bilgileri ile yükle diyoruz. Bize de dönüş olarak bir devam eden bir yükleme görevini gösteren bir sınıf olan UploadTask'ı döndürücek
  }

  Future<String> urlGetir(Reference ref) async {
    //ref vererek(dosya yolu gibi düşün, dizin) bu ref'ten indirme bağlantısını url olarak alıyoruz. String türünde döndürücek.
    return await ref.getDownloadURL(); //bu fonksiyon bize dosyamızın indirme linkini(url) string olark döndürecek. bilinmeyen bir zamanda işlemler biteceği için await ile bekliyoruz.
  }

  Future<void> dosyaSil(String dosyaYolu) async {
    //String tipindeki dosyaYolu parametresi ile storageden dosyamızı sildirdiğimiz fonksiyon bu işlem sonucu bize birşey dönmeyecek sadece işlemler gerçekleşecek ondan void tipinde.
    final Reference ref = _storage.ref().child(dosyaYolu); //storageden dosyamızı bulmak için ilk olarak .ref() ile kök dizine .child(dosyaYolu) ilede bunun altındaki dosyaYolumuzu buluyoruz ve bu yolu Reference türünde ref değişkeni olark döndürüyoruz.
    await ref.delete(); //bu dosyamızın referansı ilede dosyamızı silme işleme yapıyoruz  .delete() ile.  bilinmeyen bir zamanda işlemler biteceği için await ile bekliyoruz.
  }
}
