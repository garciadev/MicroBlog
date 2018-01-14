component extends="BaseRemoteHandler"{

	this.allowedMethods = {
		list = "GET",
		getBy = "GET",
		create = "POST",
		update = "PUT",
		delete = "DELETE"
	};

	public void function preHandler( event, rc, prc ){
		variables.userService = populateModel( "service.UserService" );
	}

	any function postHandler( event, rc, prc ){
		prc.response.addMessage( userService.getErrors() );
	}

	any function list( event, rc, prc ){
		prc.response.setData( userService.list() );
	}

	any function getBy( event, rc, prc ){
		prc.response.setData( userService.getBy() );
	}

	any function create( event, rc, prc ){
		prc.response.setData( userService.create() );
	}

	any function update( event, rc, prc ){
		prc.response.setData( userService.update() );
	}

	any function delete( event, rc, prc ){
		prc.response.setData( userService.delete() );
	}

}