function fn() {
  var config = {};
  config.baseUrl = 'https://gorest.co.in/public/v2';
  var token = karate.properties['API_TOKEN']
              || java.lang.System.getenv('API_TOKEN')
              || 'TOKEN_DE_PRUEBA';
  print('ENV TOKEN:', token);
  config.token = token;
  var authHeader = 'Bearer ' + config.token;
  karate.configure('headers', { Authorization: authHeader, 'Content-Type': 'application/json' });
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  return config;
}