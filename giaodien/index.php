<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <?php
    // Start session
    session_start();

    // Check if user is logged in
    if (!isset($_SESSION['user_id'])) {
        header("Location: login.php");
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
        die("Connection failed: " . $conn->connect_error);
    }

    // Start logging
    $log_file = 'debug.log';
    function log_message($message) {
        global $log_file;
        file_put_contents($log_file, date('Y-m-d H:i:s') . " - " . $message . "\n", FILE_APPEND);
    }

    // Handle logout
    if (isset($_POST['action']) && $_POST['action'] == 'logout') {
        session_unset();
        session_destroy();
        log_message("User logged out: Ma_TK='{$_SESSION['user_id']}'");
        header("Location: login.php");
        exit();
    }

    // Handle form submissions
    $message = "";
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        if (isset($_POST['action'])) {
            if ($_POST['action'] == 'add_account') {
                $ma_tk = $_POST['ma_tk'];
                $ten_dang_nhap = $_POST['ten_dang_nhap'];
                $mat_khau = $_POST['mat_khau'];
                $loai_tk = $_POST['loai_tk'];
                $ma_kh = !empty($_POST['ma_kh']) ? $_POST['ma_kh'] : null;
                $ma_ql = !empty($_POST['ma_ql']) ? $_POST['ma_ql'] : null;

                $stmt = $conn->prepare("CALL sp_QL_ThemTaiKhoan(?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("ssssss", $ma_tk, $ten_dang_nhap, $mat_khau, $loai_tk, $ma_kh, $ma_ql);
                try {
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $row = $result->fetch_assoc();
                    $message = $row['Message'];
                    log_message("Added account: Ma_TK='$ma_tk', Loai_TK='$loai_tk'");
                } catch (Exception $e) {
                    $message = "Lỗi thêm tài khoản: " . $e->getMessage();
                    log_message("Add account error: " . $e->getMessage());
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'delete_account') {
                $ma_tk = $_POST['ma_tk'];

                $stmt = $conn->prepare("CALL sp_QL_XoaTaiKhoan(?)");
                $stmt->bind_param("s", $ma_tk);
                try {
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $row = $result->fetch_assoc();
                    $message = $row['Message'];
                } catch (Exception $e) {
                    $message = "Lỗi xóa tài khoản: " . $e->getMessage();
                    log_message("Delete account error: " . $e->getMessage());
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'add_product') {
                $ma_sp = $_POST['ma_sp'];
                $ten_sp = $_POST['ten_sp'];
                $don_gia = $_POST['don_gia'];
                $mo_ta = $_POST['mo_ta'];
                $tinh_trang = $_POST['tinh_trang'];
                $so_luong = $_POST['so_luong'];

                $stmt = $conn->prepare("CALL sp_ThemSanPham(?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("ssdssi", $ma_sp, $ten_sp, $don_gia, $mo_ta, $tinh_trang, $so_luong);
                try {
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $row = $result->fetch_assoc();
                    $message = $row['Message'];
                } catch (Exception $e) {
                    $message = "Lỗi thêm sản phẩm: " . $e->getMessage();
                    log_message("Add product error: " . $e->getMessage());
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'edit_product') {
                $ma_sp = $_POST['ma_sp'];
                $ten_sp = !empty($_POST['ten_sp']) ? $_POST['ten_sp'] : null;
                $don_gia = !empty($_POST['don_gia']) ? $_POST['don_gia'] : null;
                $mo_ta = !empty($_POST['mo_ta']) ? $_POST['mo_ta'] : null;
                $tinh_trang = !empty($_POST['tinh_trang']) ? $_POST['tinh_trang'] : null;
                $so_luong = !empty($_POST['so_luong']) ? $_POST['so_luong'] : null;

                $stmt = $conn->prepare("CALL sp_SuaSanPham(?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("ssdssi", $ma_sp, $ten_sp, $don_gia, $mo_ta, $tinh_trang, $so_luong);
                try {
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $row = $result->fetch_assoc();
                    $message = $row['Message'];
                } catch (Exception $e) {
                    $message = "Lỗi sửa sản phẩm: " . $e->getMessage();
                    log_message("Edit product error: " . $e->getMessage());
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'delete_product') {
                $ma_sp = $_POST['ma_sp'];

                $stmt = $conn->prepare("CALL sp_XoaSanPham(?)");
                $stmt->bind_param("s", $ma_sp);
                try {
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $row = $result->fetch_assoc();
                    $message = $row['Message'];
                } catch (Exception $e) {
                    $message = "Lỗi xóa sản phẩm: " . $e->getMessage();
                    log_message("Delete product error: " . $e->getMessage());
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'delete_order') {
                if (!isset($_POST['ma_dh']) || empty(trim($_POST['ma_dh']))) {
                    $message = "Mã đơn hàng không hợp lệ!";
                    log_message("Invalid or empty Ma_DH received in delete_order");
                } else {
                    $ma_dh = trim($_POST['ma_dh']);
                    log_message("Attempting to delete order Ma_DH: '$ma_dh'");

                    // Verify if Ma_DH exists
                    $check_stmt = $conn->prepare("SELECT Ma_DH FROM don_hang WHERE Ma_DH = ?");
                    $check_stmt->bind_param("s", $ma_dh);
                    $check_stmt->execute();
                    $check_result = $check_stmt->get_result();
                    if ($check_result->num_rows == 0) {
                        $message = "Đơn hàng với mã '$ma_dh' không tồn tại!";
                        log_message("Order not found in don_hang: Ma_DH='$ma_dh'");
                        $check_stmt->close();
                    } else {
                        $check_stmt->close();
                        $conn->begin_transaction();
                        try {
                            $stmt = $conn->prepare("DELETE FROM don_hang WHERE Ma_DH = ?");
                            $stmt->bind_param("s", $ma_dh);
                            $stmt->execute();
                            $affected_rows = $stmt->affected_rows;
                            $stmt->close();

                            if ($affected_rows > 0) {
                                $conn->commit();
                                $message = "Xóa đơn hàng thành công!";
                                log_message("Order deleted successfully: Ma_DH='$ma_dh', Rows affected: $affected_rows");
                            } else {
                                $conn->rollback();
                                $message = "Không thể xóa đơn hàng '$ma_dh'!";
                                log_message("No rows affected for delete: Ma_DH='$ma_dh'");
                            }
                        } catch (Exception $e) {
                            $conn->rollback();
                            $message = "Lỗi xóa đơn hàng: " . $e->getMessage();
                            log_message("Delete order error: Ma_DH='$ma_dh', Error: " . $e->getMessage());
                        }
                    }
                }
            }
        }
    }

    // Fetch accounts
    $accounts = [];
    $customer_accounts_found = false;
    try {
        $result = $conn->query("CALL sp_QL_XemTaiKhoan(NULL)");
        if ($result) {
            while ($row = $result->fetch_assoc()) {
                $accounts[] = $row;
                if ($row['Loai_TK'] === 'KHÁCH HÀNG') {
                    $customer_accounts_found = true;
                }
            }
            log_message("Fetched " . count($accounts) . " accounts. Customer accounts found: " . ($customer_accounts_found ? 'Yes' : 'No'));
            $result->close();
            $conn->next_result();
        } else {
            $message = "Lỗi truy vấn tài khoản: " . $conn->error;
            log_message("Account query error: " . $conn->error);
            // Fallback query
            $result = $conn->query("SELECT * FROM tai_khoan");
            if ($result) {
                while ($row = $result->fetch_assoc()) {
                    $accounts[] = $row;
                    if ($row['Loai_TK'] === 'KHÁCH HÀNG') {
                        $customer_accounts_found = true;
                    }
                }
                log_message("Fallback query fetched " . count($accounts) . " accounts. Customer accounts found: " . ($customer_accounts_found ? 'Yes' : 'No'));
            }
        }
    } catch (Exception $e) {
        $message = "Lỗi gọi stored procedure tài khoản: " . $e->getMessage();
        log_message("Stored procedure error: " . $e->getMessage());
    }

    if (empty($accounts)) {
        $message = "Không có tài khoản nào được tìm thấy trong cơ sở dữ liệu!";
    } elseif (!$customer_accounts_found) {
        $message = "Không tìm thấy tài khoản khách hàng! Vui lòng thêm tài khoản khách hàng.";
    }

    // Fetch products
    $products = [];
    $result = $conn->query("CALL sp_XemSanPham(NULL)");
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $products[] = $row;
        }
        $result->close();
        $conn->next_result();
    } else {
        $message = "Lỗi truy vấn sản phẩm: " . $conn->error;
        log_message("Product query error: " . $conn->error);
    }

    // Fetch orders directly from don_hang
    $orders = [];
    $total_orders = 0;
    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
    $page_size = 10;
    $offset = ($page - 1) * $page_size;

    $query = "
        SELECT 
            dh.Ma_DH,
            DATE_FORMAT(dh.Ngay_Dat, '%d/%m/%Y %H:%i:%s') AS Ngay_Dat_Formatted,
            dh.Trang_Thai,
            dh.Ma_KH,
            kh.Ho_Ten AS Ten_KH,
            kh.SDT,
            COUNT(ctdh.Ma_SP) AS So_SanPham,
            FORMAT(SUM(ctdh.So_Luong * ctdh.Don_Gia), 'N0') AS Tong_Tien_Formatted
        FROM don_hang dh
        JOIN khach_hang kh ON dh.Ma_KH = kh.Ma_KH
        LEFT JOIN chi_tiet_don_hang ctdh ON dh.Ma_DH = ctdh.Ma_DH
        GROUP BY dh.Ma_DH, dh.Ngay_Dat, dh.Trang_Thai, dh.Ma_KH, kh.Ho_Ten, kh.SDT
        ORDER BY dh.Ngay_Dat DESC
        LIMIT ?, ?";
    $stmt = $conn->prepare($query);
    if ($stmt) {
        $stmt->bind_param("ii", $offset, $page_size);
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $orders[] = $row;
            }
            $result->close();
        } else {
            $message = "Lỗi thực thi truy vấn đơn hàng: " . $stmt->error;
            log_message("Order query execution error: " . $stmt->error);
        }
        $stmt->close();
    } else {
        $message = "Lỗi chuẩn bị truy vấn đơn hàng: " . $conn->error;
        log_message("Order query preparation error: " . $conn->error);
    }

    // Count total orders
    $result = $conn->query("SELECT COUNT(*) AS TotalOrders FROM don_hang");
    if ($result) {
        $total_orders = $result->fetch_assoc()['TotalOrders'];
        $result->close();
    } else {
        $message = "Lỗi đếm đơn hàng: " . $conn->error;
        log_message("Order count error: " . $conn->error);
    }
    ?>

    <div class="container mx-auto p-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold">Hệ Thống Quản Lý Đơn Hàng</h1>
            <div class="flex items-center">
                <span class="mr-4 text-gray-700">Xin chào, <?php echo htmlspecialchars($_SESSION['ten_dang_nhap']); ?> (<?php echo htmlspecialchars($_SESSION['loai_tk']); ?>)</span>
                <form method="POST">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Đăng Xuất</button>
                </form>
            </div>
        </div>

        <?php if ($message): ?>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                <?php echo htmlspecialchars($message); ?>
            </div>
        <?php endif; ?>

        <!-- Tabs -->
        <div class="flex border-b mb-6">
            <button class="tab-button px-4 py-2 font-semibold text-gray-700 border-b-2 border-transparent hover:border-blue-500" onclick="openTab('accounts')">Quản Lý Tài Khoản</button>
            <button class="tab-button px-4 py-2 font-semibold text-gray-700 border-b-2 border-transparent hover:border-blue-500" onclick="openTab('products')">Quản Lý Sản Phẩm</button>
            <button class="tab-button px-4 py-2 font-semibold text-gray-700 border-b-2 border-transparent hover:border-blue-500" onclick="openTab('orders')">Quản Lý Đơn Hàng</button>
        </div>

        <!-- Accounts Tab -->
        <div id="accounts" class="tab-content">
            <h2 class="text-2xl font-semibold mb-4">Quản Lý Tài Khoản</h2>
            <form method="POST" class="mb-6 bg-white p-4 rounded shadow">
                <input type="hidden" name="action" value="add_account">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium">Mã Tài Khoản</label>
                        <input type="text" name="ma_tk" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Tên Đăng Nhập</label>
                        <input type="text" name="ten_dang_nhap" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Mật Khẩu</label>
                        <input type="password" name="mat_khau" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Loại Tài Khoản</label>
                        <select name="loai_tk" class="mt-1 p-2 w-full border rounded" required>
                            <option value="KHÁCH HÀNG">Khách Hàng</option>
                            <option value="QUẢN LÝ">Quản Lý</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Mã Khách Hàng (nếu có)</label>
                        <input type="text" name="ma_kh" class="mt-1 p-2 w-full border rounded">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Mã Quản Lý (nếu có)</label>
                        <input type="text" name="ma_ql" class="mt-1 p-2 w-full border rounded">
                    </div>
                </div>
                <button type="submit" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Thêm Tài Khoản</button>
            </form>
            <table class="w-full bg-white rounded shadow">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="p-2 text-left">Mã TK</th>
                        <th class="p-2 text-left">Tên Đăng Nhập</th>
                        <th class="p-2 text-left">Loại TK</th>
                        <th class="p-2 text-left">Mã KH</th>
                        <th class="p-2 text-left">Mã QL</th>
                        <th class="p-2 text-left">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($accounts as $account): ?>
                        <tr>
                            <td class="p-2"><?php echo htmlspecialchars($account['Ma_TK']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($account['Ten_Dang_Nhap']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($account['Loai_TK']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($account['Ma_KH'] ?? 'N/A'); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($account['Ma_QL'] ?? 'N/A'); ?></td>
                            <td class="p-2">
                                <form method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa tài khoản này?');">
                                    <input type="hidden" name="action" value="delete_account">
                                    <input type="hidden" name="ma_tk" value="<?php echo htmlspecialchars($account['Ma_TK']); ?>">
                                    <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <!-- Products Tab -->
        <div id="products" class="tab-content hidden">
            <h2 class="text-2xl font-semibold mb-4">Quản Lý Sản Phẩm</h2>
            <form method="POST" class="mb-6 bg-white p-4 rounded shadow">
                <input type="hidden" name="action" value="add_product">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium">Mã Sản Phẩm</label>
                        <input type="text" name="ma_sp" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Tên Sản Phẩm</label>
                        <input type="text" name="ten_sp" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Đơn Giá</label>
                        <input type="number" name="don_gia" step="0.01" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Mô Tả</label>
                        <input type="text" name="mo_ta" class="mt-1 p-2 w-full border rounded">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Tình Trạng</label>
                        <input type="text" name="tinh_trang" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Số Lượng</label>
                        <input type="number" name="so_luong" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                </div>
                <button type="submit" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Thêm Sản Phẩm</button>
            </form>
            <table class="w-full bg-white rounded shadow">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="p-2 text-left">Mã SP</th>
                        <th class="p-2 text-left">Tên SP</th>
                        <th class="p-2 text-left">Đơn Giá</th>
                        <th class="p-2 text-left">Mô Tả</th>
                        <th class="p-2 text-left">Tình Trạng</th>
                        <th class="p-2 text-left">Số Lượng</th>
                        <th class="p-2 text-left">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($products as $product): ?>
                        <tr>
                            <td class="p-2"><?php echo htmlspecialchars($product['Ma_SP']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($product['Ten_SP']); ?></td>
                            <td class="p-2"><?php echo number_format($product['Don_Gia'], 2); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($product['Mo_ta'] ?? 'N/A'); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($product['Tinh_trang']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($product['So_luong']); ?></td>
                            <td class="p-2">
                                <button onclick="openEditProductModal('<?php echo htmlspecialchars($product['Ma_SP']); ?>', '<?php echo htmlspecialchars($product['Ten_SP']); ?>', '<?php echo htmlspecialchars($product['Don_Gia']); ?>', '<?php echo htmlspecialchars($product['Mo_ta'] ?? ''); ?>', '<?php echo htmlspecialchars($product['Tinh_trang']); ?>', '<?php echo htmlspecialchars($product['So_luong']); ?>')" class="bg-yellow-500 text-white px-2 py-1 rounded hover:bg-yellow-600">Sửa</button>
                                <form method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                    <input type="hidden" name="action" value="delete_product">
                                    <input type="hidden" name="ma_sp" value="<?php echo htmlspecialchars($product['Ma_SP']); ?>">
                                    <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <!-- Orders Tab -->
        <div id="orders" class="tab-content hidden">
            <h2 class="text-2xl font-semibold mb-4">Quản Lý Đơn Hàng</h2>
            <table class="w-full bg-white rounded shadow">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="p-2 text-left">Mã ĐH</th>
                        <th class="p-2 text-left">Ngày Đặt</th>
                        <th class="p-2 text-left">Trạng Thái</th>
                        <th class="p-2 text-left">Mã KH</th>
                        <th class="p-2 text-left">Tên KH</th>
                        <th class="p-2 text-left">SĐT</th>
                        <th class="p-2 text-right">Số SP</th>
                        <th class="p-2 text-right">Tổng Tiền</th>
                        <th class="p-2 text-left">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($orders as $order): ?>
                        <tr>
                            <td class="p-2"><?php echo htmlspecialchars($order['Ma_DH']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($order['Ngay_Dat_Formatted']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($order['Trang_Thai']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($order['Ma_KH']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($order['Ten_KH']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($order['SDT']); ?></td>
                            <td class="p-2 text-right"><?php echo htmlspecialchars($order['So_SanPham']); ?></td>
                            <td class="p-2 text-right"><?php echo htmlspecialchars($order['Tong_Tien_Formatted']); ?></td>
                            <td class="p-2">
                                <form method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa đơn hàng <?php echo htmlspecialchars($order['Ma_DH']); ?>?');">
                                    <input type="hidden" name="action" value="delete_order">
                                    <input type="hidden" name="ma_dh" value="<?php echo htmlspecialchars($order['Ma_DH']); ?>">
                                    <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
            <!-- Pagination -->
            <div class="mt-4 flex justify-center">
                <?php
                $total_pages = ceil($total_orders / $page_size);
                for ($i = 1; $i <= $total_pages; $i++):
                ?>
                    <a href="?page=<?php echo $i; ?>" class="mx-1 px-3 py-1 bg-blue-500 text-white rounded <?php echo $page == $i ? 'bg-blue-700' : ''; ?>"><?php echo $i; ?></a>
                <?php endfor; ?>
            </div>
        </div>

        <!-- Edit Product Modal -->
        <div id="editProductModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center hidden">
            <div class="bg-white p-6 rounded shadow-lg w-1/2">
                <h2 class="text-xl font-semibold mb-4">Sửa Sản Phẩm</h2>
                <form method="POST">
                    <input type="hidden" name="action" value="edit_product">
                    <input type="hidden" name="ma_sp" id="edit_ma_sp">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium">Tên Sản Phẩm</label>
                            <input type="text" name="ten_sp" id="edit_ten_sp" class="mt-1 p-2 w-full border rounded">
                        </div>
                        <div>
                            <label class="block text-sm font-medium">Đơn Giá</label>
                            <input type="number" name="don_gia" id="edit_don_gia" step="0.01" class="mt-1 p-2 w-full border rounded">
                        </div>
                        <div>
                            <label class="block text-sm font-medium">Mô Tả</label>
                            <input type="text" name="mo_ta" id="edit_mo_ta" class="mt-1 p-2 w-full border rounded">
                        </div>
                        <div>
                            <label class="block text-sm font-medium">Tình Trạng</label>
                            <input type="text" name="tinh_trang" id="edit_tinh_trang" class="mt-1 p-2 w-full border rounded">
                        </div>
                        <div>
                            <label class="block text-sm font-medium">Số Lượng</label>
                            <input type="number" name="so_luong" id="edit_so_luong" class="mt-1 p-2 w-full border rounded">
                        </div>
                    </div>
                    <div class="mt-4 flex justify-end">
                        <button type="button" onclick="closeEditProductModal()" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 mr-2">Hủy</button>
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Lưu</button>
                    </div>
                </form>
            </div>
        </div>

    <script>
        function openTab(tabName) {
            const tabs = document.getElementsByClassName('tab-content');
            for (let tab of tabs) {
                tab.classList.add('hidden');
            }
            document.getElementById(tabName).classList.remove('hidden');

            const buttons = document.getElementsByClassName('tab-button');
            for (let btn of buttons) {
                btn.classList.remove('border-blue-500');
                btn.classList.add('border-transparent');
            }
            event.currentTarget.classList.remove('border-transparent');
            event.currentTarget.classList.add('border-blue-500');
        }

        function openEditProductModal(ma_sp, ten_sp, don_gia, mo_ta, tinh_trang, so_luong) {
            document.getElementById('edit_ma_sp').value = ma_sp;
            document.getElementById('edit_ten_sp').value = ten_sp;
            document.getElementById('edit_don_gia').value = don_gia;
            document.getElementById('edit_mo_ta').value = mo_ta;
            document.getElementById('edit_tinh_trang').value = tinh_trang;
            document.getElementById('edit_so_luong').value = so_luong;
            document.getElementById('editProductModal').classList.remove('hidden');
        }

        function closeEditProductModal() {
            document.getElementById('editProductModal').classList.add('hidden');
        }

        // Open default tab
        document.getElementById('accounts').classList.remove('hidden');
        document.getElementsByClassName('tab-button')[0].classList.add('border-blue-500');
    </script>

    <?php $conn->close(); ?>
</body>
</html>