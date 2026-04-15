-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 15, 2026 at 06:01 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `college_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `status` enum('Present','Absent') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `subject_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `student_id`, `date`, `status`, `created_at`, `subject_id`) VALUES
(1, 12, '0222-11-11', 'Absent', '2026-04-06 09:14:31', 201),
(2, 111, '2022-11-11', 'Present', '2026-04-06 16:06:43', NULL),
(3, 111, '2200-11-11', 'Absent', '2026-04-06 16:07:15', NULL),
(4, 7, '2022-11-12', 'Present', '2026-04-07 17:19:04', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `chatbot`
--

CREATE TABLE `chatbot` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `duration` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chatbot`
--

INSERT INTO `chatbot` (`id`, `question`, `answer`, `duration`) VALUES
(1, 'admission', 'Admission process is open from Baisakh.', 0),
(2, 'fee', 'Fee structure depends on the course.', 0),
(3, 'bca', 'BCA is a 4 year program.', 0);

-- --------------------------------------------------------

--
-- Table structure for table `chat_history`
--

CREATE TABLE `chat_history` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `user_message` text DEFAULT NULL,
  `bot_reply` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chat_history`
--

INSERT INTO `chat_history` (`id`, `username`, `user_message`, `bot_reply`, `created_at`) VALUES
(48, 'admin', 'hi', 'Hello 👋 How can I help you today?', '2026-02-25 12:46:08'),
(49, 'admin', 'college information', 'Yes, the college is secure and monitored regularly.', '2026-02-25 12:46:25'),
(50, 'admin', 'college location', 'Hello 👋 How can I help you today?', '2026-04-09 09:39:00'),
(51, 'admin', 'results', '📄 Your Results:\nmath = 90 (A)\nmath = 66 (B)\n', '2026-04-09 09:41:18'),
(52, 'admin', 'location', '📄 Your Results:\nmath = 90 (A)\nmath = 66 (B)\n', '2026-04-09 09:41:27'),
(53, 'admin', 'college information', '📄 Your Results:\nmath = 90 (A)\nmath = 66 (B)\n', '2026-04-09 09:41:46'),
(54, 'admin', 'hii', '📄 Your Results:\nmath = 90 (A)\nmath = 66 (B)\n', '2026-04-09 09:41:56'),
(55, 'admin', 'hi', 'Hello 👋 How can I help you today?', '2026-04-09 09:42:02'),
(56, 'admin', 'hi', 'Hello 👋 How can I help you today?', '2026-04-09 09:49:27'),
(57, 'admin', 'hi what couse do you offere', 'Hello 👋 How can I help you today?', '2026-04-09 09:50:11'),
(58, 'admin', 'hi what couse do you offere', 'Hello 👋 How can I help you today?', '2026-04-09 09:53:20'),
(59, 'admin', 'hi what course do you offered', 'Courses: BSc CSIT, BCA, BIM, BBM', '2026-04-09 09:53:36'),
(60, 'admin', 'college information', 'Courses: BSc CSIT, BCA, BIM, BBM', '2026-04-09 09:53:50'),
(61, 'admin', 'about college', 'Courses: BSc CSIT, BCA, BIM, BBM', '2026-04-09 09:54:02'),
(62, 'admin', 'about college', 'Courses: BSc CSIT, BCA, BIM, BBM', '2026-04-09 10:02:42'),
(63, 'admin', 'about college information', 'Courses: BSc CSIT, BCA, BIM, BBM', '2026-04-09 10:02:58'),
(64, 'admin', 'hi', 'Hello 👋 How can I help you today?', '2026-04-09 10:03:04'),
(65, 'admin', 'what are the fees', 'Undergraduate fee: Rs. 80,000/year', '2026-04-09 10:03:25'),
(66, 'admin', 'Does the university organize educational tours for.', 'Undergraduate fee: Rs. 80,000/year', '2026-04-09 10:04:28'),
(67, 'admin', 'i need a hostel', 'Undergraduate fee: Rs. 80,000/year', '2026-04-09 10:04:57'),
(68, 'admin', 'Does the university organize sports week', 'Undergraduate fee: Rs. 80,000/year', '2026-04-09 10:10:34'),
(69, 'admin', 'Does the university organize sports week', 'Undergraduate fee: Rs. 80,000/year', '2026-04-09 10:12:18'),
(70, 'admin', 'Does the university organize sports week', 'Undergraduate fee: Rs. 80,000/year', '2026-04-09 10:13:01'),
(71, 'admin', 'admission', '📝 Admission is open. Apply online or visit college.', '2026-04-09 17:58:48'),
(72, 'admin', 'contact', '📞 Contact: 091-123456', '2026-04-09 18:02:09'),
(73, 'admin', 'Is Wi-Fi available on campus?', '🤖 Sorry, I didn’t understand. Ask about courses, fees, admission, or notices.', '2026-04-09 18:03:13'),
(74, 'admin', 'Is Wi-Fi available on campus?', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-09 18:07:45'),
(75, 'admin', 'When was the Computer Engineering program started?', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-09 18:08:16'),
(76, 'admin', 'admission', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-09 18:08:36'),
(77, 'admin', 'hello', 'Hello 👋 How can I help you today?', '2026-04-09 18:08:45'),
(78, 'admin', 'fee', 'Undergraduate fee: Rs. 80,000 per year. Postgraduate fee: Rs. 120,000 per year.', '2026-04-09 18:08:53'),
(79, 'admin', 'course', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-09 18:09:08'),
(80, 'admin', 'result', 'Exam results are published on the official website.', '2026-04-09 18:12:10'),
(81, 'admin', '12345678*-/--', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-10 05:17:18'),
(82, 'admin', '12345678*-/--', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-10 05:17:18'),
(83, 'admin', 'how are you', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-10 05:18:13'),
(84, 'admin', 'hostile facility', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-10 05:18:28'),
(85, 'admin', 'seats for civil', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-10 05:18:59'),
(86, 'admin', 'hi', 'Hello 👋 How can I help you today?', '2026-04-12 10:31:18'),
(87, 'admin', 'hello', 'Hello 👋 How can I help you today?', '2026-04-12 10:31:24'),
(88, 'admin', 'good morning', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 10:31:32'),
(89, 'admin', 'What is the admission fee?', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-12 10:31:52'),
(90, 'admin', 'What is the price of college?', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 10:32:23'),
(91, 'admin', 'How much does it cost to study?', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 10:32:51'),
(92, 'admin', 'How much does it cost to study?', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 10:45:10'),
(93, 'admin', 'How much does it cost to study?', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 10:45:21'),
(94, 'admin', 'What type of quota system are available in the university?', 'Inclusive quota system and district quota system are available.', '2026-04-12 10:47:05'),
(95, 'admin', 'location', 'You can find Mahendranagar, Kanchanpur.', '2026-04-12 10:47:37'),
(96, 'admin', 'What sports are available in college?', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 10:57:23'),
(97, 'admin', 'Are indoor games available for students?', 'Yes, indoor games are available for students.', '2026-04-12 10:58:03'),
(98, 'admin', 'What sports are available in college?', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 11:10:34'),
(99, 'admin', 'good morning', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 11:13:17'),
(100, 'admin', 'location', 'You can find Mahendranagar, Kanchanpur.', '2026-04-12 11:13:27'),
(101, 'admin', 'What is the duration of the Civil Engineering program?', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:13:51'),
(102, 'admin', 'course', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:14:00'),
(103, 'admin', 'Are CCTV cameras installed?', 'Yes, CCTV cameras are installed in key areas.', '2026-04-12 11:15:34'),
(104, 'admin', 'admission', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-12 11:15:45'),
(105, 'admin', 'how to apply admission', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-12 11:16:00'),
(106, 'admin', 'Does the university provide career opportunities after graduation?', 'I think you are asking about:\n👉 Yes, placement support is provided.', '2026-04-12 11:16:43'),
(107, 'admin', 'Does the university provide career opportunities after graduation?', 'I think you are asking about:\n👉 Yes, placement support is provided.', '2026-04-12 11:26:16'),
(108, 'admin', 'about college', 'I think you are asking about:\n👉 Yes, it is a well-reputed institution.', '2026-04-12 11:26:37'),
(109, 'admin', 'hey', 'Hello 👋 How can I help you today?', '2026-04-12 11:27:12'),
(110, 'admin', 'location', 'You can find Mahendranagar, Kanchanpur.', '2026-04-12 11:27:26'),
(111, 'admin', 'Is hostel safe', 'Yes, hostel is secure and monitored.', '2026-04-12 11:31:42'),
(112, 'admin', 'tell the students details', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 11:32:04'),
(113, 'admin', 'Are on-campus bootcamps organized for skill enhancement?', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-12 11:32:37'),
(114, 'admin', 'Are on-campus bootcamps organized for skill enhancement?', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-12 11:36:27'),
(115, 'admin', 'Are on-campus bootcamps organized for skill enhancement?', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-12 11:36:40'),
(116, 'admin', 'Are on-campus bootcamps organized for skill enhancement?', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-12 11:37:04'),
(117, 'admin', 'Are on-campus bootcamps organized for skill enhancement?', 'Campus facilities include library, computer labs, sports complex, hostel, and free Wi-Fi.', '2026-04-12 11:40:44'),
(118, 'admin', 'Does the Grade C requirement apply to extra or optional courses?', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:41:33'),
(119, 'admin', 'Are students encouraged to collaborate with other universities', 'Yes, collaboration is promoted.', '2026-04-12 11:45:14'),
(120, 'admin', 'Does the Grade C requirement apply to extra or optional courses', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:45:34'),
(121, 'admin', 'Does the Grade C requirement apply to extra or optional courses', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:53:20'),
(122, 'admin', 'Does the Grade C requirement apply to extra or optional courses', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:53:29'),
(123, 'admin', 'What is the exam format for engineering courses?', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 11:54:07'),
(124, 'admin', 'Are students encouraged to collaborate with other universities', 'Yes, collaboration is promoted.', '2026-04-12 11:54:32'),
(125, 'admin', 'Are students encouraged to collaborate with other universities', 'Yes, collaboration is promoted.', '2026-04-12 12:05:46'),
(126, 'admin', 'What is the exam format for engineering courses?', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-12 12:06:00'),
(127, 'admin', 'Are career counseling services available?', 'Yes, career counseling sessions are organized.', '2026-04-12 12:06:36'),
(128, 'admin', 'carrier', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-12 12:06:46'),
(129, 'admin', 'Facilities Is library available', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-13 09:53:45'),
(130, 'admin', 'Are labs available', 'Yes, laboratories and workshops are well equipped.', '2026-04-13 09:54:27'),
(131, 'admin', 'Is library available', 'Yes, the library is well equipped with books and digital resources.', '2026-04-13 09:54:38'),
(132, 'admin', 'Are medical facilities available', 'Yes, medical facilities are available on campus.', '2026-04-13 09:55:06'),
(133, 'admin', 'Does the university organize sports week', 'Yes, annual sports week is organized to encourage physical activities.', '2026-04-13 09:55:31'),
(134, 'admin', 'sport week', 'Yes, annual sports week is organized to encourage physical activities.', '2026-04-13 09:56:05'),
(135, 'admin', 'admission', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-13 09:56:20'),
(136, 'admin', 'admission', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-13 10:24:42'),
(137, 'admin', 'course details', 'We offer undergraduate programs in Computer Science, Business, and Arts, as well as postgraduate programs in Science and Management.', '2026-04-13 10:25:00'),
(138, 'admin', 'contact', 'You can contact us at 0000000000.', '2026-04-13 10:25:18'),
(139, 'admin', 'result is at timely', 'Exam results are published on the official website.', '2026-04-13 10:25:34'),
(140, 'admin', 'hello', 'Hello 👋 How can I help you today?', '2026-04-14 17:09:12'),
(141, 'admin', 'hlo', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-14 17:09:16'),
(142, 'admin', 'hlo', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-14 17:09:38'),
(143, 'admin', 'hlo', '🤖 Sorry, I couldn\'t understand.', '2026-04-14 17:31:29'),
(144, 'admin', 'hey', 'Hello 👋 How can I help you today?', '2026-04-14 17:31:39'),
(145, 'admin', 'hello', 'Hello 👋 How can I help you today?', '2026-04-14 17:31:46'),
(146, 'admin', 'good morning', '🤖 Sorry, I couldn\'t understand.', '2026-04-14 17:31:54'),
(147, 'admin', 'fee structures', 'Fee is approximately Rs. 80,000 per year.', '2026-04-14 17:32:39'),
(148, 'admin', 'college details', '👉 It is located in Mahendranagar, Kanchanpur.', '2026-04-14 17:32:50'),
(149, 'admin', 'course information', 'We offer BSc CSIT, BCA, BIM, BBM.', '2026-04-14 17:33:08'),
(150, 'admin', 'Does the Grade C requirement apply to extra or optional courses', 'We offer BSc CSIT, BCA, BIM, BBM.', '2026-04-14 17:33:45'),
(151, 'admin', 'How is coordination between students and teachers?', 'Teachers maintain regular interaction and guidance sessions.', '2026-04-14 17:34:09'),
(152, 'admin', 'How is coordination between students and teachers?', 'Our faculty members are highly qualified with Master\'s and PhD degrees.', '2026-04-14 17:48:44'),
(153, 'admin', 'tell me something unknown', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-14 17:48:49'),
(154, 'admin', '!!! ??? ###', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-14 17:49:13'),
(155, 'admin', 'csit', NULL, '2026-04-14 17:49:42'),
(156, 'admin', 'csit fee', NULL, '2026-04-14 17:49:58'),
(157, 'admin', 'fee', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 17:50:19'),
(158, 'admin', 'hey can you tell me fee and also scholarship info please', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 17:50:42'),
(159, 'admin', 'hello i want admission details and contact number', 'You can contact us at 0000000000.', '2026-04-14 17:51:06'),
(160, 'admin', 'attendance requirement for exams?', 'Minimum 75% attendance is required for exams.', '2026-04-14 17:51:26'),
(161, 'admin', 'what is fee and admission process?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 17:51:51'),
(162, 'admin', 'what is fee and admission process?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 17:56:18'),
(163, 'admin', 'what is fee and admission process?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 17:56:33'),
(164, 'admin', 'what is fee and admission and scholarship?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 17:56:56'),
(165, 'admin', 'what is fee and admission and scholarship?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 18:00:22'),
(166, 'admin', 'what is fee and admission process?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 18:00:42'),
(167, 'admin', 'what is fee and admission and scholarship?', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 18:00:59'),
(168, 'admin', 'fee and admission', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 18:03:24'),
(169, 'admin', 'fee', 'CSIT fee is approximately Rs. 80,000 per year.', '2026-04-14 18:03:36'),
(170, 'admin', 'helo', 'Sorry, I couldn\'t find an answer. Please ask about admission, programs, eligibility, fees, facilities, or scholarship.', '2026-04-14 18:03:46'),
(171, 'admin', 'hey', 'Hello 👋 How can I help you today?', '2026-04-14 18:03:53'),
(172, 'admin', 'location', 'You can find Mahendranagar, Kanchanpur.', '2026-04-14 18:04:02'),
(173, 'admin', 'tell me about college', '👉 Yes, it is nationally recognized.', '2026-04-14 18:10:06'),
(174, 'admin', 'tell me about college', 'Did you mean:\n👉 Yes, it is nationally recognized.', '2026-04-14 18:15:52'),
(175, 'admin', 'tell me about college', 'Did you mean:\n👉 Yes, it is nationally recognized.', '2026-04-14 18:16:05'),
(176, 'admin', 'hello', 'Hello 👋 How can I help you today?', '2026-04-15 04:56:22'),
(177, 'admin', 'new admission dateline', 'Admissions are open from June to August. Apply online or visit the admission office.', '2026-04-15 04:56:40');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `course_name` varchar(100) DEFAULT NULL,
  `fees` int(11) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `course_name`, `fees`, `duration`) VALUES
(1, 'Computer Science', 50000, '4 Years'),
(2, 'Business', 40000, '3 Years');

-- --------------------------------------------------------

--
-- Table structure for table `coursess`
--

CREATE TABLE `coursess` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `semesters` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coursess`
--

INSERT INTO `coursess` (`id`, `name`, `duration`, `semesters`) VALUES
(1, 'krishna', '4 year', 6),
(2, 'BSc CSIT', '4 Years', 8),
(3, 'BCA', '4 Years', 8),
(4, 'BIM', '4 Years', 8),
(5, 'BBM', '4 Years', 8);

-- --------------------------------------------------------

--
-- Table structure for table `enquiries`
--

CREATE TABLE `enquiries` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `course` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enquiries`
--

INSERT INTO `enquiries` (`id`, `name`, `email`, `phone`, `course`, `message`, `created_at`) VALUES
(7, 'Krishna kadayat', 'krishnakadayat0109@gmail.com', '34567890', 'BIM', 'kkkk', '2026-01-22 12:04:23'),
(8, 'Krishna kadayat', 'krishnakadayat0109@gmail.com', '23456789', 'BIM', 'dfghjkl', '2026-01-22 12:04:42'),
(9, 'Krishna kadayat', 'krishnakadayat0109@gmail.com', '23456789', 'BIM', 'kjkjkkk', '2026-01-22 12:05:15'),
(10, 'Krishna kadayat', 'krishnakadayat0109@gmail.com', '23456789', 'BIM', '999', '2026-01-22 12:05:45'),
(11, 'Krishna kadayat', 'krishnakadayat0109@gmail.com', '23456789', 'BIM', 'fgghjhj', '2026-01-22 12:16:38'),
(12, 'Krishna kadayat', 'krishnakadayat0109@gmail.com', '23456789', 'CSIT', 'ttttttt', '2026-02-09 06:27:37');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `name`, `email`, `message`, `created_at`) VALUES
(1, 'krishna', 'krishnakadayat0109@gmail.com', 'nothing just check !', '2026-01-21 10:48:25');

-- --------------------------------------------------------

--
-- Table structure for table `fees`
--

CREATE TABLE `fees` (
  `id` int(11) NOT NULL,
  `roll_no` varchar(20) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `course` varchar(50) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fees`
--

INSERT INTO `fees` (`id`, `roll_no`, `name`, `course`, `semester`, `amount`, `status`) VALUES
(1, '1', 'Krishna kadayat', 'BCA', '6th', 50000.00, 'Paid'),
(2, '111', 'sital kadayt', 'BSc CSIT', '1st', 1000000.00, 'Paid');

-- --------------------------------------------------------

--
-- Table structure for table `notices`
--

CREATE TABLE `notices` (
  `id` int(11) NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `priority` enum('Normal','Important','Urgent') DEFAULT 'Normal',
  `status` enum('draft','published') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notices`
--

INSERT INTO `notices` (`id`, `title`, `message`, `category`, `priority`, `status`, `created_at`) VALUES
(1, 'addmission open', 'twertyuioxghjk\r\ngafhsdfdaskjg\r\nafnakdgakskg\r\njajgadj', 'Admission', 'Important', 'published', '2026-02-06 11:43:14'),
(2, 'vacation', 'something is wrong', 'Holiday', 'Urgent', 'published', '2026-02-07 15:34:23'),
(3, 'code program starts', '2082/11/22', 'General', 'Normal', 'draft', '2026-02-16 13:12:56'),
(4, 'on the college dress', 'all the students are attendance in our college dress for everyday without coming any punishment are given', 'General', 'Normal', 'published', '2026-04-06 08:27:14');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`id`, `user_id`, `token`, `expires_at`, `used`) VALUES
(1, 21, '8Wh5tPXT6IHRdjxgbLkMR5AvAg--zauKL6Ffkd81NAE', '2026-02-25 14:25:23', 0),
(2, 21, 'IiJC4mNL8boU9rtoNu5Ojmhgx69_5k_75PLRrCG8xho', '2026-02-25 14:29:52', 0),
(3, 21, '6HhJIBiTGRUeKhB9TqShpCzPXf61YmX-UArXmgg6xWE', '2026-02-25 14:41:44', 0),
(4, 21, 'ik-zAJTfLqR2nMvSVc7-1vRaSshcVXj1Dh6owh5_OQQ', '2026-02-25 14:42:05', 0);

-- --------------------------------------------------------

--
-- Table structure for table `qa_table`
--

CREATE TABLE `qa_table` (
  `id` int(11) NOT NULL,
  `topic` varchar(255) NOT NULL,
  `question` text DEFAULT NULL,
  `answer` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qa_table`
--

INSERT INTO `qa_table` (`id`, `topic`, `question`, `answer`) VALUES
(151, 'Tours', 'Does the university organize educational tours for engineering students?', 'Yes, student course-wise educational tours are arranged for engineering students.'),
(152, 'Tours', 'Are engineering students taken on field visits?', 'Yes, student course-wise educational tours are arranged for engineering students.'),
(153, 'Tours', 'Do students go for industrial visits?', 'Yes, student course-wise educational tours are arranged for engineering students.'),
(154, 'Tours', 'Are study tours included in engineering program?', 'Yes, student course-wise educational tours are arranged for engineering students.'),
(155, 'Tours', 'Is field learning part of engineering program?', 'Yes, student course-wise educational tours are arranged for engineering students.'),
(156, 'Sports', 'Does the university organize sports week?', 'Yes, annual sports week is organized to encourage physical activities.'),
(157, 'Sports', 'Is sports week held every year?', 'Yes, annual sports week is organized to encourage physical activities.'),
(158, 'Sports', 'Are sports events conducted in college?', 'Yes, annual sports week is organized to encourage physical activities.'),
(159, 'Sports', 'Do students participate in sports events?', 'Yes, annual sports week is organized to encourage physical activities.'),
(160, 'Sports', 'Is there a sports festival in university?', 'Yes, annual sports week is organized to encourage physical activities.'),
(161, 'Programs', 'When was civil engineering started?', 'The civil engineering program was started in 2077 BS.'),
(162, 'Programs', 'When was computer engineering started?', 'The Computer Engineering program was started in 2079 BS.'),
(163, 'Programs', 'When was architecture engineering started?', 'The Architecture Engineering program was started in 2081 BS.'),
(164, 'Programs', 'What is duration of engineering courses?', 'It is a four-year program consisting of eight semesters.'),
(165, 'Programs', 'Which engineering programs are available?', 'Computer, Civil, and Architecture Engineering programs are offered.'),
(166, 'Admission', 'How many seats are available?', 'There are 48 seats for each engineering program.'),
(167, 'Admission', 'Can I apply online?', 'Yes, students can apply through the online application system.'),
(168, 'Admission', 'What is admission process?', 'You can apply online or visit admission office.'),
(169, 'Admission', 'Is entrance exam required?', 'Yes, entrance exam is required for engineering programs.'),
(170, 'Admission', 'When is admission open?', 'Admissions are open from June to August.'),
(171, 'Facilities', 'Is Wi-Fi available?', 'Yes, Wi-Fi is available for students and staff across the college.'),
(172, 'Facilities', 'Is library available?', 'Yes, the library is well equipped with books and digital resources.'),
(173, 'Facilities', 'Are labs available?', 'Yes, laboratories and workshops are well equipped.'),
(174, 'Facilities', 'Is hostel available?', 'Yes, hostel facilities are available near the college.'),
(175, 'Facilities', 'Are medical facilities available?', 'Yes, medical facilities are available on campus.'),
(176, 'Scholarship', 'Does university provide scholarship?', 'Yes, the university provides merit-based and quota-based scholarships.'),
(177, 'Scholarship', 'Are scholarships available?', 'Yes, scholarships are available for students.'),
(178, 'Scholarship', 'Who can apply for scholarship?', 'Students with good academic performance or quota eligibility can apply.'),
(179, 'Scholarship', 'What types of scholarships exist?', 'Merit-based and quota-based scholarships are available.'),
(180, 'Scholarship', 'How to apply for scholarship?', 'Apply through scholarship office during admission.'),
(181, 'Eligibility', 'What is eligibility for engineering?', 'Students must have passed Class 12 or equivalent.'),
(182, 'Eligibility', 'Is PCM required?', 'Yes, Physics, Chemistry, and Mathematics are required.'),
(183, 'Eligibility', 'Is math compulsory?', 'Yes, mathematics is compulsory.'),
(184, 'Eligibility', 'What grade is required?', 'Minimum grade C is required in PCM subjects.'),
(185, 'Eligibility', 'What percentage is required?', 'At least 45% or CGPA 2.0 is required.'),
(186, 'Security', 'Is campus safe?', 'Yes, the campus is fully secure and monitored regularly.'),
(187, 'Security', 'Are CCTV cameras installed?', 'Yes, CCTV cameras are installed in key areas.'),
(188, 'Security', 'Are guards available?', 'Yes, security guards are available 24/7.'),
(189, 'Security', 'Is hostel safe?', 'Yes, hostel is secure and monitored.'),
(190, 'Security', 'Is student safety ensured?', 'Yes, campus security is strong.'),
(191, 'Career', 'Does college provide job placement?', 'Yes, placement support is provided.'),
(192, 'Career', 'Are internships available?', 'Yes, internship opportunities are available.'),
(193, 'Career', 'Do companies visit college?', 'Yes, companies visit for recruitment.'),
(194, 'Career', 'Is career counseling provided?', 'Yes, career counseling sessions are organized.'),
(195, 'Career', 'Are job opportunities available?', 'Yes, career opportunities are provided.'),
(196, 'General', 'Where is college located?', 'It is located in Mahendranagar, Kanchanpur.'),
(197, 'General', 'Are teachers experienced?', 'Yes, teachers are highly qualified and experienced.'),
(198, 'General', 'Is online class available?', 'Yes, online learning support is available.'),
(199, 'General', 'Do students join events?', 'Yes, students are encouraged to participate in events.'),
(200, 'General', 'Is college recognized?', 'Yes, it is nationally recognized.'),
(201, 'Tours', 'Does the university organize educational tours for engineering students?', 'Yes, student course-wise educational tours are arranged for engineering students.'),
(202, 'Tours', 'Are tours different for computer, civil, and architecture engineering?', 'Yes, tours are different for each engineering program.'),
(203, 'Tours', 'Are students guided during educational tours?', 'Yes, faculty members guide students during tours and explain practical concepts.'),
(204, 'Sports', 'Does the university organize sports week?', 'Yes, annual sports week is organized to encourage physical activities.'),
(205, 'Programs', 'When was the civil engineering program started?', 'The civil engineering program was started in 2077 BS.'),
(206, 'Programs', 'When was the Computer Engineering program started?', 'The Computer Engineering program was started in 2079 BS.'),
(207, 'Programs', 'When was the Architecture Engineering program started?', 'The Architecture Engineering program was started in 2081 BS.'),
(208, 'Admission', 'How many seats are available in Civil, Computer, and Architecture Engineering?', 'There are 48 seats for each engineering program.'),
(209, 'Facilities', 'Is Wi-Fi available on campus?', 'Yes, Wi-Fi is available for students and staff across the college.'),
(210, 'Scholarship', 'Does the university provide scholarships?', 'Yes, the university provides merit-based and quota-based scholarships.'),
(211, 'Scholarship', 'What type of quota system are available in the university?', 'Inclusive quota system and district quota system are available.'),
(212, 'Scholarship', 'Which groups are included in the Inclusive quota system?', 'Women, Madhesi, Dalit, Adivasi Janjati, Disabled, and students from backward regions are included.'),
(213, 'Sports', 'What sports activities are included in the university?', 'Volleyball, cricket, football, badminton, table tennis, chess, races, and long jump are offered.'),
(214, 'Sports', 'Does the university organize a Sports Week?', 'Yes, an annual Sports Week is organized with various competitive events.'),
(215, 'Sports', 'Are indoor games available for students?', 'Yes, indoor games are available for students.'),
(216, 'Admission', 'How many students are available under full-pay and partial-pay schemes?', 'There are 24 seats under full-pay and 24 seats under partial-pay schemes.'),
(217, 'Admission', 'Can I apply for admission online?', 'Yes, students can apply through the online application system.'),
(218, 'Programs', 'What is the duration of the Computer Engineering program?', 'It is a four-year program consisting of eight semesters.'),
(219, 'Programs', 'What is the duration of the Civil Engineering program?', 'It is a four-year program consisting of eight semesters.'),
(220, 'Programs', 'What is the duration of the Architecture Engineering program?', 'It is a five-year program consisting of ten semesters.'),
(221, 'Eligibility', 'What is the basic eligibility for admission to engineering programs?', 'Students must have passed Class 12 examination of NEB or equivalent.'),
(222, 'Eligibility', 'Which subjects must be studied in Class 12 for engineering admission?', 'Physics, Chemistry, and Mathematics (PCM) must be studied.'),
(223, 'Eligibility', 'What is the minimum percentage or CGPA required for admission?', 'At least 45% overall or a CGPA of 2.0 is required.'),
(224, 'Eligibility', 'What is the minimum grade required in PCM subjects?', 'A minimum grade C in each subject is required.'),
(225, 'Security', 'Are CCTV cameras installed on the campus?', 'Yes, CCTV cameras are installed in key areas for safety and security.'),
(226, 'Eligibility', 'Is mathematics compulsory for engineering admission?', 'Yes, mathematics is compulsory.'),
(227, 'Achievements', 'Has the engineering faculty received any recognition or achievements?', 'Yes, faculty and students have received awards and recognition.'),
(228, 'Security', 'Is the university college safe?', 'Yes, the college is secure and monitored regularly.'),
(229, 'Health', 'Are medical facilities available on campus?', 'Yes, medical facilities are available on campus.'),
(230, 'Hostel', 'Are hostels near the college?', 'Yes, hostel facilities are available near the college.'),
(231, 'Library', 'Does the university provide library and study resources?', 'Yes, the library is well equipped with books and digital resources.'),
(232, 'Laboratory', 'Are facilities for laboratories and workshops available?', 'Yes, laboratories and workshops are well equipped.'),
(233, 'Ranking', 'What is the ranking of the university?', 'The university is nationally and internationally recognized.'),
(234, 'Faculty', 'Are the teachers experienced?', 'Yes, teachers are well qualified and experienced.'),
(235, 'Opportunities', 'Are students encouraged to participate in national and international programs?', 'Yes, students are encouraged to participate globally.'),
(236, 'Collaboration', 'Does the university have collaboration with international universities?', 'Yes, collaborations exist with national and international universities.'),
(237, 'Guidance', 'Are students given guidance for entrance exam preparation?', 'Yes, guidance and resources are provided.'),
(238, 'Exams', 'What is the exam format for engineering courses?', 'Exams include theory, practical, projects, and internal assessments.'),
(239, 'Exams', 'Are semester-wise practical exams conducted?', 'Yes, practical exams are conducted each semester.'),
(240, 'Training', 'Are students trained for real-world applications?', 'Yes, practical projects and fieldwork provide real-world experience.'),
(241, 'Skills', 'Are on-campus bootcamps organized for skill enhancement?', 'Yes, bootcamps and workshops are organized.'),
(242, 'Innovation', 'Are students guided to participate in ideathons and hackathons?', 'Yes, participation is encouraged and achievements are recognized.'),
(243, 'Curriculum', 'Are courses updated with current industry trends?', 'Yes, courses are regularly updated.'),
(244, 'Internship', 'Are internship opportunities provided for all engineering disciplines?', 'Yes, internships are organized according to specialization.'),
(245, 'Career', 'Does the university provide career opportunities after graduation?', 'Yes, career guidance and placement support are provided.'),
(246, 'Collaboration', 'Are students encouraged to collaborate with other universities?', 'Yes, collaboration is promoted.'),
(247, 'Interaction', 'How is coordination between students and teachers?', 'Teachers maintain regular interaction and guidance sessions.'),
(248, 'Career', 'Are career counseling services available?', 'Yes, career counseling sessions are organized.'),
(249, 'Eligibility', 'Does the Grade C requirement apply to extra or optional courses?', 'No, the minimum grade requirement does not apply to extra or optional courses.');

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

CREATE TABLE `results` (
  `id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `marks` int(11) DEFAULT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `gpa` float DEFAULT NULL,
  `status` enum('draft','published') DEFAULT 'draft'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `results`
--

INSERT INTO `results` (`id`, `student_id`, `subject`, `marks`, `grade`, `gpa`, `status`) VALUES
(1, 1, 'math', 90, 'A', 4, 'published'),
(21, 1, 'math', 66, 'B', 3, 'published'),
(27, 7, 'science', 100, 'A+', 4, 'published');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `roll_no` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `course` varchar(100) NOT NULL,
  `semester` int(11) NOT NULL,
  `status` enum('Active','Inactive') NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `roll_no`, `name`, `course`, `semester`, `status`, `user_id`) VALUES
(1, '1', 'Krishna kadayat', 'BCA', 6, 'Active', NULL),
(2, '12', 'Krishna kadayat', 'BCA', 6, 'Active', NULL),
(3, '100', 'Krishna kadayat', 'BCA', 6, 'Active', NULL),
(4, '2', 'asital', 'BCA', 4, 'Inactive', NULL),
(5, '111', 'sital kadayt', 'BSc CSIT', 8, 'Active', NULL),
(7, '22', 'pabit', 'BCA', 6, 'Active', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `otp` varchar(10) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `otp`, `otp_expiry`) VALUES
(1, 'admin', 'krish@gmail.com', 'password123', NULL, NULL),
(3, 'hari', 'hari@gmail.com', 'hari', NULL, NULL),
(4, 'santosh ', 'santosh@gmail.com', 'password123', NULL, NULL),
(12, 'krishna', 'krishnakdt112@gmail.com', '123', NULL, NULL),
(17, 'k', 'krish0109@gmail.com', '123', NULL, NULL),
(19, 'kh', 'kadayat0109@gmail.com', '123', NULL, NULL),
(20, 'kapil', 'kapil@gmail.com', '11', NULL, NULL),
(21, 'k1', 'krishnakadayat112@gmail.com', 'scrypt:32768:8:1$l14KZmYyXKLjWroy$a0eea831c1ec3e662f4a444b90dce5773b5a5fbbfe352f3095729681d74925bb4a8b6623e334f27828832f7457981245fbf3acbab1309893890cf820b1a7dc5d', NULL, NULL),
(23, 'kapilbist', 'bistakapil98@gmail.com', 'kapil', '969456', '2026-04-15 10:48:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chatbot`
--
ALTER TABLE `chatbot`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chat_history`
--
ALTER TABLE `chat_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coursess`
--
ALTER TABLE `coursess`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `enquiries`
--
ALTER TABLE `enquiries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fees`
--
ALTER TABLE `fees`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notices`
--
ALTER TABLE `notices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `qa_table`
--
ALTER TABLE `qa_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `results`
--
ALTER TABLE `results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roll_no` (`roll_no`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `chatbot`
--
ALTER TABLE `chatbot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `chat_history`
--
ALTER TABLE `chat_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=178;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `coursess`
--
ALTER TABLE `coursess`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `enquiries`
--
ALTER TABLE `enquiries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fees`
--
ALTER TABLE `fees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notices`
--
ALTER TABLE `notices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `qa_table`
--
ALTER TABLE `qa_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=250;

--
-- AUTO_INCREMENT for table `results`
--
ALTER TABLE `results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `results_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
