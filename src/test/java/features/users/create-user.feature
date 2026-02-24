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
  
  @CRE002
  @negative
  Scenario Outline: Create user without required field <missingField>
    * def dynamicEmail = 'qa_' + java.util.UUID.randomUUID() + '@mail.com'
    Given path 'users'
    And request
        """
          {
            "name": <name>,
            "gender": <gender>,
            "email": #(<useEmail> ? dynamicEmail : null),
            "status": <status>
          }
        """
    When method POST
    Then status 422
    And match response == '#[]'
    And match response[0].field == '<expectedField>'
    And match response[0].message contains '<expectedMessage>'
    
    Examples:
      | missingField | name         | gender   | useEmail | status   | expectedField | expectedMessage |
      | name         | null         | 'male'   | true     | 'active' | name          | blank           |
      | gender       | 'Andres QA'  | null     | true     | 'active' | gender        | blank           |
      | email        | 'Andres QA'  | 'male'   | null     | 'active' | email         | blank           |
      | status       | 'Andres QA'  | 'male'   | true     |  null    | status        | blank           |
      | name         | ''           | 'male'   | true     | 'active' | name          | blank           |
      | email        | 'Andres QA'  | 'male'   | ''       | 'active' | email         | blank           |
  
  @CRE003
  @negative
  Scenario: Create user with duplicate email should return 422
    * def randomEmail = 'Usuario123' + java.util.UUID.randomUUID() + '@test.com'
    Given path 'users'
    And request
        """
          {
            "name": "Usuario Base",
            "gender": "male",
            "email": "#(randomEmail)",
            "status": "active"
          }
        """
    When method POST
    Then status 201
    Given path 'users'
    And request
          """
            {
              "name": "Usuario Duplicado",
              "gender": "male",
              "email": "#(randomEmail)",
              "status": "active"
            }
          """
    When method POST
    Then status 422
    And match response[0].field == 'email'
    And match response[0].message contains 'taken'
  
  @CRE004
  @negative
  Scenario Outline: Create user with invalid <field>
    * def dynamicEmail = 'qa_' + java.util.UUID.randomUUID() + '@mail.com'
    Given path 'users'
    And request
        """
          {
            "name": #(<field> == 'name' ? <invalidValue> : 'Andres QA'),
            "gender": #(<field> == 'gender' ? <invalidValue>  : 'male'),
            "email": #(<field> == 'email' ? <invalidValue>  : dynamicEmail),
            "status": #(<field> == 'status' ? <invalidValue>  : 'active')
          }
        """
    When method POST
    Then status 422
    And match response == '#[]'
    And match response[0].field == '<expectedField>'
    And match response[0].message contains '<expectedMessage>'
    
    Examples:
      | field     | invalidValue        | expectedField | expectedMessage |
      | 'gender'  | 'robot'             | gender        | male            |
      | 'status'  | 'enabled'           | status        | blank           |
      | 'email'   | 'correoSinArroba'   | email         | invalid         |
      | 'name'    | ''                  | name          | blank           |
  
  @CRE005
  Scenario Outline: Create user testing field limits - <case>
    * def dynamicEmail = 'qa_' + java.util.UUID.randomUUID() + '@mail.com'
    * def longString = java.util.UUID.randomUUID().toString().replace('-', '').repeat(10).substring(0, <length>)
    Given path 'users'
    And request
        """
          {
            "name": #(<field> == 'name' ? longString : 'Andres QA'),
            "gender": "female",
            "email": #(<field> == 'email' ? longString + '@mail.com' : dynamicEmail),
            "status": "active"
          }
        """
    When method POST
    Then status <expectedStatus>
    Examples:
      | case                 | field    | length | expectedStatus |
      | name min length      | 'name'   | 1      | 201            |
      | name very long (199) | 'name'   | 199    | 201            |
      | name extreme (201)   | 'name'   | 201    | 422            |
      | email very long      | 'email'  | 191    | 201            |
      | email extreme (192)  | 'email'  | 192    | 422            |
