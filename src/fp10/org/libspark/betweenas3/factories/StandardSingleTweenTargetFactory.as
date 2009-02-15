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
package org.libspark.betweenas3.factories
{
	import org.libspark.betweenas3.classes.ObjectCache;
	import org.libspark.betweenas3.factories.classes.SingleTweenTargetBuilder;
	import org.libspark.betweenas3.registries.ClassRegistry;
	import org.libspark.betweenas3.targets.single.CompositeSingleTweenTarget;
	import org.libspark.betweenas3.targets.single.ISingleTweenTarget;
	
	/**
	 * ISingleTweenTargetFactory の実装.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class StandardSingleTweenTargetFactory implements ISingleTweenTargetFactory
	{
		private var _tweenTargetClassRegistry:ClassRegistry;
		
		// internal なのはテスト用
		internal var _tweenTargetBuilderCache:ObjectCache = new ObjectCache(3, tweenBuilderFactory);
		
		/**
		 * 
		 */
		public function get tweenTargetClassRegistry():ClassRegistry
		{
			return _tweenTargetClassRegistry;
		}
		
		/**
		 * @private
		 */
		public function set tweenTargetClassRegistry(value:ClassRegistry):void
		{
			_tweenTargetClassRegistry = value;
		}
		
		private function tweenBuilderFactory():SingleTweenTargetBuilder
		{
			var builder:SingleTweenTargetBuilder = new SingleTweenTargetBuilder();
			builder.tweenTargetClassRegistry = _tweenTargetClassRegistry;
			return builder;
		}
		
		/**
		 * @inheritDoc
		 */
		public function create(target:Object, to:Object, from:Object):ISingleTweenTarget
		{
			var dest:Object = cloneObject(to);
			var source:Object = cloneObject(from);
			var args:Object = {
				time: getObjectProperty('time', dest, source, 1.0),
				delay: getObjectProperty('delay', dest, source, 0.0)
			};
			
			// TODO: Value filter
			
			var time:uint = uint(args.time * 1000);
			var delay:uint = uint(args.delay * 1000);
			
			var tweenTargetBuilder:SingleTweenTargetBuilder = _tweenTargetBuilderCache.pop() as SingleTweenTargetBuilder;
			
			tweenTargetBuilder.reset(target, time, delay);
			
			var name:String;
			var value:Object;
			var isRelative:Boolean;
			
			// TODO: Tween targets with factory
			
			if (source != null) {
				for (name in source) {
					if ((value = source[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						tweenTargetBuilder.createTweenTarget(name).setSourceValue(name, Number(value), isRelative);
					}
				}
			}
			if (dest != null) {
				for (name in dest) {
					if ((value = dest[name]) is Number) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1);
						}
						tweenTargetBuilder.createTweenTarget(name).setDestinationValue(name, Number(value), isRelative);
					}
				}
			}
			// TODO: Object tween
			
			var tweenTargets:Vector.<ISingleTweenTarget> = tweenTargetBuilder.getCreatedTweenTargets();
			var tweenTarget:ISingleTweenTarget = null;
			
			if (tweenTargets.length == 1) {
				tweenTarget = tweenTargets[0];
			}
			else if (tweenTargets.length > 1) {
				tweenTarget = new CompositeSingleTweenTarget(target, time, delay, tweenTargets);
			}
			
			tweenTargetBuilder.reset(null, 0, 0);
			
			_tweenTargetBuilderCache.push(tweenTargetBuilder);
			
			return tweenTarget;
		}
		
		private function cloneObject(obj:Object):Object
		{
			if (obj == null) {
				return null;
			}
			var cloned:Object = {};
			for (var p:* in obj) {
				cloned[p] = obj[p];
			}
			return cloned;
		}
		
		private function getObjectProperty(name:String, primary:Object, secondary:Object, defaultValue:Object):Object
		{
			var value:Object = defaultValue;
			if (secondary != null && name in secondary) {
				value = secondary[name];
				delete secondary[name];
			}
			if (primary != null && name in primary) {
				value = primary[name];
				delete primary[name];
			}
			return value;
		}
	}
}