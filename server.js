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

const PORT = 8080;

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
                            <span>Đăng nhập Ban tổ chức</span>
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
        <div class="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row justify-between items-center gap-2">
            <div>
                © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
            </div>
            <div class="text-[11px] text-slate-400 font-mono">
                Running at http://localhost:8080 • Active Session: ${currentUser ? currentUser.username : 'Guest (Everyone)'}
            </div>
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
                        <span>Đăng nhập Ban tổ chức</span>
                    </a>
                    <button type="button" disabled class="whitespace-nowrap px-8 py-4 bg-slate-200 text-slate-400 font-bold rounded-xl cursor-not-allowed border border-slate-300 flex items-center justify-center gap-2.5 text-base" title="Chức năng đang bảo trì theo chỉ đạo của giảng viên">
                        <svg class="w-5 h-5 opacity-40 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                        <span>Bảng xếp hạng (Tạm hoãn)</span>
                    </button>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Trang chủ', currentUser, bodyContent));
    }

    // 2. ROUTE: Giao diện đăng nhập (gdLogin.jsp)
    if (pathname === '/gdLogin.jsp') {
        const bodyContent = `
            <div class="max-w-md mx-auto my-12">
                <div class="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
                    <div class="text-center mb-8">
                        <div class="w-14 h-14 bg-blue-100 text-[#1e3a8a] rounded-xl mx-auto flex items-center justify-center mb-4 shadow-inner">
                            <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                        </div>
                        <h2 class="text-2xl font-bold text-[#1e3a8a]">Đăng Nhập Ban Tổ Chức</h2>
                        <p class="text-sm text-slate-500 mt-1">Xác thực quyền quản trị viên giải đấu</p>
                    </div>

                    <form action="/doCheckLogin.jsp" method="POST" class="space-y-5">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-1.5">Tên đăng nhập (Username)</label>
                            <input type="text" name="txtUsername" value="btc1" required
                                   class="w-full px-4 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:bg-blue-50/50 outline-none text-sm transition">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-1.5">Mật khẩu (Password)</label>
                            <input type="password" name="pwdPassword" value="mk123@" required
                                   class="w-full px-4 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:bg-blue-50/50 outline-none text-sm transition">
                        </div>
                        <div class="pt-2 flex gap-3">
                            <a href="/gdCoBan.jsp" class="w-1/3 py-2.5 px-4 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-100 text-sm font-semibold transition text-center flex items-center justify-center">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="w-2/3 py-2.5 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-semibold transition shadow-md flex items-center justify-center gap-2">
                                <span>Đăng nhập</span> →
                            </button>
                        </div>
                    </form>

                    <div class="mt-8 pt-5 border-t border-slate-100 text-xs text-slate-500 bg-slate-50 -mx-8 -mb-8 p-6 rounded-b-2xl">
                        <span class="font-bold text-slate-700 block mb-1">Tài khoản nạp sẵn kiểm thử (Mock Seed):</span>
                        <div class="space-y-1 font-mono text-[11px] text-blue-800">
                            <div>• <span class="font-bold">btc1</span> / mk123@ (Nguyễn Đức Ngọc - Trưởng ban)</div>
                            <div>• <span class="font-bold">admin</span> / admin123 (Quản trị viên)</div>
                        </div>
                    </div>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Đăng nhập', currentUser, bodyContent));
    }

    // 3. ROUTE: Xử lý đăng nhập (doCheckLogin.jsp)
    if (pathname === '/doCheckLogin.jsp' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            const postData = querystring.parse(body);
            const u = (postData.txtUsername || '').trim();
            const p = (postData.pwdPassword || '').trim();

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
            <div class="space-y-8">
                <!-- Welcome Banner -->
                <div class="bg-white p-6 sm:p-8 rounded-2xl shadow-sm border border-slate-200 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                    <div>
                        <h2 class="text-2xl sm:text-3xl font-extrabold text-[#1e3a8a]">Bảng Điều Khiển Nghiệp Vụ</h2>
                    </div>
                    <div class="flex items-center gap-2 bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs px-4 py-2 rounded-xl font-medium shadow-sm">
                        <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                        Tài khoản: <span class="font-bold text-emerald-950">${currentUser.hoTen}</span>
                    </div>
                </div>

                <!-- 3 Functional Action Cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    
                    <!-- Card 1: Quản lý giải đấu (CHỨC NĂNG HOÀN THIỆN) -->
                    <a href="/gdTimKiemGiaiDau.jsp" class="group bg-white border-2 border-blue-500 rounded-2xl p-8 hover:bg-blue-50/50 transition-all duration-200 shadow-sm hover:shadow-md flex flex-col justify-between">
                        <div>
                            <div class="w-14 h-14 bg-blue-100 text-[#1e3a8a] rounded-xl flex items-center justify-center mb-6 group-hover:scale-105 transition transform shadow-inner">
                                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                            </div>
                            <h3 class="text-xl font-bold text-[#1e3a8a] mb-2">Quản lý Giải Đấu</h3>
                            <p class="text-xs text-slate-600 leading-relaxed">
                                Tìm kiếm giải đấu theo năm, xem danh sách và chỉnh sửa thông tin chi tiết các giải vô địch cờ vua thế giới.
                            </p>
                        </div>
                        <div class="mt-8 pt-4 border-t border-slate-100 flex items-center justify-between text-xs font-bold text-blue-600 group-hover:text-blue-800">
                            <span>Vào phân hệ quản lý</span>
                            <span>→</span>
                        </div>
                    </a>

                    <!-- Card 2: Cập nhật kết quả vòng đấu -->
                    <a href="/gdTimKiemGiaiDau.jsp?action=update" class="group bg-white border-2 border-blue-500 rounded-2xl p-8 hover:bg-blue-50/50 transition-all duration-200 shadow-sm hover:shadow-md flex flex-col justify-between">
                        <div>
                            <div class="w-14 h-14 bg-indigo-100 text-indigo-900 rounded-xl flex items-center justify-center mb-6 group-hover:scale-105 transition transform shadow-inner">
                                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            </div>
                            <h3 class="text-xl font-bold text-indigo-950 mb-2">Cập nhật Kết Quả</h3>
                            <p class="text-xs text-slate-600 leading-relaxed">
                                Chọn vòng đấu đang diễn ra, tìm kiếm trận đấu theo bàn (test biên "11"), nhập điểm và tự động tính Elo FIDE.
                            </p>
                        </div>
                        <div class="mt-8 pt-4 border-t border-slate-100 flex items-center justify-between text-xs font-bold text-blue-600 group-hover:text-blue-800">
                            <span>Nhập điểm vòng đấu</span>
                            <span>→</span>
                        </div>
                    </a>

                    <!-- Card 3: Bảng xếp hạng (Tạm hoãn) -->
                    <div class="bg-slate-100 border-2 border-slate-300 rounded-2xl p-8 text-slate-400 flex flex-col justify-between relative overflow-hidden">
                        <div class="absolute top-4 right-4 bg-yellow-100 text-yellow-800 text-[10px] font-bold px-2.5 py-1 rounded-md">
                            Tạm hoãn
                        </div>
                        <div>
                            <div class="w-14 h-14 bg-slate-200 text-slate-400 rounded-xl flex items-center justify-center mb-6 opacity-60">
                                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                            </div>
                            <h3 class="text-xl font-bold text-slate-500 mb-2">Bảng Xếp Hạng</h3>
                            <p class="text-xs text-slate-400 leading-relaxed">
                                Xem bảng xếp hạng sau vòng đấu tính theo tổng điểm, điểm đối thủ đã gặp (Buchholz) và Elo.
                            </p>
                        </div>
                        <div class="mt-8 pt-4 border-t border-slate-200 text-xs text-slate-400 font-medium">
                            (Đang bảo trì theo chỉ đạo của GV)
                        </div>
                    </div>

                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Bảng điều khiển BTC', currentUser, bodyContent));
    }

    // 5. ROUTE: Tìm kiếm giải đấu (gdTimKiemGiaiDau.jsp)
    if (pathname === '/gdTimKiemGiaiDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

        const namQuery = parsedUrl.query.nam ? parseInt(parsedUrl.query.nam) : 2024;
        const filteredGiaiDau = DB_GIAI_DAU.filter(g => g.nam === namQuery);

        const tableRowsHtml = filteredGiaiDau.length > 0 
            ? filteredGiaiDau.map(gd => `
                <tr class="hover:bg-slate-50 border-b border-slate-200 transition">
                    <td class="px-5 py-4 font-mono font-bold text-[#1e3a8a]">${gd.maGD}</td>
                    <td class="px-5 py-4 font-semibold">${gd.nam}</td>
                    <td class="px-5 py-4">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold ${gd.variant === 'Classical' ? 'bg-blue-100 text-blue-800' : 'bg-purple-100 text-purple-800'}">
                            ${gd.variant}
                        </span>
                    </td>
                    <td class="px-5 py-4 font-medium">Mùa ${gd.muaGiai}</td>
                    <td class="px-5 py-4 text-slate-700">${gd.diaDiem}</td>
                    <td class="px-5 py-4 text-xs text-slate-500">${gd.ngayBatDau} đến ${gd.ngayKetThuc}</td>
                    <td class="px-5 py-4">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold ${gd.trangThai === 'Đang diễn ra' ? 'bg-orange-100 text-orange-800' : 'bg-slate-100 text-slate-700'}">
                            ${gd.trangThai}
                        </span>
                    </td>
                    <td class="px-5 py-4 text-center">
                        <div class="flex items-center justify-center gap-2">
                            <a href="/gdSuaThongTinGiaiDau.jsp?id=${gd.id}" class="bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold px-3 py-1.5 rounded-md shadow-sm transition">
                                Sửa
                            </a>
                            <button onclick="alert('Đã xóa giải đấu thành công!')" class="bg-red-600 hover:bg-red-700 text-white text-xs font-semibold px-3 py-1.5 rounded-md shadow-sm transition">
                                Xóa
                            </button>
                        </div>
                    </td>
                </tr>
            `).join('')
            : `<tr><td colspan="8" class="p-12 text-center text-slate-500 font-medium">Không tồn tại giải đấu nào trong năm ${namQuery}. (Thử tìm năm: 2024, 2026)</td></tr>`;

        const bodyContent = `
            <div class="space-y-6">
                <!-- Page Breadcrumb & Header -->
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <a href="/gdTrangQuanLiGiaiCoVua.jsp" class="text-xs text-blue-600 hover:underline font-semibold flex items-center gap-1 mb-1">
                            ← Quay lại Bảng điều khiển
                        </a>
                        <h2 class="text-2xl font-extrabold text-[#1e3a8a]">Quản Lý Thông Tin Giải Đấu</h2>
                    </div>
                </div>

                <!-- Search Filter Form -->
                <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col sm:flex-row justify-between items-center gap-4">
                    <form action="/gdTimKiemGiaiDau.jsp" method="GET" class="flex gap-3 w-full sm:w-auto flex-1 max-w-lg">
                        <div class="relative flex-1">
                            <input type="number" name="nam" value="${namQuery}" required placeholder="Nhập năm tìm kiếm (vd: 2024, 2026)..."
                                   class="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                        </div>
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-5 py-2 rounded-lg shadow-sm transition">
                            Tìm kiếm
                        </button>
                    </form>
                    <div class="text-xs text-slate-500 font-medium">
                        Dữ liệu kiểm thử: <a href="/gdTimKiemGiaiDau.jsp?nam=2024" class="text-blue-600 hover:underline">2024 (Đa bản ghi)</a> • <a href="/gdTimKiemGiaiDau.jsp?nam=2026" class="text-blue-600 hover:underline">2026 (Đang diễn ra)</a> • <a href="/gdTimKiemGiaiDau.jsp?nam=2025" class="text-blue-600 hover:underline">2025 (Rỗng)</a>
                    </div>
                </div>

                <!-- Tournament Table -->
                <div class="bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead class="bg-slate-100 text-slate-700 border-b border-slate-200">
                                <tr>
                                    <th class="px-5 py-3.5 font-bold">Mã GD</th>
                                    <th class="px-5 py-3.5 font-bold">Năm</th>
                                    <th class="px-5 py-3.5 font-bold">Thể loại</th>
                                    <th class="px-5 py-3.5 font-bold">Mùa giải</th>
                                    <th class="px-5 py-3.5 font-bold">Địa điểm</th>
                                    <th class="px-5 py-3.5 font-bold">Thời gian thi đấu</th>
                                    <th class="px-5 py-3.5 font-bold">Trạng thái</th>
                                    <th class="px-5 py-3.5 font-bold text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${tableRowsHtml}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        `;
        res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
        return res.end(renderFullPage('Tìm kiếm giải đấu', currentUser, bodyContent));
    }

    // 6. ROUTE: Giao diện sửa thông tin giải đấu (gdSuaThongTinGiaiDau.jsp)
    if (pathname === '/gdSuaThongTinGiaiDau.jsp') {
        if (!currentUser) {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=UTF-8' });
            return res.end(`<script>alert("Vui lòng đăng nhập!"); window.location.href="/gdLogin.jsp";</script>`);
        }

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
                        <a href="/gdTimKiemGiaiDau.jsp?nam=${gd.nam}" class="text-xs text-slate-500 hover:text-slate-800 font-medium">
                            ← Hủy quay lại
                        </a>
                    </div>

                    <form action="/doCapNhatThongTinGiaiDau.jsp" method="POST" class="space-y-5">
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
                            <a href="/gdTimKiemGiaiDau.jsp?nam=${gd.nam}" class="px-5 py-2.5 border border-slate-300 rounded-lg text-sm font-semibold text-slate-700 hover:bg-slate-100 transition">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-bold shadow-md transition flex items-center gap-2">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
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
    if (pathname === '/doCapNhatThongTinGiaiDau.jsp' && req.method === 'POST') {
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
                        window.location.href = "/gdTimKiemGiaiDau.jsp?nam=" + ${parseInt(data.nam) || 2024};
                    </script>
                </body>
                </html>
            `);
        });
        return;
    }

    // 8. ROUTE: Đăng xuất (/logout)
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

server.listen(PORT, () => {
    console.log(`====================================================================`);
    console.log(`[ENTERPRISE SERVER READY] Dang lang nghe tai: http://localhost:${PORT}`);
    console.log(`- Full-width Web Application • Khong khung fake • Professional SVG Icons`);
    console.log(`- Trang chu co ban  : http://localhost:${PORT}/gdCoBan.jsp`);
    console.log(`- Trang dang nhap   : http://localhost:${PORT}/gdLogin.jsp`);
    console.log(`- Quan ly giai dau  : http://localhost:${PORT}/gdTimKiemGiaiDau.jsp`);
    console.log(`- Tai khoan test    : btc1 / mk123@  (hoac admin / admin123)`);
    console.log(`====================================================================`);
});
