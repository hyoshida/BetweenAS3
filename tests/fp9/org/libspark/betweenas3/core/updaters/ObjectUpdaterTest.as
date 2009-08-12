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
	import org.libspark.betweenas3.core.easing.EaseNone;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.core.tweens.IIObjectTween;
	import org.libspark.betweenas3.tweens.IObjectTween;
	
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class ObjectUpdaterTest
	{
		/**
		 * 終了値のみを設定しての update
		 */
		test function updateWithDestination():void
		{
			var o:Object = {
				a1: 1.0,
				a2: 1.0,
				b1: 8.0,
				b2: 8.0,
				c: 3.0
			};
			
			var u:IUpdater = new ObjectUpdater();
			u.target = o;
			u.setDestinationValue('a1', 6.0, false);
			u.setDestinationValue('a2', 5.0, true);
			u.setDestinationValue('b1', 2.0, false);
			u.setDestinationValue('b2', -6.0, true);
			
			assertEquals(1.0, o.a1);
			assertEquals(1.0, o.a2);
			assertEquals(8.0, o.b1);
			assertEquals(8.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.0);
			
			assertEquals(1.0, o.a1);
			assertEquals(1.0, o.a2);
			assertEquals(8.0, o.b1);
			assertEquals(8.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.25);
			
			assertEquals(2.25, o.a1);
			assertEquals(2.25, o.a2);
			assertEquals(6.5, o.b1);
			assertEquals(6.5, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.5);
			
			assertEquals(3.5, o.a1);
			assertEquals(3.5, o.a2);
			assertEquals(5.0, o.b1);
			assertEquals(5.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(1.0);
			
			assertEquals(6.0, o.a1);
			assertEquals(6.0, o.a2);
			assertEquals(2.0, o.b1);
			assertEquals(2.0, o.b2);
			assertEquals(3.0, o.c);
		}
		
		/**
		 * 開始値のみを設定しての update
		 */
		test function updateWithSource():void
		{
			var o:Object = {
				a1: 6.0,
				a2: 6.0,
				b1: 2.0,
				b2: 2.0,
				c: 3.0
			};
			
			var u:IUpdater = new ObjectUpdater();
			u.target = o;
			u.setSourceValue('a1', 1.0, false);
			u.setSourceValue('a2', -5.0, true);
			u.setSourceValue('b1', 8.0, false);
			u.setSourceValue('b2', 6.0, true);
			
			assertEquals(6.0, o.a1);
			assertEquals(6.0, o.a2);
			assertEquals(2.0, o.b1);
			assertEquals(2.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.0);
			
			assertEquals(1.0, o.a1);
			assertEquals(1.0, o.a2);
			assertEquals(8.0, o.b1);
			assertEquals(8.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.25);
			
			assertEquals(2.25, o.a1);
			assertEquals(2.25, o.a2);
			assertEquals(6.5, o.b1);
			assertEquals(6.5, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.5);
			
			assertEquals(3.5, o.a1);
			assertEquals(3.5, o.a2);
			assertEquals(5.0, o.b1);
			assertEquals(5.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(1.0);
			
			assertEquals(6.0, o.a1);
			assertEquals(6.0, o.a2);
			assertEquals(2.0, o.b1);
			assertEquals(2.0, o.b2);
			assertEquals(3.0, o.c);
		}
		
		/**
		 * 開始値と終了値を設定しての update
		 */
		test function updateWithSourceAndDestination():void
		{
			var o:Object = {
				a1: 5.0,
				a2: 5.0,
				b1: 4.0,
				b2: 4.0,
				c: 3.0
			};
			
			var u:IUpdater = new ObjectUpdater();
			u.target = o;
			u.setSourceValue('a1', 1.0, false);
			u.setSourceValue('a2', -4.0, true);
			u.setSourceValue('b1', 8.0, false);
			u.setSourceValue('b2', 4.0, true);
			u.setDestinationValue('a1', 6.0, false);
			u.setDestinationValue('a2', 1.0, true);
			u.setDestinationValue('b1', 2.0, false);
			u.setDestinationValue('b2', -2.0, true);
			
			assertEquals(5.0, o.a1);
			assertEquals(5.0, o.a2);
			assertEquals(4.0, o.b1);
			assertEquals(4.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.0);
			
			assertEquals(1.0, o.a1);
			assertEquals(1.0, o.a2);
			assertEquals(8.0, o.b1);
			assertEquals(8.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.25);
			
			assertEquals(2.25, o.a1);
			assertEquals(2.25, o.a2);
			assertEquals(6.5, o.b1);
			assertEquals(6.5, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(0.5);
			
			assertEquals(3.5, o.a1);
			assertEquals(3.5, o.a2);
			assertEquals(5.0, o.b1);
			assertEquals(5.0, o.b2);
			assertEquals(3.0, o.c);
			
			u.update(1.0);
			
			assertEquals(6.0, o.a1);
			assertEquals(6.0, o.a2);
			assertEquals(2.0, o.b1);
			assertEquals(2.0, o.b2);
			assertEquals(3.0, o.c);
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
			
			var u:IUpdater = new ObjectUpdater();
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
			
			var u:IUpdater = new ObjectUpdater();
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