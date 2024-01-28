class ApiResponse {
  Object? data;
  String? error;
  bool unauthorized = false;
}

class SessionResponse {
  bool? isLog;
  bool? asUser;
  // String? error;
  String? token;
}

const unauthorizedMessage = 'Sesi tidak dikenal - Harap login kembali';
const timeoutException = 'Request timeout - Cek koneksi internet Anda';
const socketException = 'Gagal terhubung ke server - Cek koneksi internet Anda';
const serverError = 'Koneksi terputus, mohon coba lagi';
// const serverError = 'Mohon maaf!, server sedang bermasalah';
const somethingWentWrong = 'Koneksi terputus, mohon coba lagi';
