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
package org.libspark.betweenas3.factories
{
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.after;
	import org.libspark.as3unit.test;
	import org.libspark.betweenas3.registries.ClassRegistry;
	import org.libspark.betweenas3.targets.single.CompositeSingleTweenTarget;
	import org.libspark.betweenas3.targets.single.ISingleTweenTarget;
	
	use namespace before;
	use namespace after;
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class StandardSingleTweenTargetFactoryTest
	{
		private var _builder:TestSingleTweenTargetBuilder;
		private var _f:StandardSingleTweenTargetFactory;
		
		before function initialize():void
		{
			_builder = new TestSingleTweenTargetBuilder();
			_f = new StandardSingleTweenTargetFactory();
			_f._tweenTargetBuilderCache = new TestObjectCache(_builder);
		}
		
		after function finalize():void
		{
			_f = null;
			_builder = null;
		}
		
		test function createWithDestination():void
		{
			var t:TestTweenTarget = new TestTweenTarget();
			_builder.target = t;
			_builder.targets.push(t);
			
			var obj:Object = new Object();
			var result:ISingleTweenTarget = _f.create(obj, {a: 10, $b: 20, delay: 2.0, time: 3.0}, null);
			
			assertSame(t, result);
			assertEquals(2000, t.delay);
			assertEquals(3000, t.time);
			
			var destA:Object = t.dest['a'];
			var destB:Object = t.dest['b'];
			var srcA:Object = t.source['a'];
			var srcB:Object = t.source['b'];
			
			assertNotNull(destA);
			assertNotNull(destB);
			assertNull(srcA);
			assertNull(srcB);
			
			assertEquals(10, destA.value);
			assertFalse(destA.isRelative);
			assertEquals(20, destB.value);
			assertTrue(destB.isRelative);
		}
		
		test function createWithSource():void
		{
			var t:TestTweenTarget = new TestTweenTarget();
			_builder.target = t;
			_builder.targets.push(t);
			
			var obj:Object = new Object();
			var result:ISingleTweenTarget = _f.create(obj, null, {a: 10, $b: 20, delay: 2.0, time: 3.0});
			
			assertSame(t, result);
			assertEquals(2000, t.delay);
			assertEquals(3000, t.time);
			
			var destA:Object = t.dest['a'];
			var destB:Object = t.dest['b'];
			var srcA:Object = t.source['a'];
			var srcB:Object = t.source['b'];
			
			assertNull(destA);
			assertNull(destB);
			assertNotNull(srcA);
			assertNotNull(srcB);
			
			assertEquals(10, srcA.value);
			assertFalse(srcA.isRelative);
			assertEquals(20, srcB.value);
			assertTrue(srcB.isRelative);
		}
		
		test function createWithDestinationAndSource():void
		{
			var t:TestTweenTarget = new TestTweenTarget();
			_builder.target = t;
			_builder.targets.push(t);
			
			var obj:Object = new Object();
			var result:ISingleTweenTarget = _f.create(obj, {a: 10, $b: 20, delay: 2.0, time: 3.0}, {b: 30, $c: 40, delay: 1.0, time: 2.0});
			
			assertSame(t, result);
			assertEquals(2000, t.delay);
			assertEquals(3000, t.time);
			
			var destA:Object = t.dest['a'];
			var destB:Object = t.dest['b'];
			var destC:Object = t.dest['c'];
			var srcA:Object = t.source['a'];
			var srcB:Object = t.source['b'];
			var srcC:Object = t.source['c'];
			
			assertNotNull(destA);
			assertNotNull(destB);
			assertNull(destC);
			assertNull(srcA);
			assertNotNull(srcB);
			assertNotNull(srcC);
			
			assertEquals(10, destA.value);
			assertFalse(destA.isRelative);
			assertEquals(20, destB.value);
			assertTrue(destB.isRelative);
			assertEquals(30, srcB.value);
			assertFalse(srcB.isRelative);
			assertEquals(40, srcC.value);
			assertTrue(srcC.isRelative);
		}
		
		test function createTweenTargets():void
		{
			var t1:TestTweenTarget = new TestTweenTarget();
			var t2:TestTweenTarget = new TestTweenTarget();
			_builder.target = t1;
			_builder.targets.push(t1);
			_builder.targets.push(t2);
			
			var obj:Object = new Object();
			var result:ISingleTweenTarget = _f.create(obj, {a: 10, $b: 20, delay: 2.0, time: 3.0}, null);
			
			assertTrue(result is CompositeSingleTweenTarget);
			
			var r:CompositeSingleTweenTarget = result as CompositeSingleTweenTarget;
			
			assertEquals(2000, r.delay);
			assertEquals(3000, r.time);
			
			assertSame(t1, r.getSingleTweenTargetAt(0));
			assertSame(t2, r.getSingleTweenTargetAt(1));
		}
	}
}

import org.libspark.betweenas3.factories.classes.SingleTweenTargetBuilder;
import org.libspark.betweenas3.targets.single.AbstractSingleTweenTarget;
import org.libspark.betweenas3.targets.single.ISingleTweenTarget;
import org.libspark.betweenas3.classes.ObjectCache;

internal class TestTweenTarget extends AbstractSingleTweenTarget
{
	private var _target:Object;
	
	public var source:Object = new Object();
	public var dest:Object = new Object();
	
	override public function get target():Object
	{
		return _target;
	}
	
	override public function set target(value:Object):void
	{
		_target = target;
	}
	
	override public function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void
	{
		source[propertyName] = {
			value: value,
			isRelative: isRelative
		};
	}
	
	override public function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void
	{
		dest[propertyName] = {
			value: value,
			isRelative: isRelative
		};
	}
}

internal class TestObjectCache extends ObjectCache
{
	public function TestObjectCache(obj:Object)
	{
		super(0, null);
		
		_obj = obj;
	}
	
	private var _obj:Object;
	
	override public function pop():Object
	{
		return _obj;
	}
}

internal class TestSingleTweenTargetBuilder extends SingleTweenTargetBuilder
{
	public var target:ISingleTweenTarget;
	public var targets:Vector.<ISingleTweenTarget> = new Vector.<ISingleTweenTarget>();
	
	private var _time:uint;
	private var _delay:uint;
	
	override public function reset(t:Object, time:uint, delay:uint):void
	{
		_time = time;
		_delay = delay;
	}
	
	override public function createTweenTarget(propertyName:String):ISingleTweenTarget
	{
		target.time = _time;
		target.delay = _delay;
		return target;
	}
	
	override public function getCreatedTweenTargets():Vector.<ISingleTweenTarget>
	{
		return targets;
	}
}