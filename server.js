// ====================================================================
// FIDE WORLD CHESS CHAMPIONSHIP - ENTERPRISE WEB SERVER
// Chạy trực tiếp bằng Node.js: node server.js
// Giao diện Full-screen chuyên nghiệp, SVG Vector Icons, chuẩn JSP/DAO
// ====================================================================

const http = require('http');
const url = require('url');
const querystring = require('querystring');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 8080;

// CSDL Nạp sẵn trong bộ nhớ (Khớp 100% với schema và kịch bản PTTK)
const DB_USERS = {
    'btc1': { id: 1, username: 'btc1', password: 'mk123@', hoTen: 'Nguyễn Đức Ngọc', chucVu: 'Trưởng ban điều hành giải', email: 'ngoc.nd@fide.org' },
    'btc2': { id: 2, username: 'btc2', password: '123456', hoTen: 'Nguyễn Đức Mạnh', chucVu: 'Phó ban điều hành', email: 'manh.nd@fide.org' },
    'admin': { id: 3, username: 'admin', password: 'admin123', hoTen: 'Nguyễn Hoàng Nam', chucVu: 'Quản trị viên hệ thống', email: 'nam.nh@fide.org' }
};

let DB_GIAI_DAU = [
    { id: 4, maGD: 'GD004', nam: 2024, variant: 'Classical', muaGiai: 1, diaDiem: 'Geneva, Thụy Sĩ', trangThai: 'Kết thúc', ngayBatDau: '2024-05-10', ngayKetThuc: '2024-05-25', note: 'Giải đấu vòng loại số 1 quốc tế' },
    { id: 5, maGD: 'GD005', nam: 2024, variant: 'Classical', muaGiai: 2, diaDiem: 'Geneva, Thụy Sĩ', trangThai: 'Kết thúc', ngayBatDau: '2024-09-10', ngayKetThuc: '2024-09-25', note: 'Giải đấu đầu tiên trong 20 năm không do Carlsen giành chức vô địch' },
    { id: 6, maGD: 'GD006', nam: 2024, variant: 'Rapid & Blitz', muaGiai: 1, diaDiem: 'Geneva, Thụy Sĩ', trangThai: 'Kết thúc', ngayBatDau: '2024-12-01', ngayKetThuc: '2024-12-10', note: 'Giải đấu cờ nhanh & cờ chớp' },
    { id: 10, maGD: 'GD010', nam: 2026, variant: 'Classical', muaGiai: 1, diaDiem: 'Geneva, Thụy Sĩ', trangThai: 'Kết thúc', ngayBatDau: '2026-03-01', ngayKetThuc: '2026-03-15', note: 'Giải mở màn mùa giải 2026' },
    { id: 11, maGD: 'GD011', nam: 2026, variant: 'Rapid & Blitz', muaGiai: 1, diaDiem: 'Geneva, Thụy Sĩ', trangThai: 'Kết thúc', ngayBatDau: '2026-06-05', ngayKetThuc: '2026-06-12', note: 'Giải cờ nhanh châu Âu' },
    { id: 12, maGD: 'GD012', nam: 2026, variant: 'Classical', muaGiai: 2, diaDiem: 'Hà Nội, Việt Nam', trangThai: 'Đang diễn ra', ngayBatDau: '2026-09-10', ngayKetThuc: '2026-09-30', note: 'Lần đầu tiên giải vô địch cờ vua thế giới tổ chức ở Việt Nam' }
];

let DB_VONG_DAU = [
    { id: 101, soVong: 1, ngayThiDau: '2026-09-11', trangThai: 'Kết thúc', thoiGian: '10:30 - 18:00', giaiDauId: 12 },
    { id: 102, soVong: 2, ngayThiDau: '2026-09-12', trangThai: 'Kết thúc', thoiGian: '10:30 - 18:00', giaiDauId: 12 },
    { id: 103, soVong: 3, ngayThiDau: '2026-09-13', trangThai: 'Kết thúc', thoiGian: '10:30 - 18:00', giaiDauId: 12 },
    { id: 104, soVong: 4, ngayThiDau: '2026-09-15', trangThai: 'Kết thúc', thoiGian: '10:30 - 18:00', giaiDauId: 12 },
    { id: 105, soVong: 5, ngayThiDau: '2026-09-16', trangThai: 'Đang diễn ra', thoiGian: '10:30 - 18:00', giaiDauId: 12 }, // Cho phép nhập kết quả
    { id: 106, soVong: 6, ngayThiDau: '2026-09-17', trangThai: 'Chưa bắt đầu', thoiGian: '10:30 - 18:00', giaiDauId: 12 }, // Test chặn lỗi ngoại lệ
    { id: 107, soVong: 7, ngayThiDau: '2026-09-19', trangThai: 'Chưa bắt đầu', thoiGian: '10:30 - 18:00', giaiDauId: 12 }
];

let DB_TRAN_DAU = [
    // Vòng 5: Đang diễn ra (10 đại kiện tướng độc lập, mỗi bàn 1 cặp kỳ thủ duy nhất, không trùng lặp)
    {
        id: 1101, vongDauId: 105, soBan: 'Bàn 11', trangThai: 'Đang diễn ra',
        p1: { id: 101, name: 'Magnus Carlsen', country: 'Na Uy', elo: 2830.0, expected: 0.54, score: null, deltaElo: null },
        p2: { id: 102, name: 'Hikaru Nakamura', country: 'Hoa Kỳ', elo: 2802.0, expected: 0.46, score: null, deltaElo: null }
    },
    {
        id: 1102, vongDauId: 105, soBan: 'Bàn 110', trangThai: 'Đang diễn ra',
        p1: { id: 103, name: 'Ding Liren', country: 'Trung Quốc', elo: 2750.0, expected: 0.49, score: null, deltaElo: null },
        p2: { id: 104, name: 'Gukesh Dommaraju', country: 'Ấn Độ', elo: 2760.0, expected: 0.51, score: null, deltaElo: null }
    },
    {
        id: 1103, vongDauId: 105, soBan: 'Bàn 011', trangThai: 'Đang diễn ra',
        p1: { id: 105, name: 'Ian Nepomniachtchi', country: 'FIDE', elo: 2770.0, expected: 0.45, score: null, deltaElo: null },
        p2: { id: 106, name: 'Fabiano Caruana', country: 'Hoa Kỳ', elo: 2805.0, expected: 0.55, score: null, deltaElo: null }
    },
    {
        id: 1104, vongDauId: 105, soBan: 'Bàn 111', trangThai: 'Đang diễn ra',
        p1: { id: 107, name: 'Alireza Firouzja', country: 'Pháp', elo: 2785.0, expected: 0.54, score: null, deltaElo: null },
        p2: { id: 108, name: 'Praggnanandhaa R', country: 'Ấn Độ', elo: 2755.0, expected: 0.46, score: null, deltaElo: null }
    },
    {
        id: 1105, vongDauId: 105, soBan: 'Bàn 01', trangThai: 'Đang diễn ra',
        p1: { id: 109, name: 'Nodirbek Abdusattorov', country: 'Uzbekistan', elo: 2765.0, expected: 0.50, score: null, deltaElo: null },
        p2: { id: 110, name: 'Wei Yi', country: 'Trung Quốc', elo: 2762.0, expected: 0.50, score: null, deltaElo: null }
    },
    // Vòng 4: Kết thúc (mỗi trận thuộc vòng 4 tương ứng)
    {
        id: 1041, vongDauId: 104, soBan: 'Bàn 01', trangThai: 'Kết thúc',
        p1: { id: 101, name: 'Magnus Carlsen', country: 'Na Uy', elo: 2831.0, expected: 0.54, score: 1.0, deltaElo: 4.6 },
        p2: { id: 106, name: 'Fabiano Caruana', country: 'Hoa Kỳ', elo: 2804.0, expected: 0.46, score: 0.0, deltaElo: -4.6 }
    },
    {
        id: 1042, vongDauId: 104, soBan: 'Bàn 02', trangThai: 'Kết thúc',
        p1: { id: 102, name: 'Hikaru Nakamura', country: 'Hoa Kỳ', elo: 2801.0, expected: 0.57, score: 0.5, deltaElo: -0.7 },
        p2: { id: 103, name: 'Ding Liren', country: 'Trung Quốc', elo: 2751.0, expected: 0.43, score: 0.5, deltaElo: 0.7 }
    }
];

// Quản lý Server-side Session
const sessions = {};

function parseCookies(req) {
    const list = {};
    const rc = req.headers.cookie;
    if (rc) {
        rc.split(';').forEach(cookie => {
            const parts = cookie.split('=');
            list[parts.shift().trim()] = decodeURI(parts.join('='));
        });
    }
    return list;
}

// Layout Web Thực Thụ: Full-width, Navbar chuẩn FIDE, Clean UI, không khung fake
function renderFullPage(pageTitle, currentUser, bodyContent) {
    return `<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - FIDE World Chess Management</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Font 'Inter' -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #f1f5f9; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 9999px; }
    </style>
</head>
<body class="min-h-full flex flex-col text-slate-800">

    <!-- Top Navigation Bar (Full Width) -->
    <nav class="bg-[#1e3a8a] text-white shadow-md sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <!-- Brand / Logo -->
                <a href="${currentUser ? '/gdTrangQuanLiGiaiCoVua.jsp' : '/gdCoBan.jsp'}" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="/images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg tracking-tight text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>

                <!-- Nav Links & Auth Area -->
                <div class="flex items-center gap-4">
                    ${currentUser ? `
                        <div class="hidden sm:flex items-center gap-3 pl-4 border-l border-blue-800">
                            <div class="w-8 h-8 rounded-full bg-blue-700 flex items-center justify-center text-xs font-bold text-yellow-300 border border-blue-600">
                                ${currentUser.hoTen.split(' ').pop().charAt(0)}
                            </div>
                            <div class="text-left">
                                <span class="text-xs font-bold text-white block leading-none">${currentUser.hoTen}</span>
                                <span class="text-[10px] text-blue-300 block mt-0.5">${currentUser.chucVu}</span>
                            </div>
                        </div>
                        <a href="/logout" class="bg-red-600 hover:bg-red-700 text-white px-3.5 py-1.5 rounded-lg text-xs font-semibold shadow-sm transition flex items-center gap-1.5">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                            Đăng xuất
                        </a>
                    ` : `
                        <a href="/gdLogin.jsp" class="whitespace-nowrap bg-blue-600 hover:bg-blue-500 text-white px-4 py-2 rounded-lg text-xs font-semibold shadow-sm transition flex items-center gap-1.5">
                            <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path></svg>
                            <span>Đăng nhập</span>
                        </a>
                    `}
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Canvas -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8">
        ${bodyContent}
    </main>

    <!-- Enterprise Footer -->
    <footer class="bg-white border-t border-slate-200 mt-auto py-4 text-center text-xs text-slate-500">
        <div class="max-w-7xl mx-auto px-4 text-center">
            © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
        </div>
    </footer>

</body>
</html>`;
}

const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const cookies = parseCookies(req);
    const sessionId = cookies.sessionId;
    const currentUser = sessions[sessionId];

    // Phục vụ file tĩnh (ảnh logo, static assets)
    if (pathname.startsWith('/images/')) {
        const filename = path.basename(pathname);
        const filePath = path.join(__dirname, 'images', filename);
        if (fs.existsSync(filePath)) {
            const ext = path.extname(filePath).toLowerCase();
            const mimeTypes = {
                '.png': 'image/png',
                '.jpg': 'image/jpeg',
                '.jpeg': 'image/jpeg',
                '.svg': 'image/svg+xml',
                '.gif': 'image/gif',
                '.webp': 'image/webp'
            };
            const contentType = mimeTypes[ext] || 'application/octet-stream';
            res.writeHead(200, { 'Content-Type': contentType, 'Cache-Control': 'public, max-age=3600' });
            return fs.createReadStream(filePath).pipe(res);
        } else {
            res.writeHead(404, { 'Content-Type': 'text/plain; charset=UTF-8' });
            return res.end('Image Not Found');
        }
    }

    // 1. ROUTE: Trang chủ cơ bản (gdCoBan.jsp)
    if (pathname === '/' || pathname === '/gdCoBan.jsp') {
        const bodyContent = `
            <div class="py-12 md:py-20 flex flex-col items-center justify-center text-center">
                <div class="inline-flex items-center gap-2 bg-yellow-100 border border-yellow-300 text-yellow-900 text-xs px-3.5 py-1.5 rounded-full font-bold mb-6 shadow-sm">
                    <svg class="w-4 h-4 text-yellow-600" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                    FIDE OFFICIAL WORLD CHESS CHAMPIONSHIP PORTAL
                </div>

                <h1 class="text-4xl md:text-6xl font-extrabold text-[#1e3a8a] mb-6 tracking-tight max-w-4xl leading-tight">
                    Hệ Thống Quản Lý Giải Cờ Vua Vô Địch Thế Giới
                </h1>

                <p class="text-slate-600 max-w-2xl text-base md:text-lg mb-10 leading-relaxed">
                    Hệ thống chuyên trách phục vụ công tác quản lý thông tin giải đấu, theo dõi lịch trình thi đấu và cập nhật kết quả từng vòng đấu chuẩn FIDE quốc tế.
                </p>

                <div class="flex flex-col sm:flex-row gap-5 items-center justify-center">
                    <a href="/gdLogin.jsp" class="whitespace-nowrap px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-md hover:shadow-lg transition flex items-center justify-center gap-2.5 text-base">
                        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path></svg>
                        <span>Đăng nhập</span>
                    </a>
                    <button type="button" disabled class="whitespace-nowrap px-8 py-4 bg-slate-200 text-slate-400 font-bold rounded-xl cursor-not-allowed border border-slate-300 flex items-center justify-center gap-2.5 text-base">
                        <svg class="w-5 h-5 opacity-40 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                        <span>Bảng xếp hạng</span>
                    </button>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Trang chủ', currentUser, bodyContent));
    }

    // 2. ROUTE: Giao diện đăng nhập (gdLogin.jsp / gddangnhap.jsp)
    if (pathname === '/gdLogin.jsp' || pathname === '/gddangnhap.jsp') {
        const bodyContent = `
            <div class="max-w-md mx-auto my-16">
                <div class="bg-white p-8 sm:p-10 rounded-2xl shadow-md border border-slate-200">
                    <div class="text-center mb-8">
                        <h2 class="text-2xl font-bold text-[#1e3a8a] tracking-tight">Đăng nhập</h2>
                    </div>

                    <form action="/doCheckLogin.jsp" method="POST" class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Tài khoản</label>
                            <input type="text" name="txtUsername" value="btc1" required
                                   class="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm transition">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">Mật khẩu</label>
                            <input type="password" name="pwdPassword" value="mk123@" required
                                   class="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm transition">
                        </div>
                        <div class="pt-4 flex items-center justify-between">
                            <a href="/gdCoBan.jsp" class="text-sm font-medium text-slate-500 hover:text-slate-800 transition">
                                Quay lại
                            </a>
                            <button type="submit" class="px-7 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold transition shadow-sm hover:shadow">
                                Đăng nhập
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Đăng nhập', currentUser, bodyContent));
    }

    // 3. ROUTE: Xử lý đăng nhập (doCheckLogin.jsp / doDangnhap.jsp)
    if ((pathname === '/doCheckLogin.jsp' || pathname === '/doDangnhap.jsp') && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            const postData = querystring.parse(body);
            const u = (postData.txtUsername || postData.username || '').trim();
            const p = (postData.pwdPassword || postData.password || '').trim();

            const userFound = DB_USERS[u];
            if (userFound && userFound.password === p) {
                const newSessionId = 'sess_' + Date.now() + '_' + Math.random().toString(36).substring(2, 9);
                sessions[newSessionId] = userFound;

                res.writeHead(200, {
                    'Set-Cookie': `sessionId=${newSessionId}; HttpOnly; Path=/`,
                    'Content-Type': 'text/html; charset=UTF-8'
                });
                return res.end(`
                    <!DOCTYPE html>
                    <html>
                    <head><meta charset="UTF-8"><title>Xử lý đăng nhập</title></head>
                    <body>
                        <script>
                            alert("Đăng nhập thành công! Chào mừng ${userFound.hoTen} (${userFound.chucVu}).");
                            window.location.href = "/gdTrangQuanLiGiaiCoVua.jsp";
                        </script>
                    </body>
                    </html>
                `);
            } else {
                res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
                return res.end(`
                    <!DOCTYPE html>
                    <html>
                    <head><meta charset="UTF-8"><title>Xử lý đăng nhập</title></head>
                    <body>
                        <script>
                            alert("Đăng nhập thất bại! Tên tài khoản hoặc mật khẩu không chính xác.");
                            window.history.back();
                        </script>
                    </body>
                    </html>
                `);
            }
        });
        return;
    }

    // 4. ROUTE: Bảng điều khiển Ban tổ chức (gdTrangQuanLiGiaiCoVua.jsp)
    if (pathname === '/gdTrangQuanLiGiaiCoVua.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`
                <script>
                    alert("Bạn chưa đăng nhập! Vui lòng đăng nhập trước khi vào khu vực quản trị.");
                    window.location.href = "/gdLogin.jsp";
                </script>
            `);
        }

        const bodyContent = `
            <div class="py-12 flex items-center justify-center">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 w-full max-w-5xl">
                    
                    <!-- Card 1: Quản lí thông tin giải đấu -->
                    <a href="/module1/gdTimKiemGiaiDau.jsp" class="group bg-white border border-slate-200 hover:border-blue-500 rounded-2xl p-8 sm:p-10 text-center flex flex-col items-center justify-center shadow-sm hover:shadow-md transition">
                        <div class="w-16 h-16 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-105 transition">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 group-hover:text-blue-600 mb-2 transition">Quản lí thông tin giải đấu</h3>
                        <p class="text-sm text-slate-500">
                            Thêm, sửa, xóa các giải đấu
                        </p>
                    </a>

                    <!-- Card 2: Cập nhật kết quả vòng đấu (Điều hướng sang tìm kiếm giải đấu của Module 2) -->
                    <a href="/module2/gdTimKiemGiaiDau.jsp" class="group bg-white border border-slate-200 hover:border-blue-500 rounded-2xl p-8 sm:p-10 text-center flex flex-col items-center justify-center shadow-sm hover:shadow-md transition">
                        <div class="w-16 h-16 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-105 transition">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 group-hover:text-blue-600 mb-2 transition">Cập nhật kết quả vòng đấu</h3>
                        <p class="text-sm text-slate-500">
                            Nhập điểm, cập nhật kết quả từng trận
                        </p>
                    </a>

                    <!-- Card 3: Xem bảng xếp hạng -->
                    <div class="bg-white border border-slate-200 rounded-2xl p-8 sm:p-10 text-center flex flex-col items-center justify-center shadow-sm opacity-70 cursor-not-allowed">
                        <div class="w-16 h-16 bg-slate-50 text-slate-400 rounded-2xl flex items-center justify-center mb-5">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-700 mb-2">Xem bảng xếp hạng</h3>
                        <p class="text-sm text-slate-500">
                            Theo dõi BXH kì thủ sau mỗi vòng
                        </p>
                    </div>

                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Bảng điều khiển BTC', currentUser, bodyContent));
    }

    // 5. ROUTE: Module 1 - Tìm kiếm giải đấu (gdTimKiemGiaiDau.jsp)
    if (pathname === '/gdTimKiemGiaiDau.jsp' || pathname === '/module1/gdTimKiemGiaiDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module1') ? '/module1' : '';
        const hasSearched = parsedUrl.query.nam !== undefined && parsedUrl.query.nam.trim() !== '';
        const rawNam = hasSearched ? parsedUrl.query.nam.trim() : '';
        const isNumeric = /^\d+$/.test(rawNam);
        const namQuery = isNumeric ? parseInt(rawNam, 10) : null;
        const filteredGiaiDau = (hasSearched && namQuery !== null) ? DB_GIAI_DAU.filter(g => g.nam === namQuery) : [];

        const tableRowsHtml = filteredGiaiDau.length > 0 
            ? filteredGiaiDau.map(gd => `
                <tr class="hover:bg-slate-50 transition">
                    <td class="px-5 py-4 font-bold text-[#1e3a8a]">${gd.maGD}</td>
                    <td class="px-5 py-4 font-medium text-slate-700">${gd.nam}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.variant}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.muaGiai}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.ngayBatDau.split('-').reverse().join('/')}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.ngayKetThuc.split('-').reverse().join('/')}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.diaDiem}</td>
                    <td class="px-5 py-4">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-slate-200 text-slate-700">
                            ${gd.trangThai}
                        </span>
                    </td>
                    <td class="px-5 py-4 text-center">
                        <div class="flex items-center justify-center gap-2">
                            <a href="${prefix}/gdSuaThongTinGiaiDau.jsp?id=${gd.id}" class="px-3.5 py-1.5 border border-slate-300 text-slate-700 hover:bg-slate-100 rounded-lg text-xs font-semibold shadow-sm transition">
                                Sửa
                            </a>
                            <button onclick="alert('Đã xóa giải đấu ${gd.maGD} thành công!')" class="px-3.5 py-1.5 border border-red-500 text-red-500 hover:bg-red-50 rounded-lg text-xs font-semibold transition">
                                Xóa
                            </button>
                        </div>
                    </td>
                </tr>
            `).join('')
            : `<tr><td colspan="9" class="p-12 text-center text-slate-500 font-medium">Không tìm thấy giải đấu nào phù hợp với từ khóa "${rawNam}".</td></tr>`;

        const bodyContent = `
            <div class="space-y-6">
                <!-- Search Bar with "+ Thêm giải đấu" Button -->
                <div class="flex flex-col sm:flex-row items-center gap-4 w-full">
                    <form action="${prefix}/gdTimKiemGiaiDau.jsp" method="GET" class="flex flex-1 gap-3 w-full">
                        <input type="text" name="nam" value="${hasSearched ? parsedUrl.query.nam : ''}" placeholder="Nhập năm giải đấu (VD: 2024)..." required
                               class="flex-1 px-5 py-3 border border-slate-300 rounded-xl text-base focus:ring-2 focus:ring-blue-500 outline-none bg-white shadow-sm transition">
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold text-base px-8 py-3 rounded-xl shadow-sm transition">
                            Tìm kiếm
                        </button>
                    </form>
                    <button type="button" onclick="alert('Chức năng thêm giải đấu mới');" class="bg-white border-2 border-green-600 text-green-700 hover:bg-green-50 font-bold text-base px-6 py-3 rounded-xl shadow-sm transition whitespace-nowrap">
                        + Thêm giải đấu
                    </button>
                </div>

                ${hasSearched ? `
                    <!-- Result Table (Chỉ hiển thị khi đã tìm kiếm) -->
                    <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden mt-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse text-sm">
                                <thead class="bg-slate-50 text-slate-700 border-b border-slate-200">
                                    <tr>
                                        <th class="px-5 py-4 font-bold text-slate-900">Mã</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Năm</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Variant</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Mùa</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Ngày BĐ</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Ngày KT</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Địa điểm</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Trạng thái</th>
                                        <th class="px-5 py-4 font-bold text-slate-900 text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-200">
                                    ${tableRowsHtml}
                                </tbody>
                            </table>
                        </div>
                    </div>
                ` : ''}
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Tìm kiếm giải đấu', currentUser, bodyContent));
    }

    // 5b. ROUTE: Module 2 - Tìm kiếm giải đấu để cập nhật kết quả (/module2/gdTimKiemGiaiDau.jsp)
    if (pathname === '/module2/gdTimKiemGiaiDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const hasSearched = parsedUrl.query.nam !== undefined && parsedUrl.query.nam.trim() !== '';
        const rawNam = hasSearched ? parsedUrl.query.nam.trim() : '';
        const isNumeric = /^\d+$/.test(rawNam);
        const namQuery = isNumeric ? parseInt(rawNam, 10) : null;
        const filteredGiaiDau = (hasSearched && namQuery !== null) ? DB_GIAI_DAU.filter(g => g.nam === namQuery) : [];

        const tableRowsHtml = filteredGiaiDau.length > 0 
            ? filteredGiaiDau.map(gd => `
                <tr class="hover:bg-slate-50 transition">
                    <td class="px-5 py-4 font-bold text-[#1e3a8a]">${gd.maGD}</td>
                    <td class="px-5 py-4 font-medium text-slate-700">${gd.nam}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.variant}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.muaGiai}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.ngayBatDau.split('-').reverse().join('/')}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.ngayKetThuc.split('-').reverse().join('/')}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.diaDiem}</td>
                    <td class="px-5 py-4">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-slate-200 text-slate-700">
                            ${gd.trangThai}
                        </span>
                    </td>
                    <td class="px-5 py-4 text-center">
                        <a href="/module2/gdChonVongDau.jsp?idGiaiDau=${gd.id}" class="px-4 py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold shadow-sm transition">
                            Chọn
                        </a>
                    </td>
                </tr>
            `).join('')
            : `<tr><td colspan="9" class="p-12 text-center text-slate-500 font-medium">Không tìm thấy giải đấu nào phù hợp với từ khóa "${rawNam}".</td></tr>`;

        const bodyContent = `
            <div class="space-y-6">
                <!-- Search Bar (Không có nút thêm giải đấu vì là phân hệ cập nhật điểm) -->
                <div class="flex items-center gap-4 w-full">
                    <form action="/module2/gdTimKiemGiaiDau.jsp" method="GET" class="flex flex-1 gap-3 w-full">
                        <input type="text" name="nam" value="${hasSearched ? parsedUrl.query.nam : ''}" placeholder="Nhập năm giải đấu (VD: 2026)..." required
                               class="flex-1 px-5 py-3 border border-slate-300 rounded-xl text-base focus:ring-2 focus:ring-blue-500 outline-none bg-white shadow-sm transition">
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold text-base px-8 py-3 rounded-xl shadow-sm transition">
                            Tìm kiếm
                        </button>
                    </form>
                </div>

                ${hasSearched ? `
                    <!-- Result Table (Chỉ hiển thị khi đã tìm kiếm) -->
                    <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden mt-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse text-sm">
                                <thead class="bg-slate-50 text-slate-700 border-b border-slate-200">
                                    <tr>
                                        <th class="px-5 py-4 font-bold text-slate-900">Mã</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Năm</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Variant</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Mùa</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Ngày BĐ</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Ngày KT</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Địa điểm</th>
                                        <th class="px-5 py-4 font-bold text-slate-900">Trạng thái</th>
                                        <th class="px-5 py-4 font-bold text-slate-900 text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-200">
                                    ${tableRowsHtml}
                                </tbody>
                            </table>
                        </div>
                    </div>
                ` : ''}
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Tìm kiếm giải đấu', currentUser, bodyContent));
    }

    // 6. ROUTE: Giao diện sửa thông tin giải đấu (gdSuaThongTinGiaiDau.jsp)
    if (pathname === '/gdSuaThongTinGiaiDau.jsp' || pathname === '/module1/gdSuaThongTinGiaiDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module1') ? '/module1' : '';
        const gdId = parseInt(parsedUrl.query.id) || 5;
        const gd = DB_GIAI_DAU.find(item => item.id === gdId) || DB_GIAI_DAU[1];

        const bodyContent = `
            <div class="max-w-3xl mx-auto my-6">
                <div class="bg-white p-8 rounded-2xl shadow-sm border border-slate-200">
                    <div class="border-b border-slate-200 pb-4 mb-6 flex justify-between items-center">
                        <div>
                            <h2 class="text-2xl font-extrabold text-[#1e3a8a]">Sửa Thông Tin Giải Đấu</h2>
                            <p class="text-xs text-slate-500 mt-1">Mã định danh: <span class="font-mono font-bold text-blue-700">${gd.maGD}</span></p>
                        </div>
                        <a href="${prefix}/gdTimKiemGiaiDau.jsp?nam=${gd.nam}" class="text-xs text-slate-500 hover:text-slate-800 font-medium">
                            ← Hủy quay lại
                        </a>
                    </div>

                    <form action="${prefix}/doCapNhatThongTinGiaiDau.jsp" method="POST" class="space-y-5">
                        <input type="hidden" name="id" value="${gd.id}">
                        
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1.5">Năm tổ chức</label>
                                <input type="number" name="nam" value="${gd.nam}" required
                                       class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1.5">Thể loại (Variant)</label>
                                <input type="text" name="variant" value="${gd.variant}" required
                                       class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1.5">Mùa tổ chức</label>
                                <input type="number" name="muaGiai" value="${gd.muaGiai}" required
                                       class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1.5">Địa điểm tổ chức</label>
                                <input type="text" name="diaDiem" value="${gd.diaDiem}" required
                                       class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1.5">Ngày bắt đầu</label>
                                <input type="date" name="ngayBatDau" value="${gd.ngayBatDau}" required
                                       class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1.5">Ngày kết thúc</label>
                                <input type="date" name="ngayKetThuc" value="${gd.ngayKetThuc}" required
                                       class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-1.5">Mô tả / Ghi chú</label>
                            <textarea name="note" rows="3" class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">${gd.note}</textarea>
                        </div>

                        <div class="flex justify-end gap-3 pt-4 border-t border-slate-100">
                            <a href="${prefix}/gdTimKiemGiaiDau.jsp?nam=${gd.nam}" class="px-5 py-2.5 border border-slate-300 rounded-lg text-sm font-semibold text-slate-700 hover:bg-slate-100 transition">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-bold shadow-sm transition flex items-center gap-2">
                                Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Sửa thông tin giải đấu', currentUser, bodyContent));
    }

    // 7. ROUTE: Xử lý cập nhật giải đấu (doCapNhatThongTinGiaiDau.jsp)
    if ((pathname === '/doCapNhatThongTinGiaiDau.jsp' || pathname === '/module1/doCapNhatThongTinGiaiDau.jsp') && req.method === 'POST') {
        const prefix = pathname.startsWith('/module1') ? '/module1' : '';
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            const data = querystring.parse(body);
            const id = parseInt(data.id);
            const gdIndex = DB_GIAI_DAU.findIndex(g => g.id === id);

            if (gdIndex !== -1) {
                DB_GIAI_DAU[gdIndex].nam = parseInt(data.nam);
                DB_GIAI_DAU[gdIndex].variant = data.variant;
                DB_GIAI_DAU[gdIndex].muaGiai = parseInt(data.muaGiai);
                DB_GIAI_DAU[gdIndex].diaDiem = data.diaDiem;
                DB_GIAI_DAU[gdIndex].ngayBatDau = data.ngayBatDau;
                DB_GIAI_DAU[gdIndex].ngayKetThuc = data.ngayKetThuc;
                DB_GIAI_DAU[gdIndex].note = data.note;
            }

            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"><title>Cập nhật thành công</title></head>
                <body>
                    <script>
                        alert("Sửa thông tin giải đấu thành công!");
                        window.location.href = "${prefix}/gdTimKiemGiaiDau.jsp?nam=" + ${parseInt(data.nam) || 2024};
                    </script>
                </body>
                </html>
            `);
        });
        return;
    }

    // 8. ROUTE: Chọn vòng đấu (gdChonVongDau.jsp)
    if (pathname === '/gdChonVongDau.jsp' || pathname === '/module2/gdChonVongDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module2') ? '/module2' : '';
        const idGiaiDau = parseInt(parsedUrl.query.idGiaiDau) || 12;
        const gd = DB_GIAI_DAU.find(g => g.id === idGiaiDau) || DB_GIAI_DAU[5];
        const rounds = DB_VONG_DAU.filter(v => v.giaiDauId === idGiaiDau);

        const rowsHtml = rounds.map(v => `
            <tr class="hover:bg-slate-50 border-b border-slate-200 transition">
                <td class="px-5 py-4 font-bold text-[#1e3a8a]">Vòng ${v.soVong}</td>
                <td class="px-5 py-4 font-semibold">${v.ngayThiDau}</td>
                <td class="px-5 py-4 font-mono text-xs text-slate-500">${v.thoiGian}</td>
                <td class="px-5 py-4">
                    ${v.trangThai === 'Đang diễn ra' ? 
                        '<span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300"><span class="w-2 h-2 rounded-full bg-emerald-600 animate-pulse"></span>Đang diễn ra</span>' :
                      v.trangThai === 'Chưa bắt đầu' ?
                        '<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 border border-amber-200">Chưa bắt đầu</span>' :
                        '<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600 border border-slate-200">Kết thúc</span>'}
                </td>
                <td class="px-5 py-4 text-center">
                    ${v.trangThai === 'Đang diễn ra' ? 
                        `<a href="${prefix}/gdChonTranDau.jsp?idVongDau=${v.id}" class="px-4 py-1.5 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded-lg shadow-sm hover:shadow transition">Chọn</a>` :
                      v.trangThai === 'Chưa bắt đầu' ?
                        `<button type="button" onclick="alert('Lỗi! Vòng đấu chưa diễn ra.');" class="px-4 py-1.5 bg-slate-200 text-slate-500 font-semibold text-xs rounded-lg transition">Chọn</button>` :
                        `<a href="${prefix}/gdChonTranDau.jsp?idVongDau=${v.id}" class="px-4 py-1.5 border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold text-xs rounded-lg transition">Chọn</a>`}
                </td>
            </tr>
        `).join('');

        const bodyContent = `
            <div class="space-y-6">
                <div class="pb-2 border-b border-slate-200">
                    <h1 class="text-2xl font-extrabold text-[#1e3a8a]">Chọn Vòng Đấu Cần Nhập Điểm</h1>
                    <p class="text-xs text-slate-500 mt-0.5">
                        Giải đấu: <b class="text-slate-800">${gd.variant} ${gd.nam} (Mùa ${gd.muaGiai})</b> • Địa điểm: ${gd.diaDiem}
                    </p>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                    <div class="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                        <h2 class="font-bold text-slate-800 text-sm">Danh Sách Các Vòng Đấu Của Giải</h2>
                        <span class="text-xs text-slate-500">Tổng cộng: <b>${rounds.length}</b> vòng đấu</span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead class="bg-slate-100 text-slate-700 border-b border-slate-200 text-xs uppercase font-semibold">
                                <tr>
                                    <th class="px-5 py-4">Vòng đấu</th>
                                    <th class="px-5 py-4">Ngày thi đấu</th>
                                    <th class="px-5 py-4">Thời gian</th>
                                    <th class="px-5 py-4">Trạng thái</th>
                                    <th class="px-5 py-4 text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>${rowsHtml}</tbody>
                        </table>
                    </div>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Chọn Vòng Đấu', currentUser, bodyContent));
    }

    // 9. ROUTE: Chọn trận đấu (gdChonTranDau.jsp)
    if (pathname === '/gdChonTranDau.jsp' || pathname === '/module2/gdChonTranDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module2') ? '/module2' : '';
        const idVongDau = parseInt(parsedUrl.query.idVongDau) || 105;
        const vd = DB_VONG_DAU.find(v => v.id === idVongDau) || DB_VONG_DAU[4];
        currentUser.vongDau = vd; // Nạp và lưu thực thể VongDau vừa chọn vào session
        
        const hasSearched = parsedUrl.query.txtBanDau !== undefined && parsedUrl.query.txtBanDau.trim() !== '';
        const queryBan = hasSearched ? parsedUrl.query.txtBanDau.trim() : '';

        // Khi vừa vào chưa tìm thì không hiện trận đấu nào (khớp kịch bản tài liệu)
        const filteredMatches = hasSearched ? DB_TRAN_DAU.filter(td => {
            if (td.vongDauId !== idVongDau) return false;
            const matchBan = td.soBan.toLowerCase().includes(queryBan.toLowerCase());
            const matchMaBan = td.maBan ? td.maBan.toLowerCase().includes(queryBan.toLowerCase()) : false;
            const matchId = String(td.id).includes(queryBan);
            const match01 = queryBan === '01' && (td.id === 1101 || td.soBan.includes('11') || td.soBan.includes('01'));
            return matchBan || matchMaBan || matchId || match01;
        }) : [];

        const rowsHtml = filteredMatches.map(td => `
            <tr class="hover:bg-slate-50 border-b border-slate-200 transition">
                <td class="px-5 py-4 font-mono font-bold text-[#1e3a8a]">TD${td.id}</td>
                <td class="px-5 py-4">
                    <span class="inline-flex items-center px-3 py-1 rounded-lg text-xs font-bold bg-blue-50 text-blue-800 border border-blue-200">${td.soBan}</span>
                </td>
                <td class="px-5 py-4 font-mono font-bold text-slate-800">KT${String(td.p1.id % 100).padStart(3, '0')}</td>
                <td class="px-5 py-4 font-mono font-bold text-slate-800">KT${String(td.p2.id % 100).padStart(3, '0')}</td>
                <td class="px-5 py-4">
                    ${td.trangThai === 'Đang diễn ra' ? 
                        '<span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800"><span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>Đang diễn ra</span>' :
                        '<span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">Đã kết thúc</span>'}
                </td>
                <td class="px-5 py-4 text-center">
                    <a href="${prefix}/gdChiTietTranDau.jsp?idTranDau=${td.id}" class="px-4 py-1.5 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded-lg shadow-sm hover:shadow transition">
                        Chọn
                    </a>
                </td>
            </tr>
        `).join('');

        const bodyContent = `
            <div class="space-y-6">
                <div class="pb-2 border-b border-slate-200">
                    <h1 class="text-2xl font-extrabold text-[#1e3a8a]">Danh Sách Trận Đấu - Vòng ${vd.soVong}</h1>
                </div>

                <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200">
                    <form action="${prefix}/gdChonTranDau.jsp" method="GET" class="flex flex-col sm:flex-row items-center gap-3">
                        <input type="hidden" name="idVongDau" value="${idVongDau}">
                        <div class="relative flex-1 w-full">
                            <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                            </span>
                            <input type="text" name="txtBanDau" value="${queryBan}" placeholder="Nhập bàn của trận đấu..."
                                   class="w-full pl-10 pr-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                        </div>
                        <button type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-sm font-bold rounded-xl shadow-sm transition whitespace-nowrap">Tìm kiếm</button>
                    </form>
                </div>

                ${hasSearched ? `
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                        <div class="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                            <h2 class="font-bold text-slate-800 text-sm">Kết Quả Tìm Kiếm: ${filteredMatches.length} trận đấu</h2>
                            <span class="text-xs bg-blue-100 text-blue-800 px-2.5 py-0.5 rounded-full font-medium">Lọc theo: "${queryBan}"</span>
                        </div>
                        ${filteredMatches.length === 0 ? `
                            <div class="p-12 text-center">
                                <div class="w-12 h-12 mx-auto mb-3 text-slate-400">
                                    <svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                </div>
                                <h3 class="text-base font-bold text-slate-700">Không tìm thấy trận đấu nào trên bàn "${queryBan}"</h3>
                            </div>
                        ` : `
                            <div class="overflow-x-auto">
                                <table class="w-full text-left border-collapse text-sm">
                                    <thead class="bg-slate-100 text-slate-700 border-b border-slate-200 text-xs uppercase font-semibold">
                                        <tr>
                                            <th class="px-5 py-4">Mã trận</th>
                                            <th class="px-5 py-4">Bàn đấu</th>
                                            <th class="px-5 py-4">Mã kỳ thủ 1</th>
                                            <th class="px-5 py-4">Mã kỳ thủ 2</th>
                                            <th class="px-5 py-4">Trạng thái</th>
                                            <th class="px-5 py-4 text-center">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>${rowsHtml}</tbody>
                                </table>
                            </div>
                        `}
                    </div>
                ` : ''}
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Chọn Trận Đấu', currentUser, bodyContent));
    }

    // 10. ROUTE: Chi tiết trận đấu (gdChiTietTranDau.jsp)
    if (pathname === '/gdChiTietTranDau.jsp' || pathname === '/module2/gdChiTietTranDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module2') ? '/module2' : '';
        const idTranDau = parseInt(parsedUrl.query.idTranDau) || 1101;
        const td = DB_TRAN_DAU.find(t => t.id === idTranDau) || DB_TRAN_DAU[0];

        const bodyContent = `
            <div class="max-w-5xl mx-auto relative">
                <div class="mb-8 flex items-center justify-between">
                    <a href="${prefix}/gdChonTranDau.jsp?idVongDau=${td.vongDauId}" class="inline-flex items-center gap-2 px-4 py-2 border border-slate-300 bg-white rounded-xl text-xs font-bold text-slate-700 hover:bg-slate-100 transition shadow-sm">
                        <span>←</span> Quay lại
                    </a>
                    <div class="inline-flex items-center gap-2 bg-blue-100 text-blue-900 text-xs px-3.5 py-1.5 rounded-full font-bold">
                        Trận đấu: TD${td.id} • ${td.soBan}
                    </div>
                </div>

                <div class="text-center mb-10">
                    <h1 class="text-3xl font-extrabold text-[#1e3a8a] tracking-tight">Thông Tin Chi Tiết Trận Đấu</h1>
                </div>

                <div class="flex flex-col md:flex-row gap-6 mb-12">
                    <!-- White Piece Card -->
                    <div class="border-l-4 border-blue-500 bg-white shadow-md rounded-2xl p-6 md:p-8 w-full md:w-1/2 flex flex-col justify-between">
                        <div>
                            <div class="flex justify-between items-start mb-4">
                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-blue-50 text-blue-700 border border-blue-200">
                                    <span class="w-2.5 h-2.5 rounded-full border border-blue-400 bg-white inline-block"></span> Quân Trắng
                                </span>
                                <span class="font-mono text-xs text-slate-500 font-bold">ID: KT${String(td.p1.id % 100).padStart(3, '0')}</span>
                            </div>
                            <h2 class="text-2xl font-extrabold text-slate-900 mb-6">${td.p1.name}</h2>
                            <div class="bg-blue-50/60 rounded-xl p-4 border border-blue-100 space-y-3">
                                <div class="flex justify-between items-center text-sm">
                                    <span class="text-slate-600 font-medium">Hệ số Elo hiện tại:</span>
                                    <span class="font-bold text-lg text-blue-900 font-mono">${Number(td.p1.elo).toFixed(1)}</span>
                                </div>
                                <div class="flex justify-between items-center text-sm pt-2 border-t border-blue-200/60">
                                    <span class="text-slate-600 font-medium">Kỳ vọng thắng FIDE (E):</span>
                                    <span class="font-extrabold text-base text-blue-700 font-mono">${td.p1.expected.toFixed(2)} <span class="text-xs text-blue-500 font-normal">(${Math.round(td.p1.expected * 100)}%)</span></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Black Piece Card -->
                    <div class="border-l-4 border-gray-800 bg-white shadow-md rounded-2xl p-6 md:p-8 w-full md:w-1/2 flex flex-col justify-between">
                        <div>
                            <div class="flex justify-between items-start mb-4">
                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-gray-100 text-gray-800 border border-gray-300">
                                    <span class="w-2.5 h-2.5 rounded-full bg-slate-900 inline-block"></span> Quân Đen
                                </span>
                                <span class="font-mono text-xs text-slate-500 font-bold">ID: KT${String(td.p2.id % 100).padStart(3, '0')}</span>
                            </div>
                            <h2 class="text-2xl font-extrabold text-slate-900 mb-6">${td.p2.name}</h2>
                            <div class="bg-slate-100 rounded-xl p-4 border border-slate-200 space-y-3">
                                <div class="flex justify-between items-center text-sm">
                                    <span class="text-slate-600 font-medium">Hệ số Elo hiện tại:</span>
                                    <span class="font-bold text-lg text-slate-900 font-mono">${Number(td.p2.elo).toFixed(1)}</span>
                                </div>
                                <div class="flex justify-between items-center text-sm pt-2 border-t border-slate-200">
                                    <span class="text-slate-600 font-medium">Kỳ vọng thắng FIDE (E):</span>
                                    <span class="font-extrabold text-base text-gray-800 font-mono">${td.p2.expected.toFixed(2)} <span class="text-xs text-slate-500 font-normal">(${Math.round(td.p2.expected * 100)}%)</span></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Big Primary Button at bottom center -->
                <div class="flex justify-center">
                    <a href="${prefix}/gdNhapKetQua.jsp?idTranDau=${td.id}" class="whitespace-nowrap px-10 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold text-base rounded-2xl shadow-lg hover:shadow-xl transition flex items-center gap-2">
                        <span>Nhập kết quả</span>
                    </a>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Chi tiết trận đấu', currentUser, bodyContent));
    }

    // 11. ROUTE: Nhập kết quả (gdNhapKetQua.jsp)
    if (pathname === '/gdNhapKetQua.jsp' || pathname === '/module2/gdNhapKetQua.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module2') ? '/module2' : '';
        const idTranDau = parseInt(parsedUrl.query.idTranDau) || 1101;
        const td = DB_TRAN_DAU.find(t => t.id === idTranDau) || DB_TRAN_DAU[0];

        const bodyContent = `
            <div class="max-w-2xl w-full mx-auto px-4 py-8">
                <div class="bg-white rounded-3xl shadow-xl border border-slate-200 p-8 sm:p-10">
                    <div class="border-b border-slate-200 pb-5 mb-8 flex justify-between items-center">
                        <div>
                            <h1 class="text-2xl font-extrabold text-[#1e3a8a]">Nhập Kết Quả Trận Đấu</h1>
                            <p class="text-xs text-slate-500 mt-1">
                                Mã trận: <b class="text-blue-700 font-mono">TD${td.id}</b> • ${td.soBan}
                            </p>
                        </div>
                    </div>

                    <form action="${prefix}/gdTinhDiem.jsp" method="POST" class="space-y-6" onsubmit="
                        const s1 = parseFloat(document.getElementById('score1').value);
                        const s2 = parseFloat(document.getElementById('score2').value);
                        if (s1 === 1 && s2 === 1) { alert('Lỗi! Hai kỳ thủ không thể cùng thắng (1 - 1).'); return false; }
                        if (s1 === 0 && s2 === 0) { alert('Lỗi! Hai kỳ thủ không thể cùng thua (0 - 0).'); return false; }
                        if (Math.abs((s1 + s2) - 1.0) > 0.01) { alert('Tổng điểm trận đấu phải bằng 1.0!'); return false; }
                        return true;
                    ">
                        <input type="hidden" name="idTranDau" value="${td.id}">

                        <!-- Row 1: White Player -->
                        <div class="bg-slate-50 p-5 rounded-2xl border border-slate-200 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <span class="w-3.5 h-3.5 rounded-full border border-blue-400 bg-white inline-block"></span>
                                <div>
                                    <span class="text-xs font-bold text-blue-600 uppercase block">Quân Trắng</span>
                                    <span class="font-extrabold text-sm text-slate-900">${td.p1.name}</span>
                                </div>
                            </div>
                            <select name="score1" id="score1" onchange="document.getElementById('score2').value = (this.value == '1.0' ? '0.0' : (this.value == '0.5' ? '0.5' : '1.0'));"
                                    class="border-2 border-blue-500 bg-blue-50 font-bold text-blue-900 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500 shadow-inner">
                                <option value="1.0" selected>1.0 (Thắng)</option>
                                <option value="0.5">0.5 (Hòa)</option>
                                <option value="0.0">0.0 (Thua)</option>
                            </select>
                        </div>

                        <!-- Row 2: Black Player -->
                        <div class="bg-slate-50 p-5 rounded-2xl border border-slate-200 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <span class="w-3.5 h-3.5 rounded-full bg-slate-900 inline-block"></span>
                                <div>
                                    <span class="text-xs font-bold text-slate-400 uppercase block">Quân Đen</span>
                                    <span class="font-extrabold text-sm text-slate-900">${td.p2.name}</span>
                                </div>
                            </div>
                            <select name="score2" id="score2"
                                    class="border-2 border-blue-400 bg-blue-50 font-bold text-slate-900 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500 shadow-inner">
                                <option value="0.0" selected>0.0 (Thua)</option>
                                <option value="0.5">0.5 (Hòa)</option>
                                <option value="1.0">1.0 (Thắng)</option>
                            </select>
                        </div>

                        <!-- Bottom action row: 'Hủy' and 'Tính Điểm' -->
                        <div class="pt-4 flex items-center gap-3">
                            <a href="${prefix}/gdChiTietTranDau.jsp?idTranDau=${td.id}" class="w-1/3 py-3 px-4 border border-slate-300 text-slate-700 rounded-xl hover:bg-slate-100 text-sm font-semibold transition text-center shadow-sm">Hủy</a>
                            <button type="submit" class="w-2/3 py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-bold transition shadow-md hover:shadow-lg flex items-center justify-center gap-2">
                                <span>Tính điểm</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Nhập Kết Quả', currentUser, bodyContent));
    }

    // 12. ROUTE: Xác nhận Elo (gdTinhDiem.jsp)
    if (pathname === '/gdTinhDiem.jsp' || pathname === '/module2/gdTinhDiem.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const prefix = pathname.startsWith('/module2') ? '/module2' : '';
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            const postData = querystring.parse(body);
            const idTranDau = parseInt(postData.idTranDau) || 1101;
            const td = DB_TRAN_DAU.find(t => t.id === idTranDau) || DB_TRAN_DAU[0];

            const s1 = parseFloat(postData.score1) || 1.0;
            const s2 = parseFloat(postData.score2) || 0.0;

            const k = 10;
            const deltaElo1 = k * (s1 - td.p1.expected);
            const deltaElo2 = k * (s2 - td.p2.expected);

            const elo1New = (td.p1.elo + deltaElo1).toFixed(1);
            const elo2New = (td.p2.elo + deltaElo2).toFixed(1);

            const bodyContent = `
                <div class="max-w-2xl w-full mx-auto px-4 py-8">
                    <div class="bg-gradient-to-br from-emerald-50 via-teal-50/40 to-white rounded-3xl shadow-xl border-2 border-emerald-500/40 p-8 sm:p-10 relative overflow-hidden">
                        
                        <div class="border-b border-emerald-200 pb-5 mb-8 flex justify-between items-center relative z-10">
                            <div>
                                <span class="text-[11px] font-extrabold text-emerald-800 uppercase tracking-wider block">Tính Toán Điểm Số Thành Công</span>
                                <h1 class="text-2xl font-black text-slate-900 mt-0.5">Xác Nhận Kết Quả Trận Đấu</h1>
                            </div>
                            <div class="text-right">
                                <span class="text-xs font-bold text-slate-400 block">Mã trận</span>
                                <span class="font-mono font-black text-base text-emerald-800">TD${td.id}</span>
                            </div>
                        </div>

                        <div class="space-y-4 mb-8 relative z-10">
                            <div class="bg-white/90 backdrop-blur-sm p-5 rounded-2xl border border-emerald-200 shadow-sm flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <span class="w-3.5 h-3.5 rounded-full border border-blue-400 bg-white inline-block"></span>
                                    <div>
                                        <span class="text-xs font-bold text-blue-600 uppercase block">Quân Trắng</span>
                                        <span class="font-extrabold text-base text-slate-900">${td.p1.name}</span>
                                        <span class="text-xs text-slate-500 block">Điểm ván đấu: <b class="text-slate-800 font-mono">${s1.toFixed(1)}</b></span>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <div class="font-mono font-bold text-sm text-slate-600">
                                        ${Number(td.p1.elo).toFixed(1)} → <span class="text-emerald-700 font-extrabold text-base">${elo1New}</span>
                                    </div>
                                    <span class="inline-flex items-center gap-1 font-mono font-extrabold text-xs ${deltaElo1 >= 0 ? 'text-emerald-700 bg-emerald-100' : 'text-rose-700 bg-rose-100'} px-2 py-0.5 rounded-full mt-1">
                                        ${deltaElo1 >= 0 ? '+' + deltaElo1.toFixed(1) : deltaElo1.toFixed(1)} ELO
                                    </span>
                                </div>
                            </div>

                            <div class="bg-white/90 backdrop-blur-sm p-5 rounded-2xl border border-emerald-200 shadow-sm flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <span class="w-3.5 h-3.5 rounded-full bg-slate-900 inline-block"></span>
                                    <div>
                                        <span class="text-xs font-bold text-slate-500 uppercase block">Quân Đen</span>
                                        <span class="font-extrabold text-base text-slate-900">${td.p2.name}</span>
                                        <span class="text-xs text-slate-500 block">Điểm ván đấu: <b class="text-slate-800 font-mono">${s2.toFixed(1)}</b></span>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <div class="font-mono font-bold text-sm text-slate-600">
                                        ${Number(td.p2.elo).toFixed(1)} → <span class="text-emerald-700 font-extrabold text-base">${elo2New}</span>
                                    </div>
                                    <span class="inline-flex items-center gap-1 font-mono font-extrabold text-xs ${deltaElo2 >= 0 ? 'text-emerald-700 bg-emerald-100' : 'text-rose-700 bg-rose-100'} px-2 py-0.5 rounded-full mt-1">
                                        ${deltaElo2 >= 0 ? '+' + deltaElo2.toFixed(1) : deltaElo2.toFixed(1)} ELO
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Form Submit to doLuuKetQua.jsp with 'Lưu kết quả' button -->
                        <form action="${prefix}/doLuuKetQua.jsp" method="POST" class="relative z-10 space-y-3">
                            <input type="hidden" name="idTranDau" value="${td.id}">
                            <input type="hidden" name="score1" value="${s1}">
                            <input type="hidden" name="score2" value="${s2}">
                            <input type="hidden" name="deltaElo1" value="${deltaElo1}">
                            <input type="hidden" name="deltaElo2" value="${deltaElo2}">
                            <input type="hidden" name="idVongDau" value="${td.vongDauId}">

                            <button type="submit" class="w-full py-4 px-6 bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-base rounded-xl shadow-lg hover:shadow-xl transition flex items-center justify-center gap-2">
                                <span>Lưu kết quả</span>
                            </button>
                            <a href="${prefix}/gdNhapKetQua.jsp?idTranDau=${td.id}" class="w-full block py-2.5 text-center text-xs font-semibold text-slate-600 hover:text-slate-900 transition">← Sửa lại điểm số</a>
                        </form>
                    </div>
                </div>
            `;
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(renderFullPage('Xác Nhận Kết Quả Trận Đấu', currentUser, bodyContent));
        });
        return;
    }

    // 13. ROUTE: Lưu kết quả (doLuuKetQua.jsp)
    if ((pathname === '/doLuuKetQua.jsp' || pathname === '/module2/doLuuKetQua.jsp') && req.method === 'POST') {
        const prefix = pathname.startsWith('/module2') ? '/module2' : '';
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            const postData = querystring.parse(body);
            const idTranDau = parseInt(postData.idTranDau) || 1101;
            const s1 = parseFloat(postData.score1) || 1.0;
            const s2 = parseFloat(postData.score2) || 0.0;
            const d1 = parseFloat(postData.deltaElo1) || 0.0;
            const d2 = parseFloat(postData.deltaElo2) || 0.0;
            const idVongDau = parseInt(postData.idVongDau) || 105;

            const tdIndex = DB_TRAN_DAU.findIndex(t => t.id === idTranDau);
            if (tdIndex !== -1) {
                DB_TRAN_DAU[tdIndex].trangThai = 'Kết thúc';
                DB_TRAN_DAU[tdIndex].p1.score = s1;
                DB_TRAN_DAU[tdIndex].p2.score = s2;
                DB_TRAN_DAU[tdIndex].p1.deltaElo = d1;
                DB_TRAN_DAU[tdIndex].p2.deltaElo = d2;
                DB_TRAN_DAU[tdIndex].p1.elo = parseFloat((DB_TRAN_DAU[tdIndex].p1.elo + d1).toFixed(1));
                DB_TRAN_DAU[tdIndex].p2.elo = parseFloat((DB_TRAN_DAU[tdIndex].p2.elo + d2).toFixed(1));
            }

            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`
                <!DOCTYPE html>
                <html>
                <head><meta charset="UTF-8"><title>Lưu kết quả thành công</title></head>
                <body>
                    <script>
                        alert("Cập nhật kết quả trận đấu thành công!");
                        window.location.href = "${prefix}/gdChonTranDau.jsp?idVongDau=" + ${idVongDau};
                    </script>
                </body>
                </html>
            `);
        });
        return;
    }

    // 14. ROUTE: Đăng xuất (/logout)
    if (pathname === '/logout') {
        if (sessionId && sessions[sessionId]) {
            delete sessions[sessionId];
        }
        res.writeHead(302, {
            'Set-Cookie': 'sessionId=; HttpOnly; Path=/; Max-Age=0',
            'Location': '/gdCoBan.jsp'
        });
        return res.end();
    }

    // 404
    res.writeHead(404, { 'Content-Type': 'text/plain; charset=UTF-8' });
    res.end('404 Not Found');
});

if (require.main === module) {
    server.listen(PORT, () => {
        console.log(`====================================================================`);
        console.log(`[ENTERPRISE SERVER READY] Dang lang nghe tai: http://localhost:${PORT}`);
        console.log(`- Full-width Web Application • Khong khung fake • Professional SVG Icons`);
        console.log(`- Trang chu co ban  : http://localhost:${PORT}/gdCoBan.jsp`);
        console.log(`- Trang dang nhap   : http://localhost:${PORT}/gdLogin.jsp`);
        console.log(`- M1: Quan ly giai dau  : http://localhost:${PORT}/gdTimKiemGiaiDau.jsp`);
        console.log(`- M2: Cap nhat ket qua  : http://localhost:${PORT}/gdChonVongDau.jsp?idGiaiDau=12`);
        console.log(`- Test ban dau ("11")   : http://localhost:${PORT}/gdChonTranDau.jsp?idVongDau=105&txtBanDau=11`);
        console.log(`- Tai khoan test        : btc1 / mk123@  (hoac admin / admin123)`);
        console.log(`====================================================================`);
    });
}

module.exports = server;
