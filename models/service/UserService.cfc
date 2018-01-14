component displayName="UserService" accessors="true" {

	property name="UserDAO" inject="dao.UserDAO";
	property name="BCrypt" inject="BCrypt@BCrypt";

	property name="userID" type="string";
	property name="firstName" type="string";
	property name="lastName" type="string";
	property name="email" type="string";
	property name="userName" type="string";
	property name="password" type="string";

	property name="errors" type="array" setter="false";

	public models.service.UserService function init() {
		variables.errors = [];
		return this;
	}

	public void function clearErrors() {
		variables.errors = [];
	}

	public struct function list() {
		return { "users" : UserDAO.read() };
	}

	public struct function getBy( string userID=0 ) {

		var data = {
			"user" : []
		};

		validateUserID();

		if ( getErrors().isEmpty() ) {
			data.user = UserDAO.read( userID=getUserID() );
		}

		return data;
	}

	public struct function create() {

		var data = {
			"success" : false
		};

		validateFirstName();
		validateLastName();
		validateEmail();
		validateUsername();
		validatePassword();

		if ( getErrors().isEmpty() ) {

			validateEmailExists();
			validateUsernameExists();

			if ( getErrors().isEmpty() ) {

				var hashedPassword = BCrypt.hashPassword( getPassword() );

				var input = {
					firstName : getFirstName(),
					lastName : getLastName(),
					email : getEmail(),
					username : getUsername(),
					password : hashedPassword
				};

				data.success = UserDAO.create( argumentCollection=input );
			}

		}

		return data;
	}

	public struct function update() {
		var data = {
			"rowsAffected" : 0
		};

		validateUserID();
		validateFirstName();
		validateLastName();
		validateEmail();
		validateUsername();

		if ( getErrors().isEmpty() ) {

			validateEmailExists();
			validateUsernameExists();

			if ( getErrors().isEmpty() ) {

				var input = {
					userID : getUserID(),
					firstName : getFirstName(),
					lastName : getLastName(),
					email : getEmail(),
					username : getUsername()
				};


				if ( structKeyExists( variables, "password" ) && getPassword().trim().len() > 0 ) {
					var hashedPassword = BCrypt.hashPassword( getPassword() );
					input.password = hashedPassword;
				}

				data.rowsAffected = UserDAO.update( argumentCollection=input );
			}

		}

		return data;
	}

	public struct function delete() {
		var data = {
			"rowsAffected" : 0
		};

		validateUserID();

		if ( getErrors().isEmpty() ) {
			data.rowsAffected = UserDAO.delete( userID=getUserID() );
		}

		return data;
	}


	//  TODO:  Add login functions


	//------------------------------------ Validate Functions ------------------------------------------

	public void function validateUserID() {
		if ( !structKeyExists( variables, "userID" ) || val( getUserID() ) == 0 ) {
			arrayAppend( getErrors(), "UserID is required" );
		}
	}

	public void function validateFirstName() {
		if ( !structKeyExists( variables, "firstName" ) || getFirstName().trim().len() == 0 ) {
			arrayAppend( getErrors(), "First Name is required" );
		}
	}

	public void function validateLastName() {
		if ( !structKeyExists( variables, "lastName" ) || getLastName().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Last Name is required" );
		}
	}

	public void function validateEmail() {
		if ( !structKeyExists( variables, "email" ) || getEmail().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Email is required" );
		} else if ( !ReFindNoCase( "^[A-Z0-9\._%\+-]+@[A-Z0-9\.-]+\.[A-Z]{2,6}$", trim( getEmail() ) ) ){
			arrayAppend( getErrors(), "A valid email is required" );
		}
	}

	public void function validateEmailExists() {
		if( structKeyExists( variables, "userID" ) && val( getUserID() ) > 0 ){
			var result = UserDAO.read( notUserID=getUserID(), email=getEmail() );
		} else {
			var result = UserDAO.read( email=getEmail() );
		}

		if ( !result.isEmpty() ) {
			arrayAppend( getErrors(), "Email already exists." );
		}
	}

	public void function validateUsername() {
		if ( !structKeyExists( variables, "username" ) || getUsername().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Username is required" );
		}
	}

	public void function validateUsernameExists() {
		if( structKeyExists( variables, "userID" ) && val( getUserID() ) > 0 ){
			var result = UserDAO.read( notUserID=getUserID(), username=getUsername() );
		} else {
			var result = UserDAO.read( username=getUsername() );
		}

		if ( !result.isEmpty() ) {
			arrayAppend( getErrors(), "Username already exists." );
		}
	}

	public void function validatePassword() {
		if ( !structKeyExists( variables, "password" ) || getPassword().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Password is required" );
		}
	}

}
