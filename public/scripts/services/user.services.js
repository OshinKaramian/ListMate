function User(Token) {
	this.token_id = Token;
	this.name = "";
	var local_user = this;

	this.init = function(){
	}

	this.delete = function(){
		$.ajax({
			type:"DELETE",
			url:"http://localhost:4567/user",
			data: "user_id" + id,
			cache: false,
			success: function(){
			},
			error: function(){
			},
		});
	}

	this.create = function(un, pass){
		$.ajax({
			type:"POST",
			url:"http://localhost:4567/user", 
			data: {username: un, password: pass},
			cache: false,
			success: function(data){
				alert(data);
			},
			error: function(){
				alert("error" + data);
			},
		});
	}

	this.login = function(un, pass, onUserLogin){
		$.ajax({
			type:"GET",
			url:"http://localhost:4567/user",
			data: {username: un, password: pass},
			cache: false,
			success: function(data, textStatus, jqXHR){
				local_user.token_id = data._id;
				local_user.name = data.name;
				onUserLogin(local_user);
			},
			error: function(jqXHR, textStatus, errorThrown){
				alert("error: " + $.parseJSON(jqXHR.responseText).error);
			},
		});
	}

	return local_user;
};

