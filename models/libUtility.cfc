component {

	public struct function getConstraints(){

		var constraints = {

			category: {
				category: 50,
				slug: 50
			},

			content: {
				title: 150,
				permaLink: 50
			},

			user: {
				firstName: 50,
				lastName: 50,
				email: 150,
				username: 150,
				password: 250
			}

		};

		return constraints;
	}

	/**
	 * Converts a query object into an array of structures.
	 *
	 * @param query      The query to be transformed
	 * @return This function returns an array.
	 * @author Nathan Dintenfass (nathan@changemedia.com)
	 * @version 1, September 27, 2001
	 * https://cflib.org/udf/QueryToArrayOfStructures
	 * Small enhancements made by Daniel Garcia
	 */
	function QueryToArrayOfStructures( required query theQuery, string columns="" ){
	    var theArray = arraynew(1);
	    var cols = listToArray( ListLen( arguments.columns ) > 0 ? trim( arguments.columns ) : arguments.theQuery.getColumnList( false ) );

	    var row = 1;
	    var thisRow = "";
	    var col = 1;
	    for(row = 1; row LTE theQuery.recordcount; row = row + 1){
	        thisRow = structnew();
	        for(col = 1; col LTE arraylen(cols); col = col + 1){
	            thisRow[cols[col]] = theQuery[cols[col]][row];
	        }
	        arrayAppend(theArray,duplicate(thisRow));
	    }
	    return(theArray);
	}

	public struct function getJSONData( required string content ){

		var JSONContent = trim( arguments.content );
		var result = "";

		try {

				JSONContent = replaceNoCase( trim(JSONContent), "//{", "{" );
				JSONContent = replaceNoCase( trim(JSONContent), "//[", "[" );
				result = deserializeJSON( JSONContent );

		} catch (any e) {

		}

		return result;
	}

}