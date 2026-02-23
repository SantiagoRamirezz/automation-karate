Feature: Create user

  Background:
    * url baseUrl

  @CRE001
  Scenario: Create user - returns 201 and id
    * def randomEmail = 'santiago' + java.util.UUID.randomUUID() + '@test.com'

    Given path 'users'
    And request
    """
    {
      "name": "Santiago QA",
      "gender": "male",
      "email": "#(randomEmail)",
      "status": "active"
    }
    """
    When method POST
    Then status 201

    * def result =
    """
    {
      id: #(response.id),
      email: #(randomEmail)
    }
    """

    * karate.set('result', result)