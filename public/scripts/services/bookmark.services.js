function Bookmark(User) {
	var local_bookmark= this;
	var user = User;

	this.init = function(){
	}

	this.delete = function(){
		$.ajax({
			type:"DELETE",
			url:"http://localhost:4567/bookmark",
			data: "bookmark_id" + id,
			cache: false,
			success: function(){
			},
			error: function(){
			},
		});
	}

	this.create = function(url, name){
		$.ajax({
			type:"POST",
			url:"http://localhost:4567/bookmark", 
			data: {url: url, name: name, user_id: user.token_id},
			cache: false,
			success: function(data){
				alert(data);
			},
			error: function(){
				alert("error" + data);
			},
		});
	}

	this.get_all = function(callback){
		$.ajax({
			type:"GET",
			url:"http://localhost:4567/bookmark",
			data: { user_id: user.token_id },
			cache: false,
			success: function(data){
				callback(data);
			},
			error: function(){
			},
		});
	}

	return local_bookmark;
};

