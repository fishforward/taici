$(function(){
	// 数组包含方法
	Array.prototype.contains = function (element) {
	    for (var i = 0; i < this.length; i++) {
	        if (this[i] == element) {
	            return true;
	        }
	    }
	    return false;
	}


    $('#symbol_list').masonry({
        itemSelector: '.popular'
    });

    // 加载更多
    $('#symbol_more').click(function(){ 
    	t = $(this)

		var page = $('#page').val()
        var params="page="+page
        $.ajax({ 
            url:'/top.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_symbol_view//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_symbol_view(json){

			if(judgeJson(json)){
				list = json["taiciis"]
				topicMap = json['topicMap']

				for(i=0;i<list.length;i++){
					symbol = list[i]
					sId = symbol["id"]

					temp = $('#symbol_template').children().clone();

					symbol_tmp = temp.find('.symbol')
					symbol_tmp.find('a').first().attr('href',"/symbols/"+sId)
					symbol_tmp.find('span.letter').html(symbol["content"])
					symbol_tmp.find('div.content').children().first().children().last().html(topicMap[sId]['content'])

					button_tmp = temp.find('.top_button_list')
					if(json['feel_ids'].contains(sId)){
						button_tmp.find('button').first().attr('class','feel active')
					}
					if(json['no_feel_ids'].contains(sId)){
						button_tmp.find('button').last().attr('class','no_feel active')
					}
					button_tmp.find('button').first().val(sId)
					button_tmp.find('button').last().val(sId)

					button_tmp.find('#yes_span').html(symbol["yes"])
					button_tmp.find('#no_span').html(symbol["no"])

					$boxes = temp;
					$('#symbol_list').append($boxes).masonry('appended',$boxes);
				}

				// 页码+1
				$('#page').val(parseInt(page)+1)
			}

		}
    });
	/*
	$('#content').infinitescroll({
	  navSelector  : "div.pagination", //导航的选择器，会被隐藏
	  nextSelector : "div.pagination a:next",//包含下一页链接的选择器
	  itemSelector : ".popular",//你将要取回的选项(内容块)
	  debug        : true, //启用调试信息
	  loadingImg   : "http://www.infinite-scroll.com/loading.gif", //加载的时候显示的图片
	                 //默认采用："http://www.infinite-scroll.com/loading.gif"
	  animate      : true, //当有新数据加载进来的时候，页面是否有动画效果，默认没有
	  extraScrollPx: 50, //滚动条距离底部多少像素的时候开始加载，默认150
	  bufferPx     : 40,//载入信息的显示时间，时间越大，载入信息显示时间越短
	  errorCallback: function(){},//当出错的时候，比如404页面的时候执行的函数
	  localMode    : true //是否允许载入具有相同函数的页面，默认为false
	  },function(arrayOfNewElems){
	  //程序执行完的回调函数
	  alert("123");
	}); 
	*/

    // 公共方法：判断json是否有效  -- 重复代码
	function judgeJson(json){
		if(json!=null ){
			return true;
		}else{
			$('#symbol_more').hide();
			return false;
		}
	}

	
});



$(function(){
	$(".topic").live('mouseenter',function(){
		//$(this).find(".shoucang").show();
		$(this).find(".comments").show();
	});
	$(".topic").live('mouseleave',function(){
		//$(this).find(".shoucang").hide();
		$(this).find(".comments").hide();
	});

	// 公共方法：判断json是否有效
	function judgeJson(json){
		if(json!=null && (json.id!=null||json.topic!=null||json.taicci!=null)){
			return true;
		}else{
			alert("请先登录")
			return false;
		}
	}

	// 收藏按钮
	$('a.shoucang_link').click(function (){ 
		t = $(this)

		var id = t.attr("value")
        var params="a="+id+'&'+'s_type=SHOUCANG'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/stands.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_shoucang//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_shoucang(json){

			if(judgeJson(json)){
				t.hide()
				t.after("已收藏")
			}

		}
	});

	/*
	---bak----
	// 应景按钮
	$('a.feel').click(function (){ //直接把onclick事件写在了JS中，而不需要混在XHTML中了 
		t = $(this)
		if(t.parent().attr("class") == "active"){
			return;
		}

		var id = $(this).attr("value")
        var params="a="+id+'&'+'s_type=FEEL'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/love/feel.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_feel//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_feel(json){
			if(judgeJson(json)){
				t.parent().attr("class","active")
				t.parent().next().attr("class","");

				if(json["topic"] != null){

					span = t.children().first()
					span.html(Number(json["topic"]["yes"]))

					span = t.parent().next().children().first().children().first()
					span.html(Number(json["topic"]["no"]))
				}
			}
		}
	});

	// 没感觉按钮
	$('a.no_feel').click(function (){ //直接把onclick事件写在了JS中，而不需要混在XHTML中了 
		t = $(this)
		if(t.parent().attr("class") == "active"){
			return;
		}

		var id = $(this).attr("value")
        var params="a="+id+'&'+'s_type=NO_FEEL'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/love/no_feel.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_no_feel//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_no_feel(json){

			if(judgeJson(json)){
				t.parent().attr("class","active")
				t.parent().prev().attr("class","")

				if(judgeJson(json) && json["topic"] != null){

					span = t.children().first()
					span.html(Number(json["topic"]["no"]))

					span = t.parent().prev().children().first().children().first()
					span.html(Number(json["topic"]["yes"]))
				}
			}
		}
	});
	*/

	// ding按钮
	$('a.feel').click(function (){ //直接把onclick事件写在了JS中，而不需要混在XHTML中了 
		t = $(this)
		if(t.parent().attr("class") == "active"){
			return;
		}

		var id = $(this).attr("value")
        var params="a="+id+'&'+'s_type=TAICII_DING'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/love/ding.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_feel//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_feel(json){
			if(judgeJson(json)){
				t.parent().attr("class","active")
				t.parent().next().attr("class","");

				if(json["taicci"] != null){

					span = t.children().last()
					span.html(Number(json["taicci"]["yes"]))

					span = t.parent().next().children().children().last()
					span.html(Number(json["taicci"]["no"]))
				}
			}
		}
	});

	// cai按钮
	$('a.no_feel').click(function (){ //直接把onclick事件写在了JS中，而不需要混在XHTML中了 
		t = $(this)
		if(t.parent().attr("class") == "active"){
			return;
		}

		var id = $(this).attr("value")
        var params="a="+id+'&'+'s_type=TAICII_CAI'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/love/cai.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_no_feel//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_no_feel(json){

			if(judgeJson(json)){
				t.parent().attr("class","active")
				t.parent().prev().attr("class","")

				if(judgeJson(json) && json["taicci"] != null){

					span = t.children().last()
					span.html(Number(json["taicci"]["no"]))

					span = t.parent().prev().children().first().children().last()
					span.html(Number(json["taicci"]["yes"]))
				}
			}
		}
	});

	// top 的解决方案
	// ding按钮
	$('button.feel').live('click',function(){ //直接把onclick事件写在了JS中，而不需要混在XHTML中了 
		t = $(this)
		if(t.parent().attr("class") == "active"){
			return;
		}

		var id = $(this).attr("value")
        var params="a="+id+'&'+'s_type=TAICII_DING'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/love/ding.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_feel//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_feel(json){
			if(judgeJson(json)){
				t.attr("class","feel active")
				t.next().attr("class","no_feel");

				if(json["taicci"] != null){

					span = t.children().last()
					span.html(Number(json["taicci"]["yes"]))

					span = t.next().children().last()
					span.html(Number(json["taicci"]["no"]))
				}
			}
		}
	});

	// cai按钮
	$('button.no_feel').live('click',function(){ //直接把onclick事件写在了JS中，而不需要混在XHTML中了 
		t = $(this)
		if(t.parent().attr("class") == "active"){
			return;
		}

		var id = $(this).attr("value")
        var params="a="+id+'&'+'s_type=TAICII_CAI'
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/love/cai.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: dd_no_feel//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function dd_no_feel(json){

			if(judgeJson(json)){
				t.attr("class","no_feel active")
				t.prev().attr("class","feel")

				if(judgeJson(json) && json["taicci"] != null){

					span = t.children().last()
					span.html(Number(json["taicci"]["no"]))

					span = t.prev().children().last()
					span.html(Number(json["taicci"]["yes"]))
				}
			}
		}
	});

	// 评论隐藏和弹开
	$(".comments").live('click',function(){
	  //$(this).parent().next(".popover-content").toggle(100);
	  $(this).next().next().toggle(300);
	});

	// 提交评论
	$('.comment_button').live('click', function (){	 
		t = $(this)
		var params=$(this).parent().find('input').serialize();
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/comments.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: add_comment//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function add_comment(json){
			if(json == null){
				alert("error")
			}
			
			t.parent().parent().parent().find(".topic_comments").last().append('<table class="comment"><tr class="userInfo"><td><p><i class="icon-comment"></i><b>'
				+ json.creator_name 
				+'</b>'
				+ json.created_at 
				+'</p><div class="rater" id="rate2"></div></td></tr><tr class="comment_body"><td>' 
                + json.body 
                + '</td></tr></table> <hr>');
			//alert(t.parent().html())
			t.prev().attr("value",'');
		}
	});
	
	// 提交一个topic
	$('#topic_button').click(function (){ 
		var params=$('#taicii_id').serialize();
		params = params + '&' + $('#topic_content').serialize();
        //params = params.concat('&').concat($('select').serialize())
        $.ajax({ 
            url:'/topics.json', //后台处理程序 
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:'post', //数据发送方式 
            dataType:'json', //接受数据格式 
            data:params, //要传递的数据 
            success: add_topic//回传函数(这里是函数名) 
        }); 
       	//结果处理
		function add_topic(json){

				if(json == null){
					alert("error")
				}
				$("#topic_new").before('<div class="topic">'
                       + '<img alt="1" class="thumb" src=' + json["user"].avatar + '/>'
                       + '<div class="bs-docs-example bs-docs-example-popover">'
                       +    '<div class="popover left">'
                       +        '<div class="arrow"></div>'
                       +        '<div class="popover-title">'
                       +            '<div class="header">'
                       +                '<h6 class="author"> '+json["topic"].creator_name +'</h6>'
                       +				'<h6 class="say">的选择理由</h6>'
                       +                '<h6 class="date">'+json["topic"].created_at.substr(0,10)+'</h6>'
                       +                '<div class="clear"></div>'
                       +            '</div>'
                       +            '<div class="content">'
                       +                '<a href="#"><h5>'+ json["topic"].content + '</h5></a>'
                       +            '</div>'
                       

                       +        '</div></div></div></div><hr>');
            	$('#topic_content').val('');
		}
	});

});