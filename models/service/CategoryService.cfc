component displayName="CategoryService" accessors="true" {

	property name="CategoryDAO" inject="dao.CategoryDAO";

	property name="categoryID" type="string";
	property name="category" type="string";
	property name="slug" type="string";

	property name="errors" type="array" setter="false";

	public models.service.CategoryService function init() {
		variables.errors = [];
		return this;
	}

	public void function clearErrors() {
		variables.errors = [];
	}

	public struct function list() {
		return { "categories": categoryDAO.read() };
	}

	public struct function getBy( string categoryID=0 ) {

		var data = {
			"category": []
		};

		validateCategoryID();

		if ( getErrors().isEmpty() ) {
			data.category = categoryDAO.read( categoryID=getCategoryID() );
		}

		return data;
	}

	public struct function create() {

		var data = {
			"success": false
		};

		validateCategory();
		validateSlug();

		if ( getErrors().isEmpty() ) {

			validateCategoryExists();
			validateSlugExists();

			if ( getErrors().isEmpty() ) {

				var input = {
					category : getcategory(),
					slug : getSlug()
				};

				data.success = categoryDAO.create( argumentCollection=input );
			}

		}

		return data;
	}

	public struct function update() {
		var data = {
			"rowsAffected": 0
		};

		validateCategoryID();
		validateCategory();
		validateSlug();

		if ( getErrors().isEmpty() ) {

			validateCategoryExists();
			validateSlugExists();

			if ( getErrors().isEmpty() ) {

				var input = {
					categoryID : getCategoryID(),
					category : getcategory(),
					slug : getSlug()
				};

				data.rowsAffected = categoryDAO.update( argumentCollection=input );
			}

		}

		return data;
	}

	public struct function delete() {
		var data = {
			"rowsAffected": 0
		};

		validateCategoryID();

		if ( getErrors().isEmpty() ) {
			data.rowsAffected = categoryDAO.delete( categoryID=getCategoryID() );
		}

		return data;
	}

	//------------------------------------ Validate Functions ------------------------------------------

	public void function validateCategoryID() {
		if ( !structKeyExists( variables, "categoryID" ) || val( getCategoryID() ) == 0 ) {
			arrayAppend( getErrors(), "CategoryID is required" );
		}
	}

	public void function validateCategory() {
		if ( !structKeyExists( variables, "category" ) || getcategory().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Category is required" );
		}
	}

	public void function validateCategoryExists() {
		if( structKeyExists( variables, "categoryID" ) && val( getCategoryID() ) > 0 ){
			var result = categoryDAO.read( notCategoryID=getCategoryID(), category=getCategory() );
		} else {
			var result = categoryDAO.read( category=getCategory() );
		}

		if ( !result.isEmpty() ) {
			arrayAppend( getErrors(), "Category already exists." );
		}
	}

	public void function validateSlug() {
		if ( !structKeyExists( variables, "slug" ) || getSlug().trim().len() == 0 ) {
			arrayAppend( getErrors(), "Slug is required" );
		}
	}

	public void function validateSlugExists() {
		if( structKeyExists( variables, "categoryID" ) && val( getCategoryID() ) > 0 ){
			var result = categoryDAO.read( notcategoryID=getCategoryID(), slug=getSlug() );
		} else {
			var result = categoryDAO.read( slug=getSlug() );
		}

		if ( !result.isEmpty() ) {
			arrayAppend( getErrors(), "Slug already exists." );
		}
	}

}
