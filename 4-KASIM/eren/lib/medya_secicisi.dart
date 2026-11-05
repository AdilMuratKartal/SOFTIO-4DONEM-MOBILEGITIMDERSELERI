import 'dart:io'; //Web uygulamaları dışında olan, mobil ,masaüstü uygulamaları için kullandığımız, http, json, tarih , dosya yönetimi File , socket'i kullanbildiğimiz pakettir import ediyoruz aşağıda File kullanıcaz..

import 'package:flutter/widgets.dart'; //FLUTTER frameworkun temel ve çekirdek kütüphane tasarıom için indiriyoruz
import 'package:image_picker/image_picker.dart'; //Kamera ve galeriye erişmek için kullandığımız kütüphane import ettik

class MedyaSeciciServisi {
  //resimleri seçmek için bir secici sınıfı oluşturuyoruz
  final ImagePicker _picker = ImagePicker(); //resimleri secme için gereklen ImagePicker sınıfımızın örneğini üretiyoruz.

  Future<File?> galeridenSec() async {
    //galeriden resim seçme metodumuz dönüş olarak seçtiğimiz foto yada hiçbir şey seçmezsek yada bulunamazsa vs. diye null? .ne zaman biteceği belli olmayan bir iş olduğu için arka planda çalışacak olan future ve async metod olduğunu belirtiyoruz
    final XFile? secilen = await _picker.pickImage(
      //resimlerimiz seçmek için pickImage metodumuzu başlatıyoruz, ve bu metod işlemi için await kullanarak sistemin dosyayı getirmesini bekleticez.
      source: ImageSource
          .gallery, //seçilecek resmin cihazın galerisinden olacağını söylüyoruz
      imageQuality:
          80, //resim kalitesini int olarak aldığı oran kadar ayarlıyor burda 80
      maxWidth:
          1200, //resmin maks genişliğinin 1200 piksel olacağını söylüyoruz.
    );
    if (secilen == null) return null; //eğer seçtiğimiz dosya null ise birşey döndürmeden metoddan çıkıyoruz
    return File(secilen.path); //secilen null gelmediğine göre seçilen dosyanın path(yolunu alıp)ve File(dosyamızı geri döndürüyoruz) ile
  }

  Future<File?> kameradanCek() async {
    //kameradan resim çekme metodumuz dönüş olarak seçtiğimiz foto yada hiçbir şey seçmezsek yada bulunamazsa vs. diye null? .ne zaman biteceği belli olmayan bir iş olduğu için arka planda çalışacak olan future ve async metod olduğunu belirtiyoruz
    final XFile? cekilen = await _picker.pickImage(
      //resimlerimizi kameradan çekmek için pickImage metodumuzu başlatıyoruz, ve bu metod işlemi için await kullanarak sistemin dosyayı getirmesini bekleticez.
      source: ImageSource
          .camera, //seçilecek resmin kamerası ile olacağını söylüyoruz
      imageQuality:
          80, //resim kalitesini int olarak aldığı oran kadar ayarlıyor burda 80
      maxWidth:
          1200, //resmin maks genişliğinin 1200 piksel olacağını söylüyoruz.
    );
    if (cekilen == null) return null; //eğer seçtiğimiz dosya null ise birşey döndürmeden metoddan çıkıyoruz
    return File(cekilen.path); //secilen null gelmediğine göre seçilen dosyanın path(yolunu alıp)ve File(dosyamızı geri döndürüyoruz) ile
  }
}
