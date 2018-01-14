<cfcomponent output="false" displayName="ContentDAO" accessors="true">

	<cfproperty name="libUtility" inject="libUtility">
	<cfproperty name="dsn" inject="coldbox:datasource:microBlog">

	<cffunction name="read" access="public" returntype="array" output="false" hint="Read data from content table.">
		<cfargument name="contentID" type="numeric" required="false" default="0">
		<cfargument name="notContentID" type="numeric" required="false" default="0">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="permaLink" type="string" required="false" default="">

		<cfset var config = {}>
		<cfset var data = []>

		<cfquery name="config.result" datasource="#getDSN().name#">
			SELECT  contentID
				   ,title
				   ,permaLink
				   ,body
				   ,createdDate
				   ,updatedDate

			FROM content

			WHERE 1 = 1

			<cfif val( arguments.contentID ) GT 0>
				AND contentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.contentID )#">
			</cfif>

			<cfif val( arguments.notContentID ) GT 0>
				AND contentID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.notContentID )#">
			</cfif>

			<cfif arguments.title.trim().len() GT 0>
				AND title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title.trim()#">
			</cfif>

			<cfif arguments.permaLink.trim().len() GT 0>
				AND permaLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permaLink.trim()#">
			</cfif>

			ORDER BY title, permaLink
		</cfquery>


		<cfloop query="#config.result#">

			<cfset config.item = {
				"contentID" : config.result.contentID,
				"title" : config.result.title,
				"permaLink" : config.result.permaLink,
				"body" : config.result.body,
				"createdDate" : config.result.createdDate,
				"updatedDate" : config.result.updatedDate,
				"categories" : []
			}>

			<cfquery name="config.getCategories" datasource="#getDSN().name#">
				SELECT category.categoryID, category.category
				FROM content_category
				INNER JOIN category ON category.categoryID = content_category.categoryID
				WHERE content_category.contentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( config.item.contentID )#">
				ORDER BY category.category
			</cfquery>

			<cfloop query="#config.getCategories#">
				<cfset config.categoryItem = {
					"categoryID" : config.getCategories.categoryID,
					"category" : config.getCategories.category
				}>

				<cfset arrayAppend( config.item.categories, config.categoryItem )>
			</cfloop>

			<cfset arrayAppend( data, config.item )>

		</cfloop>

		<cfreturn data>

	</cffunction>

	<cffunction name="create" access="public" returntype="string" output="false" hint="Inserts a record into content table.">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="permaLink" type="string" required="false" default="">
		<cfargument name="body" type="string" required="false" default="">

		<cfset var result = "">
		<cfset var constraints = libUtility.getConstraints().content>

		<cfquery result="result" datasource="#getDSN().name#">
			INSERT INTO content
				(
					 title
					,permaLink
					,body
					,createdDate
					,updatedDate
				)
				VALUES
				(
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.title.trim(), constraints.title )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.permaLink.trim(), constraints.permaLink )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.body.trim()#">
					,current_timestamp
					,current_timestamp
				)
			</cfquery>

		<cfreturn result.GENERATED_KEY>
	</cffunction>

	<cffunction name="update" access="public" returntype="string" output="false" hint="Update a record in content table.">
		<cfargument name="contentID" type="numeric" required="false" default="0">

		<cfset var result = "">
		<cfset var constraints = libUtility.getConstraints().content>

		<cfquery result="result" datasource="#getDSN().name#">
			UPDATE content
			SET  updatedDate = current_timestamp

				<cfif structKeyExists( arguments, "title" )>
					,title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.title.trim(), constraints.title )#">
				</cfif>

				<cfif structKeyExists( arguments, "permaLink" )>
					,permaLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.permaLink.trim(), constraints.permaLink )#">
				</cfif>

				<cfif structKeyExists( arguments, "body" )>
					,body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.body.trim()#">
				</cfif>

			WHERE contentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.contentID )#">
		</cfquery>

		<cfreturn result.recordCount>
	</cffunction>

	<cffunction name="delete" access="public" returntype="string" output="false" hint="Update a record in content table.">
		<cfargument name="contentID" type="numeric" required="false" default="0">

		<cfset var result = "">

		<cfquery result="result" datasource="#getDSN().name#">
			DELETE FROM content_category
			WHERE contentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.contentID )#">
		</cfquery>

		<cfquery result="result" datasource="#getDSN().name#">
			DELETE FROM content
			WHERE contentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.contentID )#">
		</cfquery>

		<cfreturn result.recordCount>
	</cffunction>

	<cffunction name="updateContent_category" access="public" returntype="boolean" output="false" hint="Inserts a record into content table.">
		<cfargument name="contentID" type="numeric" required="false" default="0">
		<cfargument name="categoryIDs" type="string" required="false" default="">

		<cfset var categoryIndex = "">
		<cfset var result = "">

		<cfquery result="result" datasource="#getDSN().name#">
			DELETE FROM content_category
			WHERE contentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.contentID )#">
		</cfquery>

		<cfloop list="#arguments.categoryIDs#" index="categoryIndex">

			<cfquery result="result" datasource="#getDSN().name#">
				INSERT INTO content_category
					(
						 contentID
						,categoryID
					)
					VALUES
					(
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.contentID )#">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#val( categoryIndex )#">
					)
			</cfquery>

		</cfloop>

		<!---  TODO:  Add other validation to make sure category exists.  For now, just delete any records that aren't a category  --->
		<cfquery datasource="#getDSN().name#">
			DELETE FROM content_category
			WHERE categoryID NOT IN ( SELECT categoryID FROM category )
		</cfquery>

		<cfreturn true>
	</cffunction>

</cfcomponent>
