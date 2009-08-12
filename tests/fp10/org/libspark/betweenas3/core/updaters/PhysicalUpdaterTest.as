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
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.test;
	
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class PhysicalUpdaterTest
	{
		test function duration():void
		{
			var o:Object = {
				a: 0.0,
				b: 0.0,
				c: 0.0
			};
			
			var u:PhysicalUpdater = new PhysicalUpdater();
			u.target = o;
			u.easing = new TestEasing();
			u.setSourceValue('a', 1.0, false);
			u.setSourceValue('b', 2.0, false);
			u.setSourceValue('c', 3.0, false);
			
			assertEquals(3.0, u.duration);
		}
		
		/**
		 * update
		 */
		test function update():void
		{
			var o:Object = {
				a: 0.0,
				b: 0.0,
				c: 0.0
			};
			
			var u:PhysicalUpdater = new PhysicalUpdater();
			u.target = o;
			u.easing = new TestEasing();
			u.setSourceValue('a', 1.0, false);
			u.setSourceValue('b', 2.0, false);
			u.setSourceValue('c', 3.0, false);
			u.setDestinationValue('a', 3.0, false);
			u.setDestinationValue('b', 4.0, false);
			u.setDestinationValue('c', 5.0, false);
			
			assertEquals(0.0, o.a);
			assertEquals(0.0, o.b);
			assertEquals(0.0, o.c);
			
			u.update(0.0);
			
			assertEquals(0.25, o.a);
			assertEquals(0.75, o.b);
			assertEquals(0.5, o.c);
			
			u.update(0.5);
			
			assertEquals(0.25, o.a);
			assertEquals(0.75, o.b);
			assertEquals(0.5, o.c);
			
			u.update(1.0);
			
			assertEquals(3.0, o.a);
			assertEquals(0.75, o.b);
			assertEquals(0.5, o.c);
			
			u.update(1.5);
			
			assertEquals(3.0, o.a);
			assertEquals(0.75, o.b);
			assertEquals(0.5, o.c);
			
			u.update(2.0);
			
			assertEquals(3.0, o.a);
			assertEquals(4.0, o.b);
			assertEquals(0.5, o.c);
			
			u.update(2.5);
			
			assertEquals(3.0, o.a);
			assertEquals(4.0, o.b);
			assertEquals(0.5, o.c);
			
			u.update(3.0);
			
			assertEquals(3.0, o.a);
			assertEquals(4.0, o.b);
			assertEquals(5.0, o.c);
			
			u.update(3.5);
			
			assertEquals(3.0, o.a);
			assertEquals(4.0, o.b);
			assertEquals(5.0, o.c);
		}
		
		/**
		 * オブジェクトの取得
		 */
		test function getObject():void
		{
			var obj1:Object = new Object();
			var obj2:Object = new Object();
			var o:Object = {
				o1: obj1,
				o2: obj2
			};
			
			var u:IUpdater = new PhysicalUpdater();
			u.target = o;
			
			assertSame(obj1, u.getObject('o1'));
			assertSame(obj2, u.getObject('o2'));
		}
		
		/**
		 * オブジェクトの設定
		 */
		test function setObject():void
		{
			var o:Object = {
				o1: new Object(),
				o2: new Object()
			};
			
			var u:IUpdater = new PhysicalUpdater();
			u.target = o;
			
			var obj1:Object = new Object();
			var obj2:Object = new Object();
			u.setObject('o1', obj1);
			u.setObject('o2', obj2);
			
			assertSame(obj1, o.o1);
			assertSame(obj2, o.o2);
		}
	}
}

import org.libspark.betweenas3.core.easing.IPhysicalEasing;

internal class TestEasing implements IPhysicalEasing
{
	public function getDuration(b:Number, e:Number):Number
	{
		if (b == 1.0) {
			return 1.0;
		}
		if (b == 2.0) {
			return 2.0;
		}
		return 3.0;
	}
	
	public function calculate(t:Number, b:Number, e:Number):Number
	{
		if (b == 1.0) {
			return 0.25;
		}
		if (b == 2.0) {
			return 0.75
		}
		return 0.5;
	}
}