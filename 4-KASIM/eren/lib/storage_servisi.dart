import 'dart:io';//Web uygulamaları dışında olan, mobil ,masaüstü uygulamaları için kullandığımız, http, json, tarih , dosya yönetimi File , socket'i kullanbildiğimiz pakettir import ediyoruz aşağıda File kullanıcaz.

import 'package:firebase_storage/firebase_storage.dart';//GOOGLE'IN bize sağladığı bir bulut depolamadır. içerisine resim,video,pdf vs. büyük boyutlu dosyalar koyabilmizi sağlar.

class StorageServisi {//servislerimin fonksiyonlarını kullanacağım sınıf'ımızı oluşturuyoruz
  final FirebaseStorage _storage = FirebaseStorage.instance;//bu depolama servisini kullanabilmek adına FirebaseStorage.instance ile bir örneği, kopyasını alıyoruz.

  UploadTask yuklemeBaslat({//servisimize dosya yükleme işlemlerini yapacağımız fonksiyon
    required File dosya,//yükleyeceğimiz dosya File türünde. verinin girilmesi zorunlu diyoruz 
    required String hedefDizin,//yükleyeceğimiz dosyanın storage'de bulunmasını istediğimiz dosya yolu. verinin girilmesi zorunlu diyoruz 
    required String dosyaAdi,//yükleyeceğimiz dosyaya vereceğimiz ad. verinin girilmesi zorunlu diyoruz 
  }) {
    final Reference ref = _storage.ref().child('$hedefDizin/$dosyaAdi');//storage servisimizden .ref() ile ilk olarak boş verip storage'nin kök yolunu(dizini)(path'ini)alıyoruz. daha sonra child() ' a dosyanın dizin yolunu aldığımız hedefDizin ve dosyaAdi parametreleri ile dosyanın storage'deki yerini(yolunu)belirliyoruz Reference türünde. 
    final metadata = SettableMetadata(//dosyamızla ilgili ek bilgileri vermek için fonksiyonumuzu açıyoruz, burda dosya dili ,türü, kendi oluşturduğumuz ekstra bilgiler varsa buraya ekliyoruz.  
      contentType: 'image/jpeg', //file/pdf pdf dosyaları için kullanırız. birden fazla dosya ve türleri için [] içine yazarız. burda dosya türümüzün image ve jpeg olduğunu belirttik.
      customMetadata: {'yukleyen': 'Faik fahri furkan fahrettin'},//kendi oluşturduğumuz bir metadeta verisi ekledik daha sonra dosyayı ararken bunlara özel filtre ile daha hızlı bulabiliriz.
    );
    return ref.putFile(dosya, metadata);//yukarıdaki dosya dizinimi ile  oluşturduğumuz bu ref'ransa File türündeki dosyamızı ve metadata bilgileri ile yükle diyoruz. Bize de dönüş olarak bir devam eden bir yükleme görevini gösteren bir sınıf olan UploadTask'ı döndürücek 
  }

  task.snapshot.listen((TaskSnapshot snaphot){//yukarıdaki dosya yükleme görevini belirten UploadTask dönüşlü fonksiyonumuzun çıktısı olan task değişkenimiz ile burda yükleme durumunu dinleyip kullanıcıya göstermek, konsola yazdırmak vs. gibi yüklenme durumunu verilerini dinleyecceğimiz task.snapshot bu yükleme görevinin anlık kopyasıdır  task.snapshot.listen ile bu kopyayı dinleyip yükleme hangi durumda onları alacağız dinleme durumunda yapılacak işlemlerimiz için listen() fonksyionuna bu görevin anlık kopyasını ifade eden TaskSnapshot türünü parametre olarak alan işlemleri yapacağımız fonksiyonuzmu yazıyoruz. 
    final double yuzde = snapshot.bytesTransferred / snapshot.totalBytes;//yükleme oranını bulabilmek için anlık snapshot(kopya)mızın toplam yüklenen boyutunu toplam boyutuna bölüyoruz. 
    print('yükleniyor %${(yuzde * 100).toStringAsFixed(1)}');//bu yüklenme yüzdesini 100 ile çarpıp virgülden sonra bir basamak daha yazdıracak şekilde string olarak yazdırıyoruz konsola 
  });

}
