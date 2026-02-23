Feature: Create user with auth token

  Background:
    * url baseUrl
    * def authHeader = 'Bearer ' + token
    * configure headers = { Authorization: '#(authHeader)', 'Content-Type': 'application/json' }
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true


  @CRE001
  Scenario: Create new user

    Given path '/users'
    And request
        """
        {
          "name": "Santiago QA",
          "gender": "male",
          "email": "santiagoqa12361@test.com",
          "status": "active"
        }
        """
    When method POST
    Then status 201
    And match response.id != null
    And match response.email == 'santiagoqa12361@test.com'

    @CRE002
    Scenario: Create, Read, Update and Delete user

    # =========================
    # 1️⃣ CREATE
    # =========================

      * def randomEmail = 'santiago' + java.util.UUID.randomUUID() + '@test.com'

      Given path '/users'
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
      And match response.id != null
      And match response.email == randomEmail

      * def userId = response.id
      * print 'USER ID CREADO:', userId

      # =========================
      # 2️⃣ READ
      # =========================

      Given path '/users', userId
      When method GET
      Then status 200
      And match response.id == userId
      And match response.email == randomEmail

      # =========================
      # 3️⃣ UPDATE
      # =========================

      Given path '/users', userId
      And request
          """
          {
            "name": "Santiago Updated",
            "status": "inactive"
          }
          """
      When method PUT
      Then status 200
      And match response.name == "Santiago Updated"
      And match response.status == "inactive"

      # =========================
      # 4️⃣ DELETE
      # =========================

      Given path '/users', userId
      When method DELETE
      Then status 204

      # =========================
      # 5️⃣ VALIDATE DELETED
      # =========================

      Given path '/users', userId
      When method GET
      Then status 404
      And match response.message == "Resource not found"