<cfcomponent output="false" displayName="CategoryDAO" accessors="true">

	<cfproperty name="libUtility" inject="libUtility">
	<cfproperty name="dsn" inject="coldbox:datasource:microBlog">

	<cffunction name="read" access="public" returntype="array" output="false" hint="Read data from category table.">
		<cfargument name="categoryID" type="numeric" required="false" default="0">
		<cfargument name="notCategoryID" type="numeric" required="false" default="0">
		<cfargument name="category" type="string" required="false" default="">
		<cfargument name="slug" type="string" required="false" default="">

		<cfset var result = {}>

		<cfquery name="result" datasource="#getDSN().name#">
			SELECT  categoryID
				   ,category
				   ,slug
				   ,createdDate
				   ,updatedDate

			FROM category

			WHERE 1 = 1

			<cfif val( arguments.categoryID ) GT 0>
				AND categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.categoryID )#">
			</cfif>

			<cfif val( arguments.notCategoryID ) GT 0>
				AND categoryID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.notCategoryID )#">
			</cfif>

			<cfif arguments.category.trim().len() GT 0>
				AND category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category.trim()#">
			</cfif>

			<cfif arguments.slug.trim().len() GT 0>
				AND slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug.trim()#">
			</cfif>

			ORDER BY category
		</cfquery>

		<cfreturn libUtility.QueryToArrayOfStructures( result )>

	</cffunction>

	<cffunction name="create" access="public" returntype="string" output="false" hint="Inserts a record into category table.">
		<cfargument name="category" type="string" required="false" default="">
		<cfargument name="slug" type="string" required="false" default="">

		<cfset var result = "">
		<cfset var constraints = libUtility.getConstraints().category>

		<cfquery result="result" datasource="#getDSN().name#">
			INSERT INTO category
				(
					 category
					,slug
					,createdDate
					,updatedDate
				)
				VALUES
				(
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.category.trim(), constraints.category )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.slug.trim(), constraints.slug )#">
					,current_timestamp
					,current_timestamp
				)
			</cfquery>

		<cfreturn true>
	</cffunction>

	<cffunction name="update" access="public" returntype="string" output="false" hint="Update a record in category table.">
		<cfargument name="categoryID" type="numeric" required="false" default="0">

		<cfset var result = "">
		<cfset var constraints = libUtility.getConstraints().category>

		<cfquery result="result" datasource="#getDSN().name#">
			UPDATE category
			SET  updatedDate = current_timestamp

				<cfif structKeyExists( arguments, "category" )>
					,category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.category.trim(), constraints.category )#">
				</cfif>

				<cfif structKeyExists( arguments, "slug" )>
					,slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.slug.trim(), constraints.slug )#">
				</cfif>

			WHERE categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.categoryID )#">
		</cfquery>

		<cfreturn result.recordCount>
	</cffunction>

	<cffunction name="delete" access="public" returntype="string" output="false" hint="Update a record in category table.">
		<cfargument name="categoryID" type="numeric" required="false" default="0">

		<cfset var result = "">

		<cfquery result="result" datasource="#getDSN().name#">
			DELETE FROM content_category
			WHERE categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.categoryID )#">
		</cfquery>

		<cfquery result="result" datasource="#getDSN().name#">
			DELETE FROM category
			WHERE categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.categoryID )#">
		</cfquery>

		<cfreturn result.recordCount>
	</cffunction>

</cfcomponent>
