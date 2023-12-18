# Shell Compiler

&emsp; <img src="https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/logo.svg" alt="Shell Compiler Logo" width="140"/>

[![Release](https://img.shields.io/github/v/tag/BarudakRosul/shell-compiler?label=release)](https://github.com/BarudakRosul/shell-compiler/releases)
[![License](https://img.shields.io/github/license/BarudakRosul/shell-compiler)](/LICENSE)
[![Stars](https://img.shields.io/github/stars/BarudakRosul/shell-compiler)](https://github.com/BarudakRosul/shell-compiler/stargazers)
[![Forks](https://img.shields.io/github/forks/BarudakRosul/shell-compiler)](https://github.com/BarudakRosul/shell-compiler/network/members)
[![Issues](https://img.shields.io/github/issues/BarudakRosul/shell-compiler)](https://github.com/BarudakRosul/shell-compiler/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/BarudakRosul/shell-compiler)](https://github.com/BarudakRosul/shell-compiler/pulls)

## Daftar Isi

1. [Pendahuluan](#pendahuluan)
2. [Demo](#demo)
3. [Fitur](#fitur)
4. [Instalasi](#instalasi)
5. [Berkontribusi](#berkontribusi)
6. [Lisensi](#lisensi)
7. [Penghargaan](#penghargaan)
8. [Catatan Perubahan](#catatan-perubahan)

## Pendahuluan

Shell Compiler bertujuan menyediakan solusi yang aman dan serbaguna untuk mengenkripsi berbagai jenis skrip shell, termasuk Bourne Shell (`sh`), Bourne Again Shell (`bash`), Z Shell (`zsh`), Korn Shell (`ksh`), dan MirBSD Korn Shell (`mksh`), menggunakan perpustakaan OpenSSL. Alat ini memastikan kerahasiaan skrip shell, menambahkan lapisan perlindungan tambahan untuk kode yang sensitif.

> [!WARNING]
> Shell Compiler mungkin tidak kompatibel atau tidak didukung pada beberapa sistem, seperti pada Ultrix.

## Demo

![Screenshot 1](https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/screenshot_1.png)

![Screenshot 2](https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/screenshot_2.png)

![Screenshot 3](https://raw.githubusercontent.com/BarudakRosul/shell-compiler/master/images/screenshot_3.png)

## Fitur

Shell Compiler menawarkan fitur-fitur berikut:

- **Enkripsi Aman**: Memanfaatkan OpenSSL untuk enkripsi skrip shell yang kuat dan aman.
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
   - Untuk Termux:
     ```shell
     pkg update -y && pkg upgrade -y
     ```
     ```shell
     pkg install $(cat package.txt) -y
     ```
   - Untuk Linux:
     ```shell
     sudo apt-get update -y && sudo apt-get upgrade -y
     ```
     ```shell
     sudo apt-get install $(cat package.txt) -y
     ```

4. Jalankan aplikasi:

   ```shell
   bash shell-compiler.sh
   ```

## Berkontribusi

Kontribusi pada Proyek Kompilator Shell sangat dihargai! Baik melaporkan bug, menyarankan fitur baru, atau berkontribusi pada perbaikan kode.

## Lisensi

Shell Compiler dilisensikan di bawah Lisensi Apache-2.0 - lihat berkas [LICENSE](/LICENSE) untuk detailnya.

## Penghargaan

Shell Compiler menghargai dukungan dan kontribusi dari individu dan proyek sumber terbuka berikut:

- [Librari OpenSSL](https://www.openssl.org) - Untuk menyediakan landasan yang aman untuk enkripsi.
- @RFHackers - Pengembang utama dan pencipta aplikasi.
- Komunitas sumber terbuka - Untuk kontribusi berharga pada alat dan perpustakaan yang digunakan dalam proyek ini.

## Catatan Perubahan

Terus ikuti perubahan dan pembaruan terbaru Shell Compiler dengan mengacu ke [Catatan Perubahan](https://github.com/BarudakRosul/shell-compiler/releases).

Terima kasih telah memilih Shell Compiler! Kami bertujuan untuk memberikan solusi yang aman dan andal untuk mengenkripsi skrip shell di berbagai lingkungan.
