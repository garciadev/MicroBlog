component extends="BaseRemoteHandler"{

	this.allowedMethods = {
		list = "GET",
		getBy = "GET",
		create = "POST",
		update = "PUT",
		delete = "DELETE"
	};

	public void function preHandler( event, rc, prc ){
		variables.contentService = populateModel( "service.ContentService" );
	}

	any function postHandler( event, rc, prc ){
		var errors = contentService.getErrors();
		prc.response.addMessage( errors );
	}

	any function list( event, rc, prc ){
		prc.response.setData( contentService.list() );
	}

	any function getBy( event, rc, prc ){
		prc.response.setData( contentService.getBy() );
	}

	any function create( event, rc, prc ){
		prc.response.setData( contentService.create() );
	}

	any function update( event, rc, prc ){
		prc.response.setData( contentService.update() );
	}

	any function delete( event, rc, prc ){
		prc.response.setData( contentService.delete() );
	}

}