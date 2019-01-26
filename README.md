rubian
======

Rubian, Ruby ve Debian isimlerinden türetilmiş bir kısaltmadır. Debian ve türevi
dağıtımlara desteklenen, sınırlı sayıdaki Ruby sürümümlerini kurmak, versiyonlar
arasındaki geçişi yönetmek ve güncellemeleri almak için geliştirilmiştir.

Mevcut sürümdeki özellikler

- Sistem geneli çalışır
- Sadece MRI (the gold standard) için kullanılabilir
- [`jemalloc`](http://jemalloc.net) destekler

Rubian, Ruby ile birlikte `rubygems` ve `bundler` kurar. Bunlar için aşağıdaki
üç tip sürümü destekler.

- `stable`, en güncel sürümleri kurar
- `unstable`, henüz kararlı sürümü yayınlanmamış (pre-released, alpha, beta)
  sürümleri kurar
- `legacy`, bir önceki sürümün son kararlı "patch"ini kurar

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

### Ruby kurma

```sh
rubian install [OPTIONS...] VERSION
```

- `VERSION` argümanı için sadece aşağıdaki seçenekler geçerlidir.

  - `stable`
  - `unstable`
  - `legacy`

- Güncel sürüm kurmak için

  ```sh
  rubian install stable
  ```

### Ruby kaldırma

```sh
rubian uninstall VERSION
```

### Mevcut sürüm

Sistemde kurulu ve kullanılan sürümü görüntülemek için

```sh
rubian status
```

License
-------

Rubian Copyright (C) 2019 [Alaturka Authors](https://github.com/alaturka).
