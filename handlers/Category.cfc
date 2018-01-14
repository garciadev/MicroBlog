component extends="BaseRemoteHandler"{

	this.allowedMethods = {
		list = "GET",
		getBy = "GET",
		create = "POST",
		update = "PUT",
		delete = "DELETE"
	};

	public void function preHandler( event, rc, prc ){
		variables.categoryService = populateModel( "service.CategoryService" );
	}

	any function postHandler( event, rc, prc ){
		prc.response.addMessage( categoryService.getErrors() );
	}

	any function list( event, rc, prc ){
		prc.response.setData( categoryService.list() );
	}

	any function getBy( event, rc, prc ){
		prc.response.setData( categoryService.getBy() );
	}

	any function create( event, rc, prc ){
		prc.response.setData( categoryService.create() );
	}

	any function update( event, rc, prc ){
		prc.response.setData( categoryService.update() );
	}

	any function delete( event, rc, prc ){
		prc.response.setData( categoryService.delete() );
	}

}