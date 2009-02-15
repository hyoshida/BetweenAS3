/*
 * BetweenAS3
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 BeInteractive! (www.be-interactive.org) and
 *                    Spark project  (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package org.libspark.betweenas3.registries
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * クラスレジストリ.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ClassRegistry
	{
		private var _classes:Dictionary = new Dictionary();
		private var _classTreeCache:Dictionary = new Dictionary();
		
		public function registerClassWithTargetClassAndProeprtyName(klass:Class, targetClass:Class, propertyName:String):void
		{
			if (_classes[targetClass] == undefined) {
				_classes[targetClass] = new Dictionary();
			}
			_classes[targetClass][propertyName] = klass;
		}
		
		public function getClassByTargetClassAndPropertyName(targetClass:Class, propertyName:String):Class
		{
			var classes:Dictionary = _classes;
			var tree:Vector.<Class> = getClassTree(targetClass);
			var l:uint = tree.length;
			for (var i:uint = 0; i < l; ++i) {
				var properties:Dictionary = classes[tree[i]] as Dictionary;
				if (properties != null) {
					if (properties[propertyName] != undefined) {
						return properties[propertyName] as Class;
					}
					if (properties['*'] != undefined) {
						return properties['*'] as Class;
					}
				}
			}
			
			return null;
		}
		
		private function getClassTree(klass:Class):Vector.<Class>
		{
			if (_classTreeCache[klass] != undefined) {
				return _classTreeCache[klass] as Vector.<Class>;
			}
			
			var tree:Vector.<Class> = new Vector.<Class>();
			var superClassName:String;
			var c:Class = klass;
			
			while (c != null) {
				tree.push(c);
				if ((superClassName = getQualifiedSuperclassName(c)) != null) {
					try {
						c = getDefinitionByName(superClassName) as Class;
					}
					catch (e:ReferenceError) {
						c = Object;
					}
				}
				else {
					c = null;
				}
			}
			
			_classTreeCache[klass] = tree;
			
			return tree;
		}
	}
}