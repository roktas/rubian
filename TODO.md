Yapılacaklar
============

- Aracı daha da basitleştireceğiz.  Mevcut tasarımda başka bazı projelerde de
  kullandığımız stable/unstable/legacy nosyonunu kullandık.  Gerçeklemeyi biraz
  zorlaştıran bu nosyonun pratikte buna değecek büyük bir yararı yok.  Tamamen
  versiyon bazlı çalışmaya geçilmeli.  Yeni gerçekleme şöyle olmalı:

  + `rubian install`: daima en güncel kararlı sürümü kurar, zaten kuruluysa
    raporlar; kurulum sonrasında yeni sürüme "switch" yapar.

  + `rubian install 2.7.0.pre1`: verilen sürümü kurar, zaten kuruluysa raporlar;
    kurulum sonrasında yeni sürüm **kararlı** ve daha güncelse o sürüme "switch"
    yapar, aksi halde bu işlemi kullanıcıya bırakır (örnekte `pre1` sürümü
    kararlı olmadığından geçiş yapılmaz).

- Ruby sürüm bilgilerini kod içinde tutuyoruz.  İlk gerçeklemede kolayımıza
  geldiğinden böyle yaptık.  Yeni gerçeklemedeki planımız upstream tarafından
  sunulan [indeksi](https://cache.ruby-lang.org/pub/ruby/index.txt) kullanmak.
  İndeksi shell de bile kolayca parse edip Ruby versiyon bilgilerini ve sağlama
  toplamlarını alabiliyoruz.

- Yukarıda açıklanan yola gidildiğinde Bundler, Gem gibi yan araçların sürüm ve
  sağlama toplamı bilgilerini kaybetmiş olacağız.  Ruby 2.6 ve sonrası için bu
  sıkıntı değil.  Gem ve Rake zaten vardı, Bundler Ruby 2.6'da dağıtıma eklendi.
  Yani yeni sürüm bir Ruby kurulduğunda Gem, Bundler ve Rake dağıtımdan zaten
  çıkıyor.  Ayrıca bunları kurmanın manası yok (Bundler 2.x pürüzü dışında).

- Buna göre Ruby 2.6'yı gerçeklemede milat alacağız.  Ruby 2.6 öncesi sürümleri
  desteklemeyi düşünmüyorum.  Bu araç basit olmalı, komple Ruby sürüm yönetimi
  ilgi alanımız dışında.

- Bundler 2.x pürüzü şu: Ruby 2.6 Bundler 1.17.2 ile geliyor.  Bu durumda
  dağıtımdan çıkan Bundler ile yetinelim senaryosu aksıyor.  Şöyle çözelim bunu.
  Öntanımlı davranış dağıtımdan çıkanlarla yetinmek olsun.  Ama seçenek olarak
  "kurulumdan sonra `gem update --system` yap" sunalım.  Öntanımlı olarak bunu
  yapmayalım, verilen versiyon (veya versiyon verilmediğinde seçilen güncel
  versiyon) Ruby 2.6 ise daima güncelleme yapılsın.

- Bir diğer sorun şu: Bundler ve Rake her ne kadar standart dağıtım içinde gelse
  bile bunlar birer Gem olarak kuruluyor.  Mevcut gerçeklemede Rake için Debian
  alternatiflerinde symlink oluşturuyoruz, ki bunu Bundler için de yapmayı
  planlıyorduk.  Bu şekilde symlink oluşturursak Rubian dışında yapılan bir `gem
  install rake` işlemi symlinkleri yok edecektir.  Rubian `relink` komutuyla
  bunları restore edebiliriz ama o zaman da sistem yöneticisinin kurulumu
  downgrade edilmiş olacak.  Tüm bu nedenlerle Rake ve Bundler'ı alternatif
  sisteminin dışında tutmak en doğrusu.  Bu yoldan gidilirse `switch` komutunda
  dikkate almamız gereken bir kaç uç durum olacak, bunları ayrıca dokümante edip
  çözeceğim.  İlk bakışta bu yaklaşımda sorun tespit etmedim.

- Gem kurulumunun sistem geneli yapıldığı sistemlerde şöyle bir sorun daima var
  (Rubian'a özgü değil).  Gem'lerden çıkan programlar `/usr/local/bin` altına
  kuruluyor.  Bu durumda Ruby sürüm değişikliği yapıldığında bu programlar da
  güncellenmezse Ruby sürümü yeni olmakla birlikte kurulu programlar eski Ruby
  ile çalışıyor.  Eski Ruby sürümü korunduğu sürece sorun yok, programlar
  çalışmaya devam ediyor.  Ama geçiş sırasında eski sürüm kaldırılırsa
  sorun başlıyor.  Maalesef Gem komut satırı aracı bu konuda yardımcı olmuyor.
  "Eski Ruby ile kurulan tüm Gem'leri güncelle" gibi bir komut yok.  Rubian'a
  böyle bir özellik ekleyebilirim.

  Bu sorun olağan kullanımda çok önemli değil.  Deployment'larda zaten sistem
  geneli kurulum yapmıyoruz (Bundler'ın var oluş nedeni).  Araçların eski sürüm
  Ruby ile çalışması da büyük bir sorun değil, sonuçta çalışıyor (yeter ki eski
  sürüm korunsun).
