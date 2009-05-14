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
package org.libspark.betweenas3.targets.single
{
	import flash.utils.Dictionary;
	import org.libspark.betweenas3.targets.ITweenTarget;
	import org.libspark.betweenas3.targets.single.AbstractSingleTweenTarget;
	
	/**
	 * 全てのオブジェクトを対象とした ISignelTweenTarget の実装です.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class ObjectTweenTarget extends AbstractSingleTweenTarget
	{
		protected var _target:Object = null;
		protected var _source:Dictionary = new Dictionary();
		protected var _destination:Dictionary = new Dictionary();
		protected var _relativeMap:Dictionary = new Dictionary();
		protected var _isInitialized:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function get target():Object
		{
			return _target;
		}
		
		/**
		 * @private
		 */
		override public function set target(value:Object):void
		{
			_target = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			_source[propertyName] = value;
			_relativeMap['source.' + propertyName] = isRelative;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
		{
			_destination[propertyName] = value;
			_relativeMap['dest.' + propertyName] = isRelative;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getObject(propertyName:String):Object
		{
			return _target[propertyName];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setObject(propertyName:String, value:Object):void
		{
			_target[propertyName] = value;
		}
		
		protected function initialize():void
		{
			var key:String, target:Object = _target, source:Dictionary = _source, dest:Dictionary = _destination, rMap:Dictionary = _relativeMap;
			
			for (key in source) {
				if (dest[key] == undefined) {
					dest[key] = target[key];
				}
				if (rMap['source.' + key]) {
					source[key] += target[key];
				}
			}
			for (key in dest) {
				if (source[key] == undefined) {
					source[key] = target[key];
				}
				if (rMap['dest.' + key]) {
					dest[key] += target[key];
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update(time:Number):void
		{
			if (!_isInitialized) {
				initialize();
				_isInitialized = true;
			}
			
			var factor:Number = 0;
			
			if (time > 0) {
				if (time < _time) {
					factor = _easing.calculate(time, 0.0, 1.0, _time);
				}
				else {
					factor = 1.0;
				}
			}
			
			var invert:Number = 1.0 - factor;
			var t:Object = _target;
			var d:Object = _destination;
			var s:Object = _source;
			var name:String;
			
			for (name in d) {
				t[name] = s[name] * invert + d[name] * factor;
			}
		}
		
		override public function setFrom(o:AbstractSingleTweenTarget):void 
		{
			super.setFrom(o);
			
			var obj:ObjectTweenTarget = o as ObjectTweenTarget;
			
			_target = obj._target;
			copyObject(_source, obj._source);
			copyObject(_destination, obj._destination);
			copyObject(_relativeMap, obj._relativeMap);
			_isInitialized = obj._isInitialized;
		}
		
		private function copyObject(to:Object, from:Object):void
		{
			for (var name:String in from) {
				to[name] = from[name];
			}
		}
		
		override public function clone():ITweenTarget 
		{
			var obj:ObjectTweenTarget = new ObjectTweenTarget();
			obj.setFrom(this);
			return obj;
		}
	}
}