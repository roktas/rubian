rubian
======

Debian ve türevi dağıtımlarda farklı Ruby sürümleri kurmak ve bu sürümler
arasında geçiş yapmak için kullanılan bir araç.

Özellikler:

- Sadece Debian ve türevi dağıtımları destekler
- Sistem geneli çalışır
- Sadece MRI için kullanılabilir
- [`jemalloc`](http://jemalloc.net) destekler
- İlave bağımlılığı yoktur
- Artık bırakmadan kaldırılabilir
- Kurulan sürümler arası geçişi destekler

Anti özellikler:

- Rbenv veya RVM gibi ortam değişkenlerine bağlı olarak kullanıcı veya proje
  özelinde çalışmaz
- Tüm Ruby sürümlerini desteklemez.  Sadece 2.1.3 ve üstü sürümleri destekler.

Kurulum
-------

Kurulum için gerekli olan paketlere sahip olduğunuza emin olun. Ruby için gerekli
paketler bu adımda kurulmaz.

- `curl`

```sh
curl -fsSL https://raw.githubusercontent.com/omu/rubian/master/rubian >/usr/local/bin/rubian
chmod +x /usr/local/bin/rubian
```

Eğer [`scripts`](https://github.com/omu/debian/blob/master/bin/scripts)
yardımcısına sahipseniz aşağıdaki komutu kullanın.

```sh
scripts _/rubian
```

Kullanım
--------

```sh
rubian COMMAND [ARGS...]
```

Komutların tam listesi için `rubian help` kullanın.

### Ruby kur

```sh
rubian install [OPTIONS...] VERSION...
```

`VERSION` argümanı olarak:

- Tam sürüm numarası girebilirsiniz.

  ```sh
  rubian install 2.6.1
  ```

  Ruby 2.6.1 sürümünü kur ve seç.

- Majör sürüm numarası girebilirsiniz.

  ```sh
  rubian install 2.5
  ```

  Ruby 2.5.x serisinin en güncelini (2.5.5) kur ve seç.

- En güncel sürümü belirtmek için `latest` girebilirsiniz.

  ```sh
  rubian install latest
  ```

  En güncel Ruby sürümünü kur ve seç.

- Birden fazla sürüm numarası girebilirsiniz.

  ```sh
  rubian install latest 2.5.1
  ```

  En güncel sürümü ve 2.5.1 sürümünü kur, 2.5.1 sürümünü seç.

### Ruby kaldır

```sh
rubian uninstall VERSION...
```

### Durumu görüntüle

Sistemde kurulu ve kullanılan sürümü görüntülemek için:

```sh
rubian status
```

### Sürüm değiştir

Ruby sürümünü (sistem genelinde) değiştirmek için:

```sh
rubian switch VERSION
```

### Linkleri tazele

Sistem geneli Ruby linklerinde yaşanabilecek bozulmaları düzeltmek için:

```sh
rubian relink
```

Sıkça sorulabilecekler
----------------------

- Rubian adı nereden geliyor?

  Ruby :heart: Debian → Rubian

Lisans
------

Rubian Copyright (C) 2019 [Alaturka Authors](https://github.com/alaturka).

[![CircleCI](https://circleci.com/gh/omu/rubian.svg)](https://circleci.com/gh/omu/rubian)
