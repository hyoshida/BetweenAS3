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
package org.libspark.betweenas3.core.updaters
{
	import flash.utils.Dictionary;
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.after;
	import org.libspark.as3unit.test;
	import org.libspark.betweenas3.core.utils.ClassRegistry;
	
	use namespace before;
	use namespace after;
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class UpdaterFactoryTest
	{
		private var _factory:UpdaterFactory;
		
		before function initialize():void
		{
			var r:ClassRegistry = new ClassRegistry();
			r.registerClassWithTargetClassAndPropertyName(UpdaterA, ClassA, 'a1');
			r.registerClassWithTargetClassAndPropertyName(UpdaterA, ClassA, 'a2');
			r.registerClassWithTargetClassAndPropertyName(UpdaterA, ClassA, 'a3');
			r.registerClassWithTargetClassAndPropertyName(UpdaterB, ClassB, 'a1');
			r.registerClassWithTargetClassAndPropertyName(UpdaterB, ClassB, 'b');
			_factory = new UpdaterFactory(r);
		}
		
		after function finalize():void
		{
			_factory = null;
		}
		
		test function getUpdaterForClassA():void
		{
			var obj:Object = new ClassA();
			var map:Dictionary = new Dictionary();
			var list:Vector.<IUpdater> = new Vector.<IUpdater>();
			
			var u1:IUpdater = _factory.getUpdaterFor(obj, 'a1', map, list);
			var u2:IUpdater = _factory.getUpdaterFor(obj, 'a1', map, list);
			var u3:IUpdater = _factory.getUpdaterFor(obj, 'a2', map, list);
			var u4:IUpdater = _factory.getUpdaterFor(obj, 'b', map, list);
			
			assertTrue(u1 is UpdaterA);
			assertSame(obj, u1.target);
			assertSame(u1, u2);
			assertSame(u1, u3);
			assertNull(u4);
			assertEquals(1, list.length);
			assertSame(u1, list[0]);
		}
		
		test function getUpdaterForClassB():void
		{
			var obj:Object = new ClassB();
			var map:Dictionary = new Dictionary();
			var list:Vector.<IUpdater> = new Vector.<IUpdater>();
			
			var u1:IUpdater = _factory.getUpdaterFor(obj, 'a1', map, list);
			var u2:IUpdater = _factory.getUpdaterFor(obj, 'a1', map, list);
			var u3:IUpdater = _factory.getUpdaterFor(obj, 'a2', map, list);
			var u4:IUpdater = _factory.getUpdaterFor(obj, 'b', map, list);
			
			assertTrue(u1 is UpdaterB);
			assertSame(obj, u1.target);
			assertSame(u1, u2);
			assertTrue(u3 is UpdaterA);
			assertSame(obj, u3.target);
			assertSame(u1, u4);
			assertEquals(2, list.length);
			assertSame(u1, list[0]);
			assertSame(u3, list[1]);
		}
		
		test function createWithDestination():void
		{
			var obj:Object = new ClassA();
			var updater:IUpdater = _factory.create(obj, {a1: 10, $a2: 20}, null);
			
			assertTrue(updater is UpdaterA);
			
			var u:TestUpdater = updater as TestUpdater;
			
			var destA:Object = u.dest['a1'];
			var destB:Object = u.dest['a2'];
			var srcA:Object = u.source['a1'];
			var srcB:Object = u.source['a2'];
			
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
			var obj:Object = new ClassA();
			var updater:IUpdater = _factory.create(obj, null, {a1: 10, $a2: 20});
			
			assertTrue(updater is UpdaterA);
			
			var u:TestUpdater = updater as TestUpdater;
			
			var destA:Object = u.dest['a1'];
			var destB:Object = u.dest['a2'];
			var srcA:Object = u.source['a1'];
			var srcB:Object = u.source['a2'];
			
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
			var obj:Object = new ClassA();
			var updater:IUpdater = _factory.create(obj, {a1: 10, $a2: 20}, {a2: 30, $a3: 40});
			
			assertTrue(updater is UpdaterA);
			
			var u:TestUpdater = updater as TestUpdater;
			
			var destA:Object = u.dest['a1'];
			var destB:Object = u.dest['a2'];
			var destC:Object = u.dest['a3'];
			var srcA:Object = u.source['a1'];
			var srcB:Object = u.source['a2'];
			var srcC:Object = u.source['a3'];
			
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
		
		test function crateComposite():void
		{
			var obj:Object = new ClassB();
			var updater:IUpdater = _factory.create(obj, {a1: 10, a2: 20}, null);
			
			assertTrue(updater is CompositeUpdater);
			
			var composite:CompositeUpdater = updater as CompositeUpdater;
			var u1:IUpdater = composite.getUpdaterAt(0);
			var u2:IUpdater = composite.getUpdaterAt(1);
			
			assertTrue(((u1 is UpdaterA) && (u2 is UpdaterB)) || ((u1 is UpdaterB) && (u2 is UpdaterA)));
		}
		
		test function createLadder():void
		{
			var obj1:ClassA = new ClassA();
			var obj2:ClassA = new ClassA();
			obj1.a1 = obj2;
			
			var updater:IUpdater = _factory.create(obj1, {a1: {a2: 10}}, null);
			
			assertTrue(updater is CompositeUpdater);
			
			var composite:CompositeUpdater = updater as CompositeUpdater;
			var u1:IUpdater = composite.getUpdaterAt(0);
			var u2:IUpdater = composite.getUpdaterAt(1);
			
			assertTrue(u1 is UpdaterA);
			assertTrue(u2 is UpdaterLadder);
			
			var ladder:UpdaterLadder = u2 as UpdaterLadder;
			
			assertSame(u1, ladder.parent);
			assertTrue(ladder.child is UpdaterA);
		}
	}
}

import org.libspark.betweenas3.core.updaters.ObjectUpdater;

internal class TestUpdater extends ObjectUpdater
{
	public var source:Object = new Object();
	public var dest:Object = new Object();
	
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

internal class UpdaterA extends TestUpdater
{
	
}

internal class UpdaterB extends TestUpdater
{
	
}