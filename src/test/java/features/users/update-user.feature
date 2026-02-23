Feature: Update user

  Background:
    * url baseUrl
    
  @UPD001
  Scenario: Delete user - returns 204
    * def userId = __arg.userId

    Given path 'users', userId
    And request { "name": "Santiago Updated", "status": "inactive" }
    When method PUT
    Then status 200

    * karate.set('updatedUser', response)
  
  @UPD002
  Scenario Outline: Activate users by id: <id>
    Given path 'users', <id>
    And request { status: 'active' }
    When method PUT
    Then status 200
    And match response.status == "active"
    And match response.id == <id>
    
    Examples:
      | id       |
      | 8383250 |
      | 8383159 |
      | 8383158 |
      | 8383156 |
      | 8383155 |
  
    @UPD003
    Scenario Outline: Deactivate users by ID: <id>
      
      Given path 'users', <id>
      And request { status: 'inactive' }
      When method PUT
      Then status 200
      And match response.status == "inactive"
      And match response.id == <id>
      
      Examples:
        | id       |
        | 8383250 |
        | 8383159 |
        | 8383158 |
        | 8383156 |
        | 8383155 |