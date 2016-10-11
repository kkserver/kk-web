
kk = {};

/**
 * 基类
 */
(function(kk){
	
	kk.Object = function(){};
	kk.Object.prototype.init = function() { return this; };
	
	kk.get = function(object,key) {
		
		var keys;
		if(key instanceof Array) {
			keys = key;
		}
		else {
			keys = key.split(".");
		}
		
		var v = object;
		
		while(keys.length >0 ){
			key = keys.shift();
			if(typeof v == 'object') {
				v = v[key];
			}
			else {
				return;
			}
		}
		
		return v;
	};
	
	kk.set = function(object,key,value) {
		
		var keys;
		if(key instanceof Array) {
			keys = key;
		}
		else {
			keys = key.split(".");
		}
		
		var v = object;
		
		while(keys.length >0 ){
			
			key = keys.shift();
			
			if(keys.length == 0) {
				v[key] = value;
			}
			else {
				var vv = v[key];
				if(typeof vv != 'object') {
					vv = {};
					v[key] = vv;
				}
				v = vv;
			}
			
		}
	};
	
	kk.remove = function(object,key) {
		
		var keys;
		if(key instanceof Array) {
			keys = key;
		}
		else {
			keys = key.split(".");
		}
		
		var v = object;
		
		while(keys.length >0 ){
			
			key = keys.shift();
			
			if(keys.length == 0) {
				delete v[key];
			}
			else {
				var vv = v[key];
				if(typeof vv != 'object') {
					return;
				}
				v = vv;
			}
			
		}
		
	};
	
})(kk);

/**
 * 事件
 */
(function(kk){
	
	kk.Event = function(){};
	
	kk.Event.prototype = new kk.Object();
	
	kk.Event.prototype.init = function() {
		kk.Object.prototype.init.apply(this,arguments);
		this._fns = [];
		return this;
	};
	
	kk.Event.prototype.on = function(pattern,fn) {
		this._fns.push({ pattern : pattern , fn : fn});
	};
	
	kk.Event.prototype.off = function(pattern,fn) {
		var fns = [];
		for(var i in this._fns) {
			var f = this._fns[i];
			if((pattern === null || pattern == f.pattern) 
					&& (fn === null || f.fn == fn)) {
				
			}
			else {
				fns.push(f);
			}
		}
		this._fns = fns;
	};
	
	kk.Event.prototype.emit = function(name) {
		
		var args = [];
		
		for(var i=1;i<arguments.length;i++) {
			args.push(arguments[i]);
		}
		
		var fns = [];
		
		for(var i in this._fns) {
			var f = this._fns[i];
			if(typeof f.pattern == 'object') {
				if(f.pattern.test(name)) {
					fns.push(f);
				}
			}
			else {
				if(f.pattern == name) {
					fns.push(f);
				}
			}
		}
		
		for(var i in fns) {
			var f = fns[i];
			f.fn.apply(this,args);
		}
		
	};
	
})(kk);


/**
 * 视图
 * @param kk
 */
(function(kk){
	
	var stringValue = function(v) {
		if(v === undefined || v === null) {
			return '';
		}
		else if(typeof v == 'string') {
			return v;
		}
		return v + '';
	};
	
	var elementValue = function(element,v) {
		var fn = element.getAttribute("kk-fn");
		if(fn != null) {
			try {
				fn = eval(fn);
			}
			catch(e){};
			if(typeof fn == 'function') {
				v = fn.call(this.element,v);
			}
		}
		return v;
	};
	
	var Bind  = function() {};
	
	Bind.prototype = new kk.Object();
	
	Bind.prototype.init = function(element) {
		kk.Object.prototype.init.apply(this,arguments);
		this.element = element;
		this.views = [];
		if(this.element.nodeType == 3) {
			this.text = this.element.textContent;
		}
		return this;
	};
	
	Bind.prototype.set = function(object,view) {
		
		if(this.element.changing) {
			return;
		}
		
		if(this.element.nodeType == 3) {
			
			this.element.textContent = this.text.replace(/\{\{([a-zA-Z0-9_\.]*?)\}\}/g,function(match,key){
				var v = kk.get(object,key);
				return stringValue(v);
			});
			
		}
		else {
			
			var key = this.element.getAttribute("kk-each");
			
			if(typeof key == 'string') {
				
				var v = kk.get(object,key);
				v = elementValue(this.element,v);
				var vs;
				
				if(v instanceof Array) {
					vs = v;
				}
				else {
					vs = [v];
				}
				
				var i=0;
				
				for(i=0;i<vs.length;i++) {
					v = vs[i];
					var vv;
					if(i < this.views.length) {
						vv = this.views[i];
						vv.parent = view;
						vv.baseKey = view.absoluteKey(key + '.' + i);
						
						if(v instanceof Object) {
							vv.set(v);
						}
						else {
							vv.set('text',v);
						}
					}
					else {
						vv = kk.view(this.element.cloneNode(true));
						vv.parent = view;
						vv.baseKey = view.absoluteKey(key + '.' + i);
						
						if(v instanceof Object) {
							vv.set(v);
						}
						else {
							vv.set('text',v);
						}
						
						$(vv.element).removeClass("kk-view");
						if(this.element.parentNode) {
							this.element.parentNode.insertBefore(vv.element,this.element);
						}
						this.views.push(vv);
					}
					
				}
				
				while(i < this.views.length) {
					var vv = this.views.pop();
					if(vv.element.parentNode) {
						vv.element.parentNode.removeChild(vv.element);
					}
				}
				
			}
			else {
				key = this.element.getAttribute("kk-key");
				if(typeof key == 'string') {
					var v = kk.get(object,key);
					v = elementValue(this.element,v);
					if(this.element.value === undefined){
						this.element.textContent = stringValue(v);
					}
					else {
						this.element.value = stringValue(v);
					}
				}
			}
			
		}
		
	};
	
	var Relationship = function(){};
	
	Relationship.prototype = new kk.Object();
	
	Relationship.prototype.init = function() {
		kk.Object.prototype.init.apply(this,arguments);
		this.binds = [];
		this.relationship = {};
		return this;
	};
	
	Relationship.prototype.set = function(object,view,dispatch) {
		for(var i in this.binds) {
			var bind = this.binds[i];
			bind.set(object,view);
		}
		if(dispatch) {
			for(var key in this.relationship) {
				var v = this.relationship[key];
				v.set(object,view,dispatch);
			}
		}
	};
	
	kk.View = function(){};
	
	kk.View.prototype = new kk.Event();
	
	kk.View.prototype.init = function(element) {
		kk.Event.prototype.init.apply(this,arguments);
		this.object = {};
		this.relationship = (new Relationship()).init();
		this.element = element;
		
		var p = element.firstChild;
		
		while(p) {
			this.relation(p);
			p = p.nextSibling;
		}
		
		var me = this;
		
		$(element).on("change",function(e){
			var element = e.target;
			var key = element.getAttribute("kk-key");
			if(typeof key == 'string') {
				kk.set(me.object,key,element.value);
				var k = me.absoluteKey(key);
				var v = me;
				while(v.parent) {
					v = v.parent;
				}
				element.changing = true;
				v.change(k);
				delete element.changing;
				v.emit("change",{key : k, object: v.object, element: element, view : me});
			}
			e.stopPropagation();
		});
		
		return this;
	};
	
	kk.View.prototype.absoluteKey = function(key) {
		if(this.parent === undefined) {
			return key;
		}
		return this.baseKey + '.' + key;
	};

	kk.View.prototype.bind = function(key,bind) {
		
		var keys;
		
		if(key instanceof Array) {
			keys = key;
		}
		else {
			keys = key.split(".");
		}
		
		var r = this.relationship;
		
		while(keys.length > 0) {
			
			key = keys.shift();
			
			var v = r.relationship[key];
			
			if(v === undefined) {
				v = (new Relationship()).init();
				r.relationship[key] = v;
			}
			
			v.binds.push(bind);
			
			r = v;
		}
		
	};
	
	kk.View.prototype.relation = function(element) {
		
		if(element.nodeType == 3) {
			
			var v;
			var me = this;
			
			element.textContent.replace(/\{\{([a-zA-Z0-9\._]*?)\}\}/g
					,function(match,key){
				
				var i = key.indexOf(",");
				
				if(i >=0){
					key = key.substr(0,i);
				}
				
				if(v === undefined) {
					v = (new Bind()).init(element);
				}
				
				me.bind(key,v);
			});
			
		}
		else if(element.nodeType == 1) {
			
			var key = element.getAttribute("kk-each");
			
			if(typeof key == 'string') {
				this.bind(key,(new Bind()).init(element));
			}
			else {
				
				key = element.getAttribute("kk-key");
				if(typeof key == 'string') {
					this.bind(key,(new Bind()).init(element));
				}
				
				var p = element.firstChild;
				
				while(p) {
					this.relation(p);
					p = p.nextSibling;
				}
				
			}
			
		}
	};
	
	kk.View.prototype.change = function(key) {
		
		if(key === undefined) {
			this.relationship.set(this.object,this,true);
			return ;
		}
		
		var keys;
		
		if(typeof key == 'string') {
			keys = key.split(".");
		}
		else if(key instanceof Array){
			keys = key;
		}
		else {
			return ;
		}
		
		var r = this.relationship;
		
		while(keys.length > 0) {
			
			if(r !== undefined ) {
				r.set(this.object,this);
			}
			
			var key = keys.shift();
		
			if(keys.length == 0) {
				if(r !== undefined) {
					r = r.relationship[key];
					if(r !== undefined) {
						r.set(this.object,this);
					}
				}
			}
			else {
				if(r !== undefined) {
					r = r.relationship[key];
				}
			}
		}
	};
	
	kk.View.prototype.set = function(key,value) {
		
		if(key instanceof Object && value === undefined) {
			
			this.object = key;
			
			this.relationship.set(this.object,this,true);
			
			return;
		}
		
		kk.set(this.object,key,value);
		
		this.change(key);
		
	};

	kk.view = function(element) {
		if(typeof element == 'string') {
			var v = document.createElement('div');
			v.innerHTML = element;
			element = v;
		}
		return (new kk.View()).init(element);
	};
	
})(kk);

