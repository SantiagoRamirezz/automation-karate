Feature: Delete user

  Background:
    * url baseUrl

  Scenario:
    * def userId = __arg.userId

    Given path 'users', userId
    When method DELETE
    Then status 204