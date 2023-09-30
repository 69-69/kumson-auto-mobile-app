class BaseAPI {
// more routes
  Map<String, String> apiEndpoints = {
    "vehicles": "/api/v1/auto/vehicles",
    "parts": "/api/v1/auto/parts",
    "make": "/api/v1/auto/make",
    "model": "/api/v1/auto/model"
  };

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzb2NpYWxtYWlsMDI2QGdtYWlsLmNvbSIsImlhdCI6MTY5NTU3MjIxNCwiZXhwIjoxNjk2MTc3MDE0fQ.KSZAgMiQSigY2oSPznNrNN16POxRY-LBEeF2aHKWDEc",
  };

  Map<String, String> postHeader = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
  };

  Map<String, String> requestHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8",
    'Cache-Control': 'private, max-age=120'
  };

  String url(String s) => "http://localhost:8080$s";
}
