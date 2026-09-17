## **1\. SQL CRUD İşlemleri**

**1.1** **CREATE/INSERT**  

&nbsp;

CREATE TABLE IF NOT EXISTS users{

&nbsp;id INTEGER PRIMARY KEY AUTOINCREMENT,

&nbsp;fullname TEXT NOT NULL,

&nbsp;email TEXT UNIQUE NOT NULL,

&nbsp;phone TEXT UNIQUE NOT NULL,

&nbsp;created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP

}

&nbsp;

&nbsp;

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |

&nbsp;

&nbsp;

INSERT INTO users(fullname,email,phone)

VALUES

(‘aslan’,’annz@gmail.com’,’5323255176’),

(‘hayrettin’,’hyrmn@gmail.com’,’5163812191’),

(‘ahmet’,’[aknfq@gmail.com](mailto:aknfq@gmail.com)’,’5264788387’),

&nbsp;

**ÖNCE**

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |

&nbsp;

**SONRA**&nbsp;

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 1 | aslan | annz@gmail.com | 5323255176 | 2026-09-17 02:05:00&nbsp; |
| 2 | hayrettin | hyrmn@gmail.com | 5163812191 | 2026-09-17 02:06:15&nbsp; |
| 3 | ahmet | aknfq@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

&nbsp;

**1.2** **SELECT**&nbsp;

&nbsp;

SELECT \* FROM users; //bütün kullanıcıları çağırdık

&nbsp;

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 1 | aslan | annz@gmail.com | 5323255176 | 2026-09-17 02:05:00&nbsp; |
| 2 | hayrettin | hyrmn@gmail.com | 5163812191 | 2026-09-17 02:06:15&nbsp; |
| 3 | ahmet | aknfq@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

&nbsp;

**1.3 UPDATE**

&nbsp;

UPDATE users SET email=’pghn@gmail.com’ WHERE id=3;&nbsp;

//3 id değerinde olan kullanıcının email değeri değeri değiştirildi.

&nbsp;

**ÖNCE**

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 3 | ahmet | aknfq@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

**SONRA**

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 3 | ahmet | pghn@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

&nbsp;

**1.4 DELETE**

&nbsp;

DELETE FROM users WHERE id=2;

&nbsp;

**ÖNCE**

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 1 | aslan | annz@gmail.com | 5323255176 | 2026-09-17 02:05:00&nbsp; |
| 2 | hayrettin | hyrmn@gmail.com | 5163812191 | 2026-09-17 02:06:15&nbsp; |
| 3 | ahmet | aknfq@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

&nbsp;

**SONRA**

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 1 | aslan | annz@gmail.com | 5323255176 | 2026-09-17 02:05:00&nbsp; |
| 3 | ahmet | aknfq@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

&nbsp;

## **2\. INNER JOIN**

SELECT&nbsp;

&nbsp;users.fullname,

&nbsp;users.email,

&nbsp;orders.orderNum

FROM users

INNER JOIN orders ON users.userid \= orders .id&nbsp;

&nbsp;

users ve orders tablosundaki ortak verilerin listelendiği ortak olmayan verilerin ise listelenmediği görülecektir.

&nbsp;

**ÖNCE**

&nbsp;

**USER**&nbsp;

| id | fullname | email | phone | created\_at |
| :---- | :---- | :---- | :---- | :---- |
| 1 | aslan | annz@gmail.com | 5323255176 | 2026-09-17 02:05:00&nbsp; |
| 2 | hayrettin | hyrmn@gmail.com | 5163812191 | 2026-09-17 02:06:15&nbsp; |
| 3 | ahmet | aknfq@gmail.com | 5264788387 | 2026-09-17 02:13:35 |

&nbsp;

**ORDER**

| id | userid | orderNum | total\_amount |
| :---- | :---- | :---- | :---- |
| 1 | 1 | SIP-2026-001&nbsp; | 456 |
| 2 | 3 | AQR-2026-053 | 215 |

&nbsp;

**SONRA(ÇIKAN TEK BİR TABLO)**

&nbsp;

&nbsp;

| fullname | email | orderNum |
| :---- | :---- | :---- |
| aslan | annz@gmail.com | SIP-2026-001&nbsp; |
| ahmet | aknfq@gmail.com | AQR-2026-053 |

&nbsp;

&nbsp;

## **3\. Mobil Uygulama Güvenliği**

&nbsp;

### **a) Ekran görüntüsü ve ekran kaydı**

&nbsp;

Telefona fark edilmeden yüklenen casus yazılımlar, ekran görüntüsü, ekran kaydı izinlerine sahip oluyorlar. Bu da bankacılık uygulamasında bunlar engellenmezse sizin giriş,kart vs. bilgilerinizi çalmalarına neden olucaktır.

&nbsp;

Androidde : Uygulama kodları arasında WindowManager.LayoutParams.FLAG\_SECURE flag’ı ekleyerek uygulama içerisinde ekran görüntüsü alamaz.

&nbsp;

IOS: Uygulama kodları arasında UIScreen.main.isCaptured() ekleyerek engelleriz.

&nbsp;

### **b) Overlay saldırıları**

Kullanıcı saldırganın uygulamaları üzerinde herhangi bir istek atabilmek için buton, link vs. tıklanamanı sağlarlar. Bunlara tıklandığında aslında sizin telefonunuzdaki verilere erişebilir, yada bankacılık gibi telefon içindeki uygulamalarınızda istekler atabilir, sizin yerinize sipariş verebilir, para transfer edebilir.

&nbsp;

### **c) Root / Jailbreak**

Root/Jailbreak yapılan cihazlar dosya izinlerini devre dışı bırakır. Cihazda en üst yetki olan root yetkisi aktifleştiği için sistemdeki herhangi bir zararlı yazılım veya kullanıcı, tüm sistemin ve diğer tüm uygulamaların kontrolünü ele geçirebilir.

&nbsp;

Normalde kilitli olan özel dizine su (superuser) komutuyla girilerek shared\_prefs veya dahili SQLite veritabanı doğrudan okunabilir ya da bilgisayara çekilebilir

&nbsp;

### **d) SQLite ve şifreleme**

Cihaz rootlanırsa, erişim sağlanırsa ya da cihazın yedeklemesi alınırsa, dosya doğrudan SQLite Browser gibi bir araçla açılabilir. Bunun sonucunda tablolardaki kullanıcı parolaları, kimlik numaraları, kart bilgileri değiştirilebilir veya silinebilir.

&nbsp;

SQLCIPHER ile SQLite şifrelenir anahtar olmadan veri kullanılamaz tamamen çöp olur. Dosyayı saldırgan cihazdan çekip bir SQLite görüntüleyicisinde açmaya çalışsa bile göreceği tek şey anlamsız şifreli metin görür.

&nbsp;

### **e) Access Token ve Refresh Token**

Access Token her API isteğinde ağ üzerinden taşındığı için Man-in-the-Middle saldırılarıyla, client / server arasındaki açıklarla çalınma ihtimali yüksektir. Bu çalınma durumlarında token’nin geçerliliğini kısa süreli tutarak saldırganın sisteme erişimini kısatlamış oluruz

&nbsp;

Refresh Token'ın kullanım ömrü çok daha uzundur (günler, haftalar veya aylar). Bu Token saldırganın eline geçerse, süresi doldukça yeni Access Token'lar üreterek kullanıcı adına sürekli ve kalıcı yetki kazanabilir bu yüzden şifreli alanlarda saklanması zorunludur.&nbsp;

&nbsp;

Çoğu Access Token yapısı gereği sunucuda durum tutmaz; yani süresi dolana kadar sunucu tarafında tekil olarak geçersiz kılınması maliyetlidir. Çıkış işleminde sunucu veritabanında saklanan Refresh Token kaydı silinir veya iptal edilir. Böylece istemcideki kısa süreli Access Token'ın süresi bittiğinde sistem artık yeni bir Access Token üretmeyi reddeder ve oturum kalıcı olarak sonlandırılmış olur.