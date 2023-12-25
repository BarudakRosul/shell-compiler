<div align="center">
  <img src="https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/logo.svg" alt="Shell Compiler Logo" width="140"/>
  <h1>Shell Compiler</h1>
  <p><a href="https://github.com/BarudakRosul/shell-compiler/issues/new?assignees=&labels=bug&projects=&template=bug_report.yml">Laporkan Bug</a> · <a href="https://github.com/BarudakRosul/shell-compiler/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.yml">Ajukan Fitur</a> · <a href="https://github.com/BarudakRosul/shell-compiler/discussions/new?category=q-a">Tanya Jawab</a></p>
  <p>
    <a href="https://github.com/BarudakRosul/shell-compiler/releases"><img src="https://img.shields.io/github/v/tag/BarudakRosul/shell-compiler?label=release" alt="Release"/></a>
    <a href="/LICENSE"><img src="https://img.shields.io/github/license/BarudakRosul/shell-compiler" alt="License"/></a>
    <a href="https://github.com/BarudakRosul/shell-compiler/stargazers"><img src="https://img.shields.io/github/stars/BarudakRosul/shell-compiler" alt="Stars"/></a>
    <a href="https://github.com/BarudakRosul/shell-compiler/network/members"><img src="https://img.shields.io/github/forks/BarudakRosul/shell-compiler" alt="Forks"/></a>
    <a href="https://github.com/BarudakRosul/shell-compiler/issues"><img src="https://img.shields.io/github/issues/BarudakRosul/shell-compiler" alt="Issues"/></a>
    <a href="https://github.com/BarudakRosul/shell-compiler/pulls"><img src="https://img.shields.io/github/issues-pr/BarudakRosul/shell-compiler" alt="Pull Requests"/></a>
  </p>
</div>

## Daftar Isi

1. [Pendahuluan](#pendahuluan)
2. [Demo](#demo)
3. [Fitur](#fitur)
4. [Instalasi](#instalasi)
5. [Penggunaan](#penggunaan)
6. [Berkontribusi](#berkontribusi)
7. [Lisensi](#lisensi)
8. [Penghargaan](#penghargaan)
9. [Catatan Perubahan](#catatan-perubahan)

## Pendahuluan

Shell Compiler bertujuan menyediakan solusi yang aman dan serbaguna untuk mengenkripsi berbagai jenis skrip shell, termasuk Bourne Shell (`sh`), Bourne Again Shell (`bash`), Z Shell (`zsh`), Korn Shell (`ksh`), dan MirBSD Korn Shell (`mksh`), menggunakan perpustakaan OpenSSL, CCrypt, dan Go-crypt. Alat ini memastikan kerahasiaan skrip shell, menambahkan lapisan perlindungan tambahan untuk kode yang sensitif.

> [!WARNING]
> Shell Compiler mungkin tidak kompatibel atau tidak didukung pada beberapa sistem, seperti pada Ultrix.

## Demo

![Screenshot 1](https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/screenshot_1.png)

![Screenshot 2](https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/screenshot_2.png)

![Screenshot 3](https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/screenshot_3.png)

## Fitur

Shell Compiler menawarkan fitur-fitur berikut:

- **Enkripsi Aman**: Memanfaatkan OpenSSL, CCrypt, dan Go-crypt untuk enkripsi skrip shell yang kuat dan aman.
- **Dukungan untuk Berbagai Shell**: Mengenkripsi berbagai jenis skrip shell, termasuk sh, bash, zsh, ksh, dan mksh.
- **Antarmuka Ramah Pengguna**: Antarmuka sederhana dan intuitif untuk proses enkripsi yang mudah.
- **Kustomisasi**: Memungkinkan pengguna menyesuaikan pengaturan enkripsi sesuai dengan kebutuhan keamanan mereka.
- **Kompatibilitas Cross-Platform**: Bekerja dengan lancar di berbagai sistem operasi dan lingkungan.

## Instalasi

Untuk menyiapkan Shell Compiler secara lokal, ikuti langkah-langkah instalasi ini:

1. Kloning repositori:

   ```shell
   git clone https://github.com/BarudakRosul/shell-compiler
   ```

2. Buka direktori repo:

   ```shell
   cd shell-compiler
   ```

3. Instal paket:

   ```shell
   bash install.sh
   ```

4. Jalankan aplikasi:

   ```shell
   bash shell-compiler.sh
   ```

## Penggunaan

Untuk memulai menggunakan Shell Compiler untuk enkripsi file, ikuti langkah-langkah ini:

1. Simpan file yang akan dienkripsi ke folder `file`.
2. Jalankan file `shell-compiler.sh`.
3. Pilih jenis Shell file yang akan dienkripsi (`bash`, `sh`, `zsh`, `ksh`, atau `mksh`) dan klik Enter.
4. Lalu, pilih mode enkripsi dan klik Enter.
5. Terakhir, masukkan nama file yang akan dienkripsi (file harus berada di folder `file`).
6. Setelah berhasil dienkripsi, hasilnya akan disimpan di folder `out`.

## Berkontribusi

Kontribusi pada Shell Compiler sangat dihargai! Baik melaporkan bug, menyarankan fitur baru, atau berkontribusi pada perbaikan kode.

## Lisensi

Shell Compiler dilisensikan di bawah Lisensi Apache-2.0 - lihat berkas [LICENSE](/LICENSE) untuk detailnya.

## Penghargaan

Shell Compiler menghargai dukungan dan kontribusi dari individu dan proyek sumber terbuka berikut:

- Paket [OpenSSL](https://www.openssl.org), [CCrypt](https://ccrypt.sourceforge.net), dan [Go-crypt](https://github.com/BarudakRosul/go-crypt) - Untuk menyediakan landasan yang aman untuk enkripsi.
- [@RFHackers](https://github.com/RFHackers) - Pengembang utama dan pencipta aplikasi.
- Komunitas sumber terbuka - Untuk kontribusi berharga pada alat dan perpustakaan yang digunakan dalam proyek ini.

## Catatan Perubahan

Terus ikuti perubahan dan pembaruan terbaru Shell Compiler dengan mengacu ke [Catatan Perubahan](https://github.com/BarudakRosul/shell-compiler/releases).

Terima kasih telah memilih Shell Compiler! Kami bertujuan untuk memberikan solusi yang aman dan andal untuk mengenkripsi skrip shell di berbagai lingkungan.
