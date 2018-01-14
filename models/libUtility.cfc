component {

	public struct function getConstraints(){

		var constraints = {

			category : {
				category : 50,
				slug : 50
			},

			content : {
				title : 150,
				permaLink : 50
			},

			user : {
				firstName : 50,
				lastName : 50,
				email : 150,
				username : 150,
				password : 250
			}

		};

		return constraints;
	}

	public any function queryToArrayOfStructures( required query theQuery, string columns=""){

		var returnData = [];

		if( server.coldfusion.productname CONTAINS "Lucee" ){
			var columnArray = listToArray( ListLen( arguments.columns ) > 0 ? trim( arguments.columns ) : arguments.theQuery.getColumnList( false ) );
		} else {
			var columnArray = listToArray( ListLen( arguments.columns ) > 0 ? trim( arguments.columns ) : arguments.theQuery.columnlist );
		}

		for( var i=1; i<=arguments.theQuery.recordCount; i++ ) {
			var queryRow = {};
			for( var x=1; x<=arrayLen( columnArray ); x++ ) {
				if ( findNoCase( " as ", columnArray[ x ] ) != 0 ) {
					var columnName = trim( listToArray( columnArray[ x ], " as ", true, true )[2] );
				} else {
					var columnName = trim( columnArray[ x ] );
				}

				if ( !isNull( arguments.theQuery[ columnName ][ i ] ) ) {
					queryRow[ columnName ] = arguments.theQuery[ columnName ][ i ];
				}
			}
			arrayAppend( returnData, queryRow );
		}
		return returnData ;
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