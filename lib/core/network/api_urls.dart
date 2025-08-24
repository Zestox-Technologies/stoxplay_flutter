class ApiUrls {
  ApiUrls._();

  static const String baseUrl = 'https://backend.stoxplay.com/v1/';

  ///Websocket
  static const String wsUrl = "wss://backend.stoxplay.com";

  ///Live Server time
  static const String liveServerTime = 'https://timeapi.io/api/time/current/zone?timeZone=Asia/Kolkata';

  ///Auth Flow APIs
  static const String checkPhone = 'auth/client/check-phone';
  static const String initiateSignUp = 'auth/client/initiate-signup';
  static const String verifyOTP = 'auth/client/verify-otp';
  static const String loginWithOTP = 'auth/client/login-with-otp';
  static const String completeSignUp = 'auth/client/complete-signup';

  ///contest flow
  static const String getSectorList = 'stock-management/sectors?isActive=true';
  static const String getContestStatus = 'client/contest-status';
  static const String getMyContests = 'client/my-contests';

  static getContestList(String sectorId) => 'client/sectors/$sectorId/contests';

  static updateTeam(String teamId) => '/client/teams/$teamId';

  ///Stock List Flow
  static getStocksList(String contestId) => '/client/contests/$contestId/stocks';

  static joinContest(String contestId) => '/client/contests/$contestId/join';
  static const String getProfile = 'users/profile';
  static const String fileUpload = 'files/upload';
  static const String learningContent = 'learning-content';
  static const String getAds = 'ads-management/client';
}
