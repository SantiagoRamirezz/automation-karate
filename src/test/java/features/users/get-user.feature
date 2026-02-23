Feature: Get user

  Background:
    * url baseUrl
    
  @GET001
  Scenario: Get user - returns 200 and user object
    * def userId = __arg.userId

    Given path 'users', userId
    When method GET
    Then status 200

    * karate.set('responseUser', response)
  
  
  @GET002
  Scenario: Validate structure of paginated users
    
    Given path 'users'
    And param per_page = 3
    When method GET
    Then status 200
    
    And match response == '#[3]'
    And match each response ==
        """
        {
          id: '#number',
          name: '#string',
          email: '#string',
          gender: '#string',
          status: '#string'
        }
        """
    
  @GET003
  Scenario: Get 5 users
    Given path 'users'
    And param page = 1
    And param per_page = 5
    When method GET
    Then status 200
    And match response == '#[5]'