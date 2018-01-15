component {

	property name="userService" inject="service.UserService";

	function index(event,rc,prc){
		prc.list = userService.list();
		return renderView( view="login/index" );
	}
}
