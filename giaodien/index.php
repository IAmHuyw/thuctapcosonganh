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
    // Database connection
    $servername = "127.0.0.1";
    $username = "root";
    $password = "";
    $dbname = "qlydonhang";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
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
                } catch (Exception $e) {
                    $message = $e->getMessage();
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
                    $message = $e->getMessage();
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
                    $message = $e->getMessage();
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
                    $message = $e->getMessage();
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
                    $message = $e->getMessage();
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'add_order') {
                $ma_dh = $_POST['ma_dh'];
                $ma_kh = $_POST['ma_kh'];
                $ngay_dat = $_POST['ngay_dat'];
                $trang_thai = $_POST['trang_thai'];
                $ma_sp = $_POST['ma_sp'];
                $so_luong = $_POST['so_luong'];
                $don_gia = $_POST['don_gia'];

                $conn->begin_transaction();
                try {
                    // Insert into DON_HANG
                    $stmt = $conn->prepare("INSERT INTO don_hang (Ma_DH, Ma_KH, Ngay_Dat, Trang_Thai) VALUES (?, ?, ?, ?)");
                    $stmt->bind_param("ssss", $ma_dh, $ma_kh, $ngay_dat, $trang_thai);
                    $stmt->execute();
                    $stmt->close();

                    // Insert into CHI_TIET_DON_HANG
                    $stmt = $conn->prepare("INSERT INTO chi_tiet_don_hang (Ma_DH, Ma_SP, So_Luong, Don_Gia) VALUES (?, ?, ?, ?)");
                    $stmt->bind_param("ssid", $ma_dh, $ma_sp, $so_luong, $don_gia);
                    $stmt->execute();
                    $stmt->close();

                    $conn->commit();
                    $message = "Thêm đơn hàng thành công!";
                } catch (Exception $e) {
                    $conn->rollback();
                    $message = $e->getMessage();
                }
            } elseif ($_POST['action'] == 'delete_order') {
                $ma_dh = $_POST['ma_dh'];

                try {
                    $stmt = $conn->prepare("DELETE FROM don_hang WHERE Ma_DH = ?");
                    $stmt->bind_param("s", $ma_dh);
                    $stmt->execute();
                    $stmt->close();
                    $message = "Xóa đơn hàng thành công!";
                } catch (Exception $e) {
                    $message = $e->getMessage();
                }
            }
        }
    }

    // Fetch accounts
    $accounts = [];
    $result = $conn->query("CALL sp_QL_XemTaiKhoan(NULL)");
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $accounts[] = $row;
        }
        $result->close();
        $conn->next_result();
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
    }

    // Fetch orders
    $orders = [];
    $total_orders = 0;
    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
    $page_size = 10;
    $stmt = $conn->prepare("CALL sp_QL_XemDonHang(NULL, NULL, NULL, NULL, NULL, ?, ?)");
    $stmt->bind_param("ii", $page, $page_size);
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }
        $result->close();
        $conn->next_result();
        $result = $conn->query("SELECT COUNT(*) AS TotalOrders FROM DON_HANG");
        if ($result) {
            $total_orders = $result->fetch_assoc()['TotalOrders'];
            $result->close();
        }
    }
    $stmt->close();

    // Fetch customers and products for dropdowns
    $customers = [];
    $result = $conn->query("SELECT Ma_KH, Ho_Ten FROM khach_hang");
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $customers[] = $row;
        }
        $result->close();
    }
    ?>

    <div class="container mx-auto p-4">
        <h1 class="text-3xl font-bold text-center mb-6">Hệ Thống Quản Lý Đơn Hàng</h1>

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
            <form method="POST" class="mb-6 bg-white p-4 rounded shadow">
                <input type="hidden" name="action" value="add_order">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium">Mã Đơn Hàng</label>
                        <input type="text" name="ma_dh" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Mã Khách Hàng</label>
                        <select name="ma_kh" class="mt-1 p-2 w-full border rounded" required>
                            <?php foreach ($customers as $customer): ?>
                                <option value="<?php echo htmlspecialchars($customer['Ma_KH']); ?>"><?php echo htmlspecialchars($customer['Ma_KH'] . ' - ' . $customer['Ho_Ten']); ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Ngày Đặt</label>
                        <input type="datetime-local" name="ngay_dat" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Trạng Thái</label>
                        <select name="trang_thai" class="mt-1 p-2 w-full border rounded" required>
                            <option value="Đã đặt">Đã đặt</option>
                            <option value="Đang giao">Đang giao</option>
                            <option value="Hoàn thành">Hoàn thành</option>
                            <option value="Đã hủy">Đã hủy</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Mã Sản Phẩm</label>
                        <select name="ma_sp" class="mt-1 p-2 w-full border rounded" required>
                            <?php foreach ($products as $product): ?>
                                <option value="<?php echo htmlspecialchars($product['Ma_SP']); ?>"><?php echo htmlspecialchars($product['Ma_SP'] . ' - ' . $product['Ten_SP']); ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Số Lượng</label>
                        <input type="number" name="so_luong" class="mt-1 p-2 w-full border rounded" required min="1">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Đơn Giá</label>
                        <input type="number" name="don_gia" step="0.01" class="mt-1 p-2 w-full border rounded" required>
                    </div>
                </div>
                <button type="submit" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Thêm Đơn Hàng</button>
            </form>
            <table class="w-full bg-white rounded shadow">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="p-2 text-left">Mã ĐH</th>
                        <th class="p-2 text-left">Ngày Đặt</th>
                        <th class="p-2 text-left">Trạng Thái</th>
                        <th class="p-2 text-left">Mã KH</th>
                        <th class="p-2 text-left">Tên KH</th>
                        <th class="p-2 text-left">SĐT</th>
                        <th class="p-2 text-left">Số SP</th>
                        <th class="p-2 text-left">Tổng Tiền</th>
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
                            <td class="p-2"><?php echo htmlspecialchars($order['So_SanPham']); ?></td>
                            <td class="p-2"><?php echo htmlspecialchars($order['Tong_Tien_Formatted']); ?></td>
                            <td class="p-2">
                                <form method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa đơn hàng này?');">
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
