function fn() {
  var config = {};

  // URL base
  config.baseUrl = 'https://gorest.co.in/public/v2';

    var token = karate.properties['API_TOKEN']
                  || java.lang.System.getenv('API_TOKEN')
                  || 'TOKEN_DE_PRUEBA';

      print('ENV TOKEN:', token);

      config.token = token;

      return config;
}