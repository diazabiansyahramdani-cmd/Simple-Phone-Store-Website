-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 24, 2026 at 04:37 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `product`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `customer_phone` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `total_amount`, `status`, `created_at`, `customer_email`, `customer_name`, `customer_phone`) VALUES
(1, 998.99, 'Pending', '2026-06-22 11:00:00', 'Diaz', NULL, NULL),
(2, 998.99, 'Pending', '2026-06-22 11:39:09', 'Admin1', NULL, NULL),
(3, 776.99, 'Pending', '2026-06-23 08:40:25', 'Diaz', NULL, NULL),
(4, 776.99, 'Pending', '2026-06-24 01:35:51', 'Diaz', NULL, NULL),
(5, 355.19, 'Pending', '2026-06-24 01:56:57', 'Diaz', '', ''),
(6, 355.19, 'Pending', '2026-06-24 01:57:12', 'Diaz', '', ''),
(7, 998.99, 'Pending', '2026-06-24 01:58:07', 'Diaz', '', ''),
(8, 33.29, 'Pending', '2026-06-24 02:00:52', 'Diaz', 'Diaz', '087781048726'),
(9, 332.99, 'Pending', '2026-06-24 02:03:26', 'Admin1', 'bkb', '8989'),
(10, 355.19, 'Pending', '2026-06-24 02:03:42', 'Admin1', 'tes', '08888');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price_at_purchase` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price_at_purchase`) VALUES
(1, 1, 3, 1, 899.99),
(2, 2, 3, 1, 899.99),
(3, 3, 1, 1, 699.99),
(4, 4, 1, 1, 699.99),
(5, 5, 7, 1, 319.99),
(6, 6, 7, 1, 319.99),
(7, 7, 3, 1, 899.99),
(8, 8, 9, 1, 29.99),
(9, 9, 4, 1, 299.99),
(10, 10, 7, 1, 319.99);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `image_url` text DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `stock`, `category`, `image_url`, `description`) VALUES
(1, 'Xiaomi 15 256GB', 699.99, 10, 'phone', 'https://cdn.kalvo.com/uploads/img/gallery/66531-xiaomi-15-3.jpg', 'The Xiaomi 15 brings premium build quality, a vivid display, and a long-lasting battery at a great price.'),
(2, 'Google Pixel 8a 128GB', 499.99, 5, 'phone', 'https://m.media-amazon.com/images/I/71JTIdBUvYL._AC_SL1500_.jpg', 'A clean Android experience with excellent camera software and strong performance for the price.'),
(3, 'iPhone 15 256GB', 899.99, 0, 'phone', 'https://cdnpro.eraspace.com/media/catalog/product/a/p/apple_iphone_15_plus_blue_1.jpg', 'Apple\'s flagship compact experience: a polished camera system and reliable iOS performance.'),
(4, 'Xiaomi Redmi Note 15 128GB', 299.99, 3, 'phone', 'https://cdn.etoren.com/upload/images/0.91327100_1755858432_xiaomi-redmi-note-15-5g-dual-sim-128gb-midnight-black-6gb-ram-china-version.jpg', 'A budget-friendly phone that still offers a bright display, solid battery life, and capable cameras.'),
(5, 'Samsung Galaxy S25 Ultra 1TB', 1099.99, 8, 'phone', 'https://carisinyal.com/wp-content/uploads/2025/01/Galaxy-S25-Ultra-titanium-silver-blue_.webp', 'A flagship powerhouse with a stunning screen, top-tier camera array, and premium glass design.'),
(6, 'Poco X8 Pro 512GB', 499.99, 2, 'phone', 'https://carisinyal.com/wp-content/uploads/2026/02/poco-x8-pro__1.webp', 'A strong midrange phone with fast charging, a bright display, and competitive performance.'),
(7, 'Meizu 21 256GB', 319.99, 5, 'phone', 'https://down-id.img.susercontent.com/file/id-11134207-7ras9-m61yjjybpt6u19', 'A stylish phone with a vibrant display, solid performance, and a unique design at an affordable price.'),
(8, 'Iphone 17 Pro Max 256GB', 1199.99, 2, 'phone', 'https://static.retailworldvn.com/Products/Images/12220/357955/smartphone-iphone-17-pro-max-1tb-cosmic-orange-thumb-3-600x600.jpg', 'The latest iPhone with a powerful A17 Pro chip, advanced camera system, and stunning Super Retina XDR display.'),
(9, 'Ugreen USB-C Fast Charger', 29.99, 14, 'charger', 'https://uk.ugreen.com/cdn/shop/products/ugreen-usb-c-to-usb-c-charger-cable-100w-usb-c-cable-fast-charging-data-sync-lead-with-e-marker-chip-565190.png?v=1692927424', 'A compact high-wattage charger built for laptops, phones, and tablets with fast USB-C power delivery.'),
(10, 'UGREEN Uno 3-Port Charger', 52.99, 10, 'charger', 'https://us.ugreen.com/cdn/shop/files/ugreen-uno-charger-65w-174341.png?v=1725455642&width=3840', 'A versatile 65W charger with 3 ports (2 USB-C + 1 USB-A) for charging multiple devices simultaneously.'),
(11, 'Apple Lightning Cable', 19.99, 20, 'charger', 'https://m.media-amazon.com/images/I/61FTrhdnqEL.jpg', 'A durable MFi-certified Lightning cable designed for fast charging and reliable data transfer.'),
(12, 'Ugreen Wireless Charger', 34.99, 8, 'charger', 'https://m.media-amazon.com/images/I/51UhPxFuR8L._AC_UF894,1000_QL80_.jpg', 'A sleek wireless charging pad that powers Qi-compatible devices with a stable charge every time.'),
(13, 'Samsung Charger Original', 7.99, 5, 'charger', 'https://cdn.topsellbelanja.com/wp-content/uploads/2022/09/samsung-type-c-super-fast-charger-45w-with-type-c-cable-1-m.jpg', 'A reliable 25W USB-C charger designed for Samsung phones and tablets with fast charging capabilities.'),
(14, 'AirPods Pro 3', 249.99, 6, 'audio', 'https://www.macpros.tech/images/AirPods-Pro/300/AirPods_Pro_3_Hero_Secondary_Screen__USEN.png', 'Premium wireless earbuds with active noise cancellation, spatial audio, and adaptive transparency.'),
(15, 'Sony WH-1000XM4', 348.00, 4, 'audio', 'https://www.sony.co.id/image/5d02da5df552836db894cead8a68f5f3?fmt=pjpeg&wid=330&bgcolor=FFFFFF&bgc=FFFFFF', 'A top-rated noise-cancelling headset with exceptional sound quality, comfort, and long battery life.'),
(16, 'JBL Flip 6', 129.99, 10, 'audio', 'https://images-cdn.ubuy.co.id/671bebb506bbc4159b0be649-jbl-flip-6-portable-waterproof-speaker.jpg', 'A rugged Bluetooth speaker with powerful JBL sound and full waterproof protection for outdoor use.'),
(17, 'HyperX Cloud III S', 249.99, 12, 'audio', 'https://row.hyperx.com/cdn/shop/files/hyperx_cloud_iii_s_wireless_white_ax6g1aa_main_1.jpg?v=1764893483', 'Comfortable gaming headphones with immersive audio, detachable mic, and long-lasting battery life.'),
(18, 'Razer Hammerhead Pro V2', 25.00, 9, 'audio', 'https://kkomputer.com/6662/razer-hammerhead-pro-v2-oem.jpg', 'Affordable earbuds with low-latency sound and a secure fit for music and gaming on the go.'),
(19, 'Moondrop Chu II', 19.99, 3, 'audio', 'https://cdn.prod.website-files.com/627128d862c9a44234848dda/64a67decb6354a3471c0d4cd_CHU2.jpg', 'Entry-level audiophile earbuds with balanced sound and comfortable fit for everyday listening.');

-- --------------------------------------------------------

--
-- Table structure for table `product_specs`
--

CREATE TABLE `product_specs` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `label` varchar(100) NOT NULL,
  `value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_specs`
--

INSERT INTO `product_specs` (`id`, `product_id`, `label`, `value`) VALUES
(1, 1, 'Display', '6.36-inch AMOLED, 120Hz'),
(2, 1, 'Processor', 'Snapdragon 8 Gen 3'),
(3, 1, 'Battery', '5100 mAh, 120W fast charging'),
(4, 1, 'Camera', '50MP main + 50MP ultrawide'),
(5, 2, 'Display', '6.1-inch OLED, 120Hz'),
(6, 2, 'Processor', 'Google Tensor G3'),
(7, 2, 'Battery', '4500 mAh, 18W charging'),
(8, 2, 'Camera', '64MP main + 13MP ultrawide'),
(9, 3, 'Display', '6.1-inch Super Retina XDR'),
(10, 3, 'Processor', 'A16 Bionic'),
(11, 3, 'Battery', '3349 mAh, MagSafe charging'),
(12, 3, 'Camera', '48MP main + 12MP ultrawide'),
(13, 4, 'Display', '6.77-inch AMOLED'),
(14, 4, 'Processor', 'Snapdragon 6 Gen 3'),
(15, 4, 'Battery', '5520 mAh, 45W charging'),
(16, 4, 'Camera', '108MP main + 8MP ultrawide'),
(17, 5, 'Display', '6.9-inch Dynamic AMOLED 2X, 120Hz'),
(18, 5, 'Processor', 'Snapdragon 8 Elite'),
(19, 5, 'Battery', '5000 mAh, 45W charging'),
(20, 5, 'Camera', '200MP main + 10MP telephoto + 50MP ultrawide + 50MP Periscope'),
(21, 6, 'Display', '6.59-inch AMOLED, 120Hz'),
(22, 6, 'Processor', 'Mediatek Dimensity 8500 Ultra'),
(23, 6, 'Battery', '6500 mAh, 100W charging'),
(24, 6, 'Camera', '50MP main + 8MP ultrawide'),
(25, 7, 'Display', '6.55-inch AMOLED, 120Hz'),
(26, 7, 'Processor', 'Snapdragon 8 Gen 3'),
(27, 7, 'Battery', '4800 mAh, 80W charging'),
(28, 7, 'Camera', '200MP main + 12MP ultrawide + 5MP wide'),
(29, 8, 'Display', '6.7-inch Super Retina XDR, 120Hz'),
(30, 8, 'Processor', 'A17 Pro'),
(31, 8, 'Battery', '4900 mAh, 20W charging'),
(32, 8, 'Camera', '48MP main + 48MP ultrawide + 48MP telephoto'),
(33, 9, 'Output', '100W USB-C PD'),
(34, 9, 'Ports', '1x USB-C'),
(35, 9, 'Compatibility', 'Laptops, phones, tablets'),
(36, 9, 'Safety', 'Overheat and surge protection'),
(37, 10, 'Total Output', '65W'),
(38, 10, 'Ports', '2x USB-C + 1x USB-A'),
(39, 10, 'Compatibility', 'Phones, tablets, laptops'),
(40, 10, 'Design', 'Compact with foldable plug'),
(41, 11, 'Length', '1m'),
(42, 11, 'Connector', 'Lightning to USB-C'),
(43, 11, 'Supports', 'Fast charge & sync'),
(44, 11, 'Compatibility', 'iPhone, iPad, AirPods'),
(45, 12, 'Wireless Output', '15W'),
(46, 12, 'Compatibility', 'Qi-enabled phones & earbuds'),
(47, 12, 'Design', 'Anti-slip pad with LED indicator'),
(48, 12, 'Safety', 'Temperature control'),
(49, 13, 'Output', '25W USB-C PD'),
(50, 13, 'Ports', '1x USB-C'),
(51, 13, 'Compatibility', 'Samsung phones & tablets'),
(52, 13, 'Design', 'Compact with foldable plug'),
(53, 14, 'Noise Cancellation', 'Active ANC'),
(54, 14, 'Battery', 'Up to 6 hours listening'),
(55, 14, 'Charging', 'MagSafe / wireless / Lightning'),
(56, 14, 'Connectivity', 'Bluetooth 5.3'),
(57, 15, 'Noise Cancellation', 'Industry-leading ANC'),
(58, 15, 'Battery', 'Up to 30 hours'),
(59, 15, 'Connectivity', 'Bluetooth 5.2'),
(60, 15, 'Features', 'Speak-to-chat, touch controls'),
(61, 16, 'Output', '20W'),
(62, 16, 'Battery', 'Up to 12 hours'),
(63, 16, 'Durability', 'IP67 waterproof'),
(64, 16, 'Connectivity', 'Bluetooth 5.3'),
(65, 17, 'Audio', 'HyperX 50mm drivers'),
(66, 17, 'Battery', 'Up to 35 hours'),
(67, 17, 'Microphone', 'Detachable noise-cancelling mic'),
(68, 17, 'Connectivity', 'Wireless + wired'),
(69, 18, 'Driver', '10mm dynamic drivers'),
(70, 18, 'Connection', 'USB-C'),
(71, 18, 'Design', 'In-ear with cable management'),
(72, 18, 'Extras', 'Built-in mic'),
(73, 19, 'Driver', '10mm dynamic driver'),
(74, 19, 'Frequency', '20Hz - 20kHz'),
(75, 19, 'Cable', 'Detachable braided cable'),
(76, 19, 'Comfort', 'Silicone ear tips');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` varchar(20) DEFAULT 'customer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `created_at`, `role`) VALUES
(2, 'Admin1', '$2y$10$zVcvV26gNWH1yU05ljIlueon7shq/JOVBU6uvUkrqChKZgt6TiOYO', '2026-06-22 09:34:51', 'admin'),
(3, 'Diaz', '$2y$10$W.wdjRFUpjWO4bgygUQDweVMesIj8oIgleYTUpsqJmORp1FI9eGgW', '2026-06-22 09:46:56', 'customer'),
(4, 'Test', '$2y$10$fYkuxYSDvh3UGz0u8jgo.uQzSkCz/6qVoA/G/StBzuV12CRH4UHiO', '2026-06-22 10:43:02', 'customer');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_specs`
--
ALTER TABLE `product_specs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `product_specs`
--
ALTER TABLE `product_specs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `product_specs`
--
ALTER TABLE `product_specs`
  ADD CONSTRAINT `product_specs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
