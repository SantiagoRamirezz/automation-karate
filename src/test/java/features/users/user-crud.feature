Feature: Full CRUD flow
  
  Background:
	* url baseUrl
  
  @CRU001
  Scenario: Create, Read, Update and Delete user

    # CREATE
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

      # READ
	Given path '/users', userId
	When method GET
	Then status 200
	And match response.id == userId
	And match response.email == randomEmail

      # UPDATE
	Given path '/users', userId
	And request { "name": "Santiago Updated", "status": "inactive" }
	When method PUT
	Then status 200
	And match response.name == "Santiago Updated"
	And match response.status == "inactive"

      # DELETE
	Given path '/users', userId
	When method DELETE
	Then status 204

      # VALIDATE DELETE
	Given path '/users', userId
	When method GET
	Then status 404
	And match response.message == "Resource not found"
  
  
  @CRU002
  Scenario: CRUD call features

    # CREATE
	* def createResult = call read('create-user.feature')
	* def userId = createResult.result.id

    # READ
	* def getResult = call read('get-user.feature') { userId: '#(userId)' }
	* match getResult.responseUser.id == userId

    # UPDATE
	* def updateResult = call read('update-user.feature') { userId: '#(userId)' }
	* match updateResult.updatedUser.status == 'inactive'

    # DELETE
	* call read('delete-user.feature') { userId: '#(userId)' }

    # VALIDATE DELETE
	Given path 'users', userId
	When method GET
	Then status 404