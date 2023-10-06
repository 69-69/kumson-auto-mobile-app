class BaseAPI {
// more routes
  Map<String, String> apiEndpoints = {
    "vehicles": "/api/v1/auto/vehicles",
    "parts": "/api/v1/auto/parts",
    "hunter": "/api/v1/auto/hunting",
    "make": "/api/v1/auto/make",
    "model": "/api/v1/auto/model",
    "vendor": "/api/v1/auto/vendor"
  };

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzb2NpYWxtYWlsMDI2QGdtYWlsLmNvbSIsImlhdCI6MTY5NjE5MTAzMSwiZXhwIjoxNzAwNDI0NjMxfQ.obqlOwBog4Irj5l_fUkE5AhJgMEYBb1crlPJe9JnWSI",
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
  //"http://ec2-3-82-240-226.compute-1.amazonaws.com$s";

  // http://localhost:8080/path?page=0&size=100&sort=product,desc
  String pagination(int size, String sort) => "?page=0&size=$size&sort=$sort,asc";
}
