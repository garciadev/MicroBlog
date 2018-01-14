<cfcomponent output="false" displayName="ContentDAO" accessors="true">

	<cfproperty name="libUtility" inject="libUtility">
	<cfproperty name="dsn" inject="coldbox:datasource:microBlog">

	<cffunction name="read" access="public" returntype="array" output="false" hint="Read data from content table.">
		<cfargument name="contentID" type="numeric" required="false" default="0">
		<cfargument name="notContentID" type="numeric" required="false" default="0">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="permaLink" type="string" required="false" default="">

		<cfset var result = {}>

		<cfquery name="result" datasource="#getDSN().name#">
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

		<cfreturn libUtility.QueryToArrayOfStructures( result )>

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

		<cfreturn true>
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

</cfcomponent>
