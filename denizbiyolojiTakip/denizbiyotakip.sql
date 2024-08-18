-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 24 Ara 2023, 16:21:38
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `denizbiyotakip`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE ` InsertDenizOrganizma` ()   SELECT turler AS tür_adı, ROUND(AVG(derinlik_aralık), 1) AS ortalama_derinlik
FROM denizorganizmalari
GROUP BY turler$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DenizHabitatBirleştirme` ()   SELECT *
FROM denizhabitatlari
JOIN denizbiyolojisiarastirmalari ON denizhabitatlari.habitat_id = denizbiyolojisiarastirmalari.habitat_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DenizKorumaAlaniFiltre` ()   SELECT *
FROM denizkorumaalanlari
WHERE denizkorumaalanlari.korunan_turler = 'Deniz Kaplumbağaları'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gozlembetween` ()   SELECT *
FROM denizcanlilarigozlemleri
WHERE denizcanlilarigozlemleri.gozlem_tarihi BETWEEN '2023-01-01' AND '2023-12-31'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertDenizBiyolojisiArastirma` ()   SELECT habitat_adi AS habitat_adi, ROUND(AVG(ortalama_sicaklik), 1) AS ortalama_sicaklik
FROM denizhabitatlari
WHERE habitat_adi LIKE CONCAT('%', habitat_adi, '%')
GROUP BY habitat_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertDenizHabitat` ()   SELECT habitat_adi AS habitat_adı, ROUND(AVG(ortalama_sicaklik), 1) AS ortalama_sicaklik
FROM denizhabitatlari
GROUP BY habitat_adi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEgitimProgramlari` ()   SELECT *
FROM egitimprogramlari
WHERE baslangic_tarihi > '2022-01-01'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `like` ()   SELECT denizorganizmalari.organizma_id, denizbiyolojisiarastirmalari.arastirmaci_adi,denizbiyolojisiarastirmalari.organizma_id
FROM denizorganizmalari
JOIN denizbiyolojisiarastirmalari ON denizorganizmalari.organizma_id = denizbiyolojisiarastirmalari.organizma_id
WHERE denizbiyolojisiarastirmalari.arastirmaci_adi LIKE '%Ceyda%'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderbyorganizma` ()   SELECT denizcanlilarigozlemleri.organizma_id, denizorganizmalari.organizma_id
FROM denizcanlilarigozlemleri
JOIN denizorganizmalari ON denizcanlilarigozlemleri.organizma_id = denizorganizmalari.organizma_id
ORDER BY denizorganizmalari.habitat_id ASC$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `denizbiyolojisiarastirmalari`
--

CREATE TABLE `denizbiyolojisiarastirmalari` (
  `arastirma_id` int(11) NOT NULL,
  `arastirmaci_adi` varchar(255) DEFAULT NULL,
  `organizma_id` int(11) DEFAULT NULL,
  `habitat_id` int(11) DEFAULT NULL,
  `arastirma_tarihi` date DEFAULT NULL,
  `bulgular` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `denizbiyolojisiarastirmalari`
--

INSERT INTO `denizbiyolojisiarastirmalari` (`arastirma_id`, `arastirmaci_adi`, `organizma_id`, `habitat_id`, `arastirma_tarihi`, `bulgular`) VALUES
(0, 'Dr. Zeynep Demir', 1, 0, '0000-00-00', ''),
(1, 'Dr. Zeynep Demir', 1, 1, '2023-05-10', 'Deniz yıldızlarının beslenme alışkanlıkları araştırıldı.'),
(2, 'Prof. Mehmet Öztürk', 2, 2, '2023-03-22', 'Mercan resiflerindeki biyoçeşitliliğin incelenmesi.'),
(3, 'Dr. Ceyda Ergin', 3, 3, '2023-06-15', 'Mavi balinaların göç yollarının izlenmesi.'),
(4, 'Prof. Selcan Özyalın', 4, 4, '2023-04-05', 'Deniz anasının yaşam döngüsü üzerine bir araştırma.'),
(5, 'Dr. Fatma Akyol', 5, 5, '2023-11-18', 'Mantar mercanlarının derin deniz ekosistemleriyle ilişkisi.'),
(6, 'Prof. Can Yıldırım', 6, 6, '2023-11-18', 'Deniz kaplanlarının kıyı bölgelerindeki davranışları.'),
(7, 'Dr. Leyla Cengiz', 7, 7, '2023-11-18', 'Yunus gruplarının sosyal yapıları üzerine bir çalışma.'),
(8, 'Prof. Ali Demirci', 8, 8, '2023-11-18', 'Deniz kaplumbağalarının kumsallardaki üreme alanları.'),
(9, 'Dr. Aylin Saygılı', 9, 9, '2023-11-18', 'Balina köpekbalıklarının popülasyon dinamikleri.'),
(10, 'Prof. Serdar Özyalın', 10, 10, '2023-11-18', 'Deniz atlarının habitat tercihleri ve korunması.'),
(11, 'Dr. Zehra Yılmaz', 5, 7, '2023-12-10', 'Mercan resiflerindeki balık türlerinin popülasyon analizi.');

--
-- Tetikleyiciler `denizbiyolojisiarastirmalari`
--
DELIMITER $$
CREATE TRIGGER `guncelleme_denisbiyoarastirma` AFTER INSERT ON `denizbiyolojisiarastirmalari` FOR EACH ROW INSERT INTO gunelleme_denizbiyolojisiarastirmalari (arastirma_id, guncelleme_date)
VALUES (NEW.arastirma_id, NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `denizcanlilarifotograflari`
--

CREATE TABLE `denizcanlilarifotograflari` (
  `fotograf_id` int(11) NOT NULL,
  `organizma_id` int(11) DEFAULT NULL,
  `fotograf_url` varchar(255) DEFAULT NULL,
  `fotografci_adi` varchar(255) DEFAULT NULL,
  `cekim_tarihi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `denizcanlilarifotograflari`
--

INSERT INTO `denizcanlilarifotograflari` (`fotograf_id`, `organizma_id`, `fotograf_url`, `fotografci_adi`, `cekim_tarihi`) VALUES
(1, 1, 'https://images.pexels.com/photos/274054/pexels-photo-274054.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Seray Yılmaz', '2023-11-18'),
(2, 2, 'https://images.pexels.com/photos/1522162/pexels-photo-1522162.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Meryem Kaya', '2023-11-19'),
(3, 3, 'https://images.pexels.com/photos/302271/pexels-photo-302271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Berk Demir', '2023-11-20'),
(4, 1, 'https://images.pexels.com/photos/1894351/pexels-photo-1894351.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Sarp Yıldız', '2023-11-21'),
(5, 2, 'https://images.pexels.com/photos/3204595/pexels-photo-3204595.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Ekin Çelik', '2023-11-22'),
(6, 3, 'https://images.pexels.com/photos/4781925/pexels-photo-4781925.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Zeynep Arslan', '2023-11-23'),
(7, 1, 'https://images.pexels.com/photos/5560868/pexels-photo-5560868.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Seray Yılmaz', '2023-11-24'),
(8, 5, 'https://www.tfhmagazine.com/-/media/Project/OneWeb/TFH/US/articles/426_a_guide_to_fragging.jpg', 'Meryem Kaya', '2023-11-25'),
(9, 3, 'https://images.pexels.com/photos/4696771/pexels-photo-4696771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Berk Demir', '2023-11-26'),
(10, 4, 'https://images.pexels.com/photos/2698871/pexels-photo-2698871.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Sarp Yıldız', '2023-11-27'),
(11, 5, 'https://saltwatercoraltank.com/wp-content/uploads/2022/01/mushroom-discoma-coral-web.jpg', 'Mehmet Çelik', '2023-11-28'),
(12, 7, 'https://images.pexels.com/photos/4886378/pexels-photo-4886378.jpeg?auto=compress&cs=tinysrgb&w=600', 'Zeynep Arlan', '2023-11-29'),
(13, 4, 'https://images.pexels.com/photos/20790/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Ahmet Öz', '2023-11-30'),
(14, 8, 'https://images.pexels.com/photos/1618606/pexels-photo-1618606.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Ayşe Kaya', '2023-12-01'),
(15, 7, 'https://images.pexels.com/photos/64219/dolphin-marine-mammals-water-sea-64219.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Mustafa Demir', '2023-12-02'),
(16, 9, 'https://images.pexels.com/photos/8812640/pexels-photo-8812640.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Fatma Yıldız', '2023-12-03'),
(17, 9, 'https://images.pexels.com/photos/5967796/pexels-photo-5967796.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Mehmet Çelik', '2023-12-04'),
(18, 8, 'https://images.pexels.com/photos/3264721/pexels-photo-3264721.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Zeynep Arslan', '2023-12-05'),
(19, 10, 'https://images.pexels.com/photos/6123083/pexels-photo-6123083.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Ahmet Yılmaz', '2023-12-06'),
(20, 10, 'https://images.pexels.com/photos/8887695/pexels-photo-8887695.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Ayşe Kaya', '2023-12-07');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `denizcanlilarigozlemleri`
--

CREATE TABLE `denizcanlilarigozlemleri` (
  `gozlem_id` int(11) NOT NULL,
  `organizma_id` int(11) DEFAULT NULL,
  `gozlemci_adi` varchar(255) DEFAULT NULL,
  `gozlem_tarihi` date DEFAULT NULL,
  `konum` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `denizcanlilarigozlemleri`
--

INSERT INTO `denizcanlilarigozlemleri` (`gozlem_id`, `organizma_id`, `gozlemci_adi`, `gozlem_tarihi`, `konum`) VALUES
(1, 1, 'Ahmet Aydın', '2023-05-15', 'Ege Denizi, Dalış Bölgesi 1'),
(2, 3, 'Zeynep Çelik', '2023-06-20', 'Atlas Okyanusu, Gemi Üzerinden'),
(3, 5, 'Mustafa Yılmaz', '2023-04-02', 'Antarktika, Araştırma Gemisi'),
(4, 7, 'Ayşe Şahin', '2023-07-10', 'Karayip Denizi, Dalış Bölgesi 2'),
(5, 9, 'Kaan Demir', '2023-03-12', 'Ria Formosa, Gözlem Kulesi'),
(6, 2, 'Selin Kaya', '2023-08-05', 'Pasifik Okyanusu, Denizaltı Aracı'),
(7, 4, 'Emre Yücel', '2023-06-30', 'Hint Okyanusu, Dalış Bölgesi 3'),
(8, 6, 'Gizem Demirtaş', '2023-05-18', 'Akdeniz, Plaj Gözlemi'),
(9, 8, 'Levent Yaman', '2023-09-08', 'Kumsal, Kuşbakışı Gözlem'),
(10, 10, 'Melis Aksoy', '2023-07-25', 'Pasifik Okyanusu,  Dalış Bölgesi 4'),
(11, 1, 'deneme', '2023-01-02', 'deneme');

--
-- Tetikleyiciler `denizcanlilarigozlemleri`
--
DELIMITER $$
CREATE TRIGGER `delete_denizcanlilarigozlemleri` AFTER DELETE ON `denizcanlilarigozlemleri` FOR EACH ROW INSERT INTO silinme_denizcanlilarigozlemleri (gozlem_id, silinme_date)
    VALUES (OLD.gozlem_id, NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `denizhabitatlari`
--

CREATE TABLE `denizhabitatlari` (
  `habitat_id` int(11) NOT NULL,
  `habitat_adi` varchar(255) DEFAULT NULL,
  `konum` varchar(255) DEFAULT NULL,
  `ortalama_sicaklik` float DEFAULT NULL,
  `tuzluluk_seviyesi` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `denizhabitatlari`
--

INSERT INTO `denizhabitatlari` (`habitat_id`, `habitat_adi`, `konum`, `ortalama_sicaklik`, `tuzluluk_seviyesi`) VALUES
(0, 'Dr. Zeynep Demir', '', 0, 0),
(1, 'Sığ Deniz', 'Tropikal Bölge', 28.5, 35),
(2, 'Mercan Resifi', 'Pasifik Okyanusu', 25, 34),
(3, 'Açık Okyanus', 'Atlas Okyanusu', 15, 36),
(4, 'Açık Deniz', 'Hint Okyanusu', 20, 37),
(5, 'Derin Deniz', 'Antarktika', -2, 34.5),
(6, 'Deniz Kıyısı', 'Akdeniz', 22, 38),
(7, 'Kumsal', 'Karayip Denizi', 27, 35),
(8, 'Deniz Yosunu', 'Kuzey Denizi', 10, 33),
(9, 'Lagün', 'Ria Formosa', 23, 35.5),
(10, 'Mangrov Ormanı', 'Golf Adası', 28, 34),
(11, 'deniz', 'Dünya', 35, 12);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `denizkorumaalanlari`
--

CREATE TABLE `denizkorumaalanlari` (
  `korumaAlani_id` int(11) NOT NULL,
  `alan_adi` varchar(255) DEFAULT NULL,
  `konum` varchar(50) DEFAULT NULL,
  `korunan_turler` varchar(255) DEFAULT NULL,
  `yonetmelik` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `denizkorumaalanlari`
--

INSERT INTO `denizkorumaalanlari` (`korumaAlani_id`, `alan_adi`, `konum`, `korunan_turler`, `yonetmelik`) VALUES
(1, 'Gökova Koruma Alanı', 'Ege Denizi', 'Deniz Kaplumbağaları', 'Yüzmek Yasaktır.'),
(2, 'Great Barrier Reef Koruma Alanı', 'Pasifik Okyanusu', 'Mercan Resifleri', 'Dalış Kontrollüdür.'),
(3, 'Antarktika Deniz Alanı', 'Antarktika', 'Deniz Sälgini', 'Balık Avcılığı Yasaktır.'),
(4, 'Karayip Koruma Alanı', 'Karayip Denizi', 'Mercan Resifleri', 'Dalışa İzin Verilmez.'),
(5, 'Bosphorus Koruma Alanı', 'Marmara Denizi', 'Martı ve Kuğular', 'Yemleme Yasaktır.'),
(6, 'Hawaii Deniz Milli Parkı', 'Pasifik Okyanusu', 'Deniz Kaplumbağaları', 'Dalış Kontrollüdür.'),
(7, 'Amsterdam Adası Deniz Koruma Alanı', 'Hindistan Okyanusu', 'Su Aygırı', 'Balıkçılık Yasaktır.'),
(8, 'Galapagos Koruma Alanı', 'Pasifik Okyanusu', 'Kara İguana', 'Yüzmek Yasaktır.'),
(9, 'North Sea Deniz Alanı', 'Kuzey Denizi', 'Foklar', 'Petrol Çıkarma Yasaktır.'),
(10, 'Raja Ampat Deniz Koruma Alanı', 'Pasifik Okyanusu', 'Renkli Mercanlar', 'Dalış İzin Verilir.'),
(11, 'Mediterranean Koruma Alanı', 'Akdeniz ', 'Mercan Resifleri', 'Ticari Avlanma Yasak');

--
-- Tetikleyiciler `denizkorumaalanlari`
--
DELIMITER $$
CREATE TRIGGER `guncelleme_denizkorumaalanlari` AFTER INSERT ON `denizkorumaalanlari` FOR EACH ROW INSERT INTO guncelleme_denizkorumaalanlari (korumaAlani_id, guncelleme_date)
VALUES (NEW.korumaAlani_id, NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `denizorganizmalari`
--

CREATE TABLE `denizorganizmalari` (
  `organizma_id` int(11) NOT NULL,
  `organizma_name` varchar(255) DEFAULT NULL,
  `turler` varchar(255) DEFAULT NULL,
  `habitat_id` varchar(255) DEFAULT NULL,
  `derinlik_aralık` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `denizorganizmalari`
--

INSERT INTO `denizorganizmalari` (`organizma_id`, `organizma_name`, `turler`, `habitat_id`, `derinlik_aralık`) VALUES
(0, 'Deniz Anası', '', '', ''),
(1, 'Deniz Yıldızı', 'Asteroidea', 'Sığ Deniz', '0-50m'),
(2, 'Mercan', 'Anthozoa', 'Mercan Resifi', '0-30m'),
(3, 'Mavi Balina', 'Balaenoptera musculus', 'Açık Okyanus', '0-200m'),
(4, 'Deniz Anası', 'Scyphozoa', 'Açık Deniz', '0-100m'),
(5, 'Mantar Mercan', 'Fungiidae', 'Derin Deniz', '50-200m'),
(6, 'Deniz Kaplanı', 'Panthera leo persica', 'Deniz Kıyısı', '0-20m'),
(7, 'Yunus', 'Delphinidae', 'Açık Deniz', '0-100m'),
(8, 'Deniz Kaplumbağası', 'Cheloniidae', 'Kumsal', '0-10m'),
(9, 'Balina Köpekbalığı', 'Cetorhinus maximus', 'Derin Deniz', '100-500m'),
(10, 'Deniz Atı', 'Hippocampus', 'Deniz Yosunu', '0-5m');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `egitimprogramlari`
--

CREATE TABLE `egitimprogramlari` (
  `egitim_id` int(11) NOT NULL,
  `program_adi` varchar(255) DEFAULT NULL,
  `egitmen_adi` varchar(255) DEFAULT NULL,
  `baslangic_tarihi` date DEFAULT NULL,
  `bitis_tarihi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `egitimprogramlari`
--

INSERT INTO `egitimprogramlari` (`egitim_id`, `program_adi`, `egitmen_adi`, `baslangic_tarihi`, `bitis_tarihi`) VALUES
(1, 'Deniz Biyolojisi Temel Eğitimi', 'Prof. Elif Kaya', '2023-11-20', '2023-11-25'),
(2, 'Mercan Resifleri Keşfi', 'Dr. Murat Demir', '2023-05-27', '2023-06-01'),
(3, 'Deniz Kaplumbağaları ve Koruma', 'Prof. Selin Yılmaz', '2023-06-18', '2023-06-21'),
(4, 'Deniz Biyolojisi Laboratuvar Çalışmaları', 'Dr. Cem Yıldız', '2023-09-15', '2023-09-20'),
(5, 'Deniz Canlıları Gözlem Teknikleri', 'Prof. Yasemin Demirtaş', '2023-07-20', '2023-07-25'),
(6, 'Balina Gözlem ve Araştırma', 'Dr. Ahmet Aydın', '2023-08-25', '2023-08-30'),
(7, 'Deniz Biyolojisi ve Sualtı Fotoğrafçılığı', 'Prof. Nilüfer Aksoy', '2023-06-15', '2023-06-20'),
(8, 'Koruma ve Sürdürülebilirlik', 'Dr. Emre Yaman', '2023-09-05', '2023-09-10'),
(9, 'Deniz Biyolojisi ve Biyoteknoloji', 'Prof. Canan Yücel', '2023-07-30', '2023-08-05'),
(10, 'Deniz Ekosistemlerinde Çevresel Değişim', 'Dr. Levent Çalışkan', '2023-08-01', '2023-08-07');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `guncelleme_denizkorumaalanlari`
--

CREATE TABLE `guncelleme_denizkorumaalanlari` (
  `log_id` int(11) NOT NULL,
  `korumaAlani_id` int(11) DEFAULT NULL,
  `guncelleme_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `guncelleme_denizkorumaalanlari`
--

INSERT INTO `guncelleme_denizkorumaalanlari` (`log_id`, `korumaAlani_id`, `guncelleme_date`) VALUES
(0, 11, '2023-12-15 22:07:35');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `gunelleme_denizbiyolojisiarastirmalari`
--

CREATE TABLE `gunelleme_denizbiyolojisiarastirmalari` (
  `log_id` int(11) NOT NULL,
  `arastirma_id` int(11) DEFAULT NULL,
  `guncelleme_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `gunelleme_denizbiyolojisiarastirmalari`
--

INSERT INTO `gunelleme_denizbiyolojisiarastirmalari` (`log_id`, `arastirma_id`, `guncelleme_date`) VALUES
(0, 11, '2023-12-15 21:57:07');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `istatistikler`
--

CREATE TABLE `istatistikler` (
  `istatistik_id` int(11) NOT NULL,
  `arastirma_id` int(11) DEFAULT NULL,
  `ornek_buyuklugu` int(11) DEFAULT NULL,
  `ort_boyut` float DEFAULT NULL,
  `populasyon_yogunlugu` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `istatistikler`
--

INSERT INTO `istatistikler` (`istatistik_id`, `arastirma_id`, `ornek_buyuklugu`, `ort_boyut`, `populasyon_yogunlugu`) VALUES
(1, 1, 50, 10.5, 25.3),
(2, 2, 30, 8.7, 20.1),
(3, 3, 40, 12.2, 18.5),
(4, 1, 55, 11.1, 22),
(5, 2, 25, 9.5, 19.8),
(6, 3, 35, 10.8, 21.5),
(7, 1, 60, 11.8, 24.2),
(8, 2, 28, 8.5, 18.9),
(9, 3, 38, 12.5, 23.1),
(10, 1, 45, 10.2, 26);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `silinme_denizcanlilarigozlemleri`
--

CREATE TABLE `silinme_denizcanlilarigozlemleri` (
  `log_id` int(11) NOT NULL,
  `gozlem_id` int(11) DEFAULT NULL,
  `silinme_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `silinme_denizcanlilarigozlemleri`
--

INSERT INTO `silinme_denizcanlilarigozlemleri` (`log_id`, `gozlem_id`, `silinme_date`) VALUES
(0, 11, '2023-12-15 21:52:55');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `denizbiyolojisiarastirmalari`
--
ALTER TABLE `denizbiyolojisiarastirmalari`
  ADD PRIMARY KEY (`arastirma_id`),
  ADD KEY `organizma_id` (`organizma_id`),
  ADD KEY `fk_habitat` (`habitat_id`);

--
-- Tablo için indeksler `denizcanlilarifotograflari`
--
ALTER TABLE `denizcanlilarifotograflari`
  ADD PRIMARY KEY (`fotograf_id`),
  ADD KEY `organizma_id` (`organizma_id`);

--
-- Tablo için indeksler `denizcanlilarigozlemleri`
--
ALTER TABLE `denizcanlilarigozlemleri`
  ADD PRIMARY KEY (`gozlem_id`),
  ADD KEY `organizma_id` (`organizma_id`);

--
-- Tablo için indeksler `denizhabitatlari`
--
ALTER TABLE `denizhabitatlari`
  ADD PRIMARY KEY (`habitat_id`);

--
-- Tablo için indeksler `denizkorumaalanlari`
--
ALTER TABLE `denizkorumaalanlari`
  ADD PRIMARY KEY (`korumaAlani_id`);

--
-- Tablo için indeksler `denizorganizmalari`
--
ALTER TABLE `denizorganizmalari`
  ADD PRIMARY KEY (`organizma_id`);

--
-- Tablo için indeksler `egitimprogramlari`
--
ALTER TABLE `egitimprogramlari`
  ADD PRIMARY KEY (`egitim_id`);

--
-- Tablo için indeksler `guncelleme_denizkorumaalanlari`
--
ALTER TABLE `guncelleme_denizkorumaalanlari`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `korumaAlani_id` (`korumaAlani_id`);

--
-- Tablo için indeksler `gunelleme_denizbiyolojisiarastirmalari`
--
ALTER TABLE `gunelleme_denizbiyolojisiarastirmalari`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `arastirma_id` (`arastirma_id`);

--
-- Tablo için indeksler `istatistikler`
--
ALTER TABLE `istatistikler`
  ADD PRIMARY KEY (`istatistik_id`),
  ADD KEY `arastirma_id` (`arastirma_id`);

--
-- Tablo için indeksler `silinme_denizcanlilarigozlemleri`
--
ALTER TABLE `silinme_denizcanlilarigozlemleri`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `gozlem_id` (`gozlem_id`);

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `denizbiyolojisiarastirmalari`
--
ALTER TABLE `denizbiyolojisiarastirmalari`
  ADD CONSTRAINT `denizbiyolojisiarastirmalari_ibfk_1` FOREIGN KEY (`organizma_id`) REFERENCES `denizorganizmalari` (`organizma_id`),
  ADD CONSTRAINT `denizbiyolojisiarastirmalari_ibfk_2` FOREIGN KEY (`habitat_id`) REFERENCES `denizhabitatlari` (`habitat_id`),
  ADD CONSTRAINT `fk_habitat` FOREIGN KEY (`habitat_id`) REFERENCES `denizhabitatlari` (`habitat_id`);

--
-- Tablo kısıtlamaları `denizcanlilarifotograflari`
--
ALTER TABLE `denizcanlilarifotograflari`
  ADD CONSTRAINT `denizcanlilarifotograflari_ibfk_1` FOREIGN KEY (`organizma_id`) REFERENCES `denizorganizmalari` (`organizma_id`);

--
-- Tablo kısıtlamaları `denizcanlilarigozlemleri`
--
ALTER TABLE `denizcanlilarigozlemleri`
  ADD CONSTRAINT `denizcanlilarigozlemleri_ibfk_1` FOREIGN KEY (`organizma_id`) REFERENCES `denizorganizmalari` (`organizma_id`);

--
-- Tablo kısıtlamaları `guncelleme_denizkorumaalanlari`
--
ALTER TABLE `guncelleme_denizkorumaalanlari`
  ADD CONSTRAINT `guncelleme_denizkorumaalanlari_ibfk_1` FOREIGN KEY (`korumaAlani_id`) REFERENCES `denizkorumaalanlari` (`korumaAlani_id`);

--
-- Tablo kısıtlamaları `gunelleme_denizbiyolojisiarastirmalari`
--
ALTER TABLE `gunelleme_denizbiyolojisiarastirmalari`
  ADD CONSTRAINT `gunelleme_denizbiyolojisiarastirmalari_ibfk_1` FOREIGN KEY (`arastirma_id`) REFERENCES `denizbiyolojisiarastirmalari` (`arastirma_id`);

--
-- Tablo kısıtlamaları `istatistikler`
--
ALTER TABLE `istatistikler`
  ADD CONSTRAINT `istatistikler_ibfk_1` FOREIGN KEY (`arastirma_id`) REFERENCES `denizbiyolojisiarastirmalari` (`arastirma_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
