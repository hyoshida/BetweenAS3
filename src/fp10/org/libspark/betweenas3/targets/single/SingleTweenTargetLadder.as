﻿/*
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
	import org.libspark.betweenas3.easing.IEasing;
	import org.libspark.betweenas3.targets.ITweenTarget;
	import org.libspark.betweenas3.targets.single.AbstractSingleTweenTarget;
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class SingleTweenTargetLadder extends AbstractSingleTweenTarget
	{
		public function SingleTweenTargetLadder(target:Object, time:Number, easing:IEasing, parentTweenTarget:ISingleTweenTarget, childTweenTarget:ISingleTweenTarget, propertyName:String)
		{
			_parentTweenTarget = parentTweenTarget;
			_childTweenTarget = childTweenTarget;
			_propertyName = propertyName;
			_target = target;
			_time = time;
			_easing = easing;
		}
		
		private var _target:Object = null;
		private var _parentTweenTarget:ISingleTweenTarget;
		private var _childTweenTarget:ISingleTweenTarget;
		private var _propertyName:String;
		
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
		override public function update(t:Number):void
		{
			_parentTweenTarget.update(t);
			_childTweenTarget.update(t);
			
			_parentTweenTarget.setObject(_propertyName, _childTweenTarget.target);
		}
		
		override public function clone():ITweenTarget 
		{
			var obj:SingleTweenTargetLadder = new SingleTweenTargetLadder(_target, _time, _easing, _parentTweenTarget.clone() as ISingleTweenTarget, _childTweenTarget.clone() as ISingleTweenTarget, _propertyName);
			obj.setFrom(this);
			return obj;
		}
	}
}