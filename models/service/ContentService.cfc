component displayName="ContentService" accessors="true" {

	property name="contentDAO" inject="dao.ContentDAO";

	property name="contentID" type="string";
	property name="title" type="string";
	property name="permaLink" type="string";
	property name="body" type="string";

	property name="errors" type="array" setter="false";

	public models.service.ContentService function init() {
		variables.errors = [];
		return this;
	}

	public void function clearErrors() {
		variables.errors = [];
	}

	public struct function list() {
		return { "content": contentDAO.read() };
	}

	public struct function getBy( string contentID=0 ) {

		var data = {
			"content": []
		};

		validateContentID();

		if ( getErrors().isEmpty() ) {
			data.content = contentDAO.read( contentID=getContentID() );
		}

		return data;
	}

	public struct function create() {

		var data = {
			"success": false
		};

		validateTitle();
		validatePermaLink();
		validateBody();

		if ( getErrors().isEmpty() ) {

			validateTitleExists();
			validatePermaLinkExists();

			if ( getErrors().isEmpty() ) {

				var input = {
					title : getTitle(),
					permaLink : getPermaLink(),
					body : getBody()
				};

				data.success = contentDAO.create( argumentCollection=input );
			}

		}

		return data;
	}

	public struct function update() {
		var data = {
			"rowsAffected": 0
		};

		validateContentID();
		validateTitle();
		validatePermaLink();
		validateBody();

		if ( getErrors().isEmpty() ) {

			validateTitleExists();
			validatePermaLinkExists();

			if ( getErrors().isEmpty() ) {

				var input = {
					contentID : getContentID(),
					title : getTitle(),
					permaLink : getPermaLink(),
					body : getBody()
				};

				data.rowsAffected = contentDAO.update( argumentCollection=input );
			}

		}

		return data;
	}

	public struct function delete() {
		var data = {
			"rowsAffected": 0
		};

		validateContentID();

		if ( getErrors().isEmpty() ) {
			data.rowsAffected = contentDAO.delete( contentID=getContentID() );
		}

		return data;
	}

	//------------------------------------ Validate Functions ------------------------------------------

	public void function validateContentID() {
		if ( !structKeyExists( variables, "contentID" ) || val( getContentID() ) == 0 ) {
			arrayAppend( getErrors(), "ContentID is required" );
		}
	}

	public void function validateTitle() {
		if ( !structKeyExists( variables, "title" ) || getTitle().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Title is required" );
		}
	}

	public void function validateTitleExists() {
		if( structKeyExists( variables, "contentID" ) && val( getContentID() ) > 0 ){
			var result = contentDAO.read( notContentID=getContentID(), title=getTitle() );
		} else {
			var result = contentDAO.read( title=getTitle() );
		}

		if ( !result.isEmpty() ) {
			arrayAppend( getErrors(), "Title already exists." );
		}
	}

	public void function validatePermaLink() {
		if ( !structKeyExists( variables, "permaLink" ) || getPermaLink().trim().len() == 0 ) {
			arrayAppend( getErrors(), "PermaLink is required" );
		}
	}

	public void function validatePermaLinkExists() {
		if( structKeyExists( variables, "contentID" ) && val( getContentID() ) > 0 ){
			var result = contentDAO.read( notContentID=getContentID(), permaLink=getPermaLink() );
		} else {
			var result = contentDAO.read( permaLink=getPermaLink() );
		}

		if ( !result.isEmpty() ) {
			arrayAppend( getErrors(), "PermaLink already exists." );
		}
	}

	public void function validateBody() {
		if ( !structKeyExists( variables, "body" ) || getBody().trim().len() == 0 ) {
			arrayAppend( getErrors(), "body is required" );
		}
	}

}
