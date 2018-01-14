<cfcomponent output="false" displayName="UserDAO" accessors="true">

	<cfproperty name="libUtility" inject="libUtility">
	<cfproperty name="dsn" inject="coldbox:datasource:microBlog">

	<cffunction name="read" access="public" returntype="array" output="false" hint="Read data from user table.">
		<cfargument name="userID" type="numeric" required="false" default="0">
		<cfargument name="notUserID" type="numeric" required="false" default="0">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="username" type="string" required="false" default="">

		<cfset var result = {}>

		<cfquery name="result" datasource="#getDSN().name#">
			SELECT  userID
				   ,firstName
				   ,lastName
				   ,email
				   ,username
				   ,password
				   ,createdDate
				   ,updatedDate

			FROM user

			WHERE 1 = 1

			<cfif val( arguments.userID ) GT 0>
				AND userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.userID )#">
			</cfif>

			<cfif val( arguments.notUserID ) GT 0>
				AND userID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.notUserID )#">
			</cfif>

			<cfif arguments.email.trim().len() GT 0>
				AND email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email.trim()#">
			</cfif>

			<cfif arguments.username.trim().len() GT 0>
				AND username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username.trim()#">
			</cfif>

			ORDER BY lastName, firstName
		</cfquery>

		<cfreturn libUtility.QueryToArrayOfStructures( result )>

	</cffunction>

	<cffunction name="create" access="public" returntype="string" output="false" hint="Inserts a record into user table.">
		<cfargument name="firstName" type="string" required="false" default="">
		<cfargument name="lastName" type="string" required="false" default="">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="username" type="string" required="false" default="">
		<cfargument name="password" type="string" required="false" default="">

		<cfset var result = "">
		<cfset var constraints = libUtility.getConstraints().user>

		<cfquery result="result" datasource="#getDSN().name#">
			INSERT INTO user
				(
					 FirstName
					,LastName
					,Email
					,username
					,password
					,createdDate
					,updatedDate
				)
				VALUES
				(
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.firstName.trim(), constraints.firstName )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.lastName.trim(), constraints.lastName )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.email.trim(), constraints.email )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.username.trim(), constraints.username )#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.password.trim(), constraints.password )#">
					,current_timestamp
					,current_timestamp
				)
			</cfquery>

		<cfreturn true>
	</cffunction>

	<cffunction name="update" access="public" returntype="string" output="false" hint="Update a record in user table.">
		<cfargument name="userID" type="numeric" required="false" default="0">

		<cfset var result = "">
		<cfset var constraints = libUtility.getConstraints().user>

		<cfquery result="result" datasource="#getDSN().name#">
			UPDATE user
			SET  updatedDate = current_timestamp

				<cfif structKeyExists( arguments, "firstName" )>
					,firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.firstName.trim(), constraints.firstName )#">
				</cfif>

				<cfif structKeyExists( arguments, "lastName" )>
					,lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.lastName.trim(), constraints.lastName )#">
				</cfif>

				<cfif structKeyExists( arguments, "email" )>
					,email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.email.trim(), constraints.email )#">
				</cfif>

				<cfif structKeyExists( arguments, "username" )>
					,username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.username.trim(), constraints.username )#">
				</cfif>

				<cfif structKeyExists( arguments, "password" )>
					,password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left( arguments.password.trim(), constraints.password )#">
				</cfif>

			WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.userID )#">
		</cfquery>

		<cfreturn result.recordCount>
	</cffunction>

	<cffunction name="delete" access="public" returntype="string" output="false" hint="Update a record in user table.">
		<cfargument name="userID" type="numeric" required="false" default="0">

		<cfset var result = "">

		<cfquery result="result" datasource="#getDSN().name#">
			DELETE FROM user
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.userID )#">
		</cfquery>

		<cfreturn result.recordCount>
	</cffunction>

</cfcomponent>
