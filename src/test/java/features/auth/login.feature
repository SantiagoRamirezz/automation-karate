Feature: Login API

  Background:
    * url 'https://reqres.in/api'
    * header Content-Type = 'application/json'
  @login
  Scenario: Login successfully

    Given path '/login'
    And request
"""
{
  "email": "eve.holt@reqres.in",
  "password": "cityslicka"
}
"""
    When method POST
    Then status 200
    And match response.token != null

    * def authToken = response.token
    * print authToken