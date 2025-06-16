
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans flex items-center justify-center h-screen">
    <?php
    // Start session
    session_start();

    // If already logged in, redirect to index.php
    if (isset($_SESSION['user_id'])) {
        header("Location: index.php");
        exit();
    }

    // Enable error reporting
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    // Database connection
    $servername = "127.0.0.1";
    $username = "root";
    $password = "";
    $dbname = "huyqlldh";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        $message = "Lỗi kết nối cơ sở dữ liệu: " . $conn->connect_error;
        file_put_contents('debug.log', date('Y-m-d H:i:s') . " - Database connection error: " . $conn->connect_error . "\n", FILE_APPEND);
        die($message);
    }

    // Start logging
    $log_file = 'debug.log';
    function log_message($message) {
        global $log_file;
        file_put_contents($log_file, date('Y-m-d H:i:s') . " - " . $message . "\n", FILE_APPEND);
    }

    // Handle login form submission
    $message = "";
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $ten_dang_nhap = trim($_POST['ten_dang_nhap']);
        $mat_khau = trim($_POST['mat_khau']);

        log_message("Login attempt: Ten_Dang_Nhap='$ten_dang_nhap'");

        if (empty($ten_dang_nhap) || empty($mat_khau)) {
            $message = "Vui lòng nhập tên đăng nhập và mật khẩu!";
            log_message("Login failed: Empty username or password");
        } else {
            try {
                $stmt = $conn->prepare("CALL sp_DangNhap(?, ?)");
                if (!$stmt) {
                    throw new Exception("Lỗi chuẩn bị stored procedure: " . $conn->error);
                }
                $stmt->bind_param("ss", $ten_dang_nhap, $mat_khau);
                $stmt->execute();
                $result = $stmt->get_result();

                log_message("sp_DangNhap returned " . $result->num_rows . " rows");

                if ($result->num_rows > 0) {
                    $row = $result->fetch_assoc();
                    if (isset($row['Ma_TK'])) {
                        // Successful login
                        $_SESSION['user_id'] = $row['Ma_TK'];
                        $_SESSION['ten_dang_nhap'] = $ten_dang_nhap;
                        $_SESSION['loai_tk'] = $row['Loai_TK'];
                        log_message("Login success: Ma_TK='{$row['Ma_TK']}', Loai_TK='{$row['Loai_TK']}'");
                        $stmt->close();
                        header("Location: index.php");
                        exit();
                    } else {
                        $message = "Tên đăng nhập hoặc mật khẩu không đúng!";
                        log_message("Login failed: No Ma_TK in result for Ten_Dang_Nhap='$ten_dang_nhap'");
                    }
                } else {
                    // Fallback query (case-insensitive)
                    $stmt = $conn->prepare("SELECT Ma_TK, Loai_TK FROM tai_khoan WHERE LOWER(Ten_Dang_Nhap) = LOWER(?) AND Mat_Khau = ?");
                    $stmt->bind_param("ss", $ten_dang_nhap, $mat_khau);
                    $stmt->execute();
                    $result = $stmt->get_result();

                    log_message("Fallback query returned " . $result->num_rows . " rows");

                    if ($result->num_rows > 0) {
                        $row = $result->fetch_assoc();
                        $_SESSION['user_id'] = $row['Ma_TK'];
                        $_SESSION['ten_dang_nhap'] = $ten_dang_nhap;
                        $_SESSION['loai_tk'] = $row['Loai_TK'];
                        log_message("Login success (fallback): Ma_TK='{$row['Ma_TK']}', Loai_TK='{$row['Loai_TK']}'");
                        $stmt->close();
                        header("Location: index.php");
                        exit();
                    } else {
                        $message = "Tên đăng nhập hoặc mật khẩu không đúng!";
                        log_message("Login failed: No match for Ten_Dang_Nhap='$ten_dang_nhap'");
                    }
                }
                $stmt->close();
            } catch (Exception $e) {
                $message = "Lỗi đăng nhập: " . $e->getMessage();
                log_message("Login error: " . $e->getMessage());
            }
        }
    }

    $conn->close();
    ?>

    <div class="bg-white p-8 rounded shadow-md w-full max-w-md">
        <h2 class="text-2xl font-bold text-center mb-6">Đăng Nhập Hệ Thống Quản Lý</h2>
        <?php if ($message): ?>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <?php echo htmlspecialchars($message); ?>
            </div>
        <?php endif; ?>
        <form method="POST" action="login.php">
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700">Tên Đăng Nhập</label>
                <input type="text" name="ten_dang_nhap" class="mt-1 p-2 w-full border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700">Mật Khẩu</label>
                <input type="password" name="mat_khau" class="mt-1 p-2 w-full border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <button type="submit" class="w-full bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Đăng Nhập</button>
        </form>
    </div>
</body>
</html>
