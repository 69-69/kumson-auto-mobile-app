class BaseAPI {
// DEV / TEST ROUTES
  Map<String, String> apiEndpointsDev = {
    "vehicles": "/test/runner/2023/k1/auto_cars",
    "parts": "/test/runner/2023/k1/car_parts",
    "hunter": "/test/runner/2023/k1/parts_hunter",
    "make": "/test/runner/2023/k1/car_makes",
    "model": "/test/runner/2023/k1/car_models",
    "vendor": "/test/runner/2023/k1/vendors_parts"
  };
// PROD. ROUTES
  Map<String, String> apiEndpointsProd = {
    "vehicles": "/api/v1/auto/vehicles",
    "parts": "/api/v1/auto/parts",
    "hunter": "/api/v1/auto/hunting",
    "make": "/api/v1/auto/make",
    "model": "/api/v1/auto/model",
    "vendor": "/api/v1/auto/vendor"
  };

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzb2NpYWxtYWlsMDI2QGdtYWlsLmNvbSIsImlhdCI6MTY5NzM5MjM3NiwiZXhwIjoxOTAwNjA1MTc2fQ.9ejPKZSrKIGvTve03oRA-H6hLFC43AJxqlrZSeKC9DU",
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

  // String url(String s) => "http://localhost:8080$s";
  String url(String s) => "http://ec2-18-212-75-251.compute-1.amazonaws.com$s";

  // http://localhost:8080/path?page=0&size=100&sort=product,desc
  String pagination(int size, String sort) => "?page=0&size=$size&sort=$sort,asc";
}
