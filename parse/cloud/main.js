
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("findFriends", function(request, response) {	
	var currentUser = Parse.User.current();
	var query = new Parse.Query("Friend");
	
  	query.equalTo('User_id', currentUser);
  	
   	query.find({
    	success: function(results) {
        var friends = [];
        for(var i = 0; i < results.length; i++){
          friends.push(results[i].get("Friend_id"));
        }
        response.success(friends);
   		},
    	error: function(error) {
      		response.error('Oups something went wrong');
    	}
  	});
});
