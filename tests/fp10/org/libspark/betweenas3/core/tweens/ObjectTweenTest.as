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
package org.libspark.betweenas3.core.tweens
{
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.test;
	import org.libspark.betweenas3.core.easing.EaseNone;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.core.tweens.IIObjectTween;
	import org.libspark.betweenas3.core.updaters.IUpdater;
	import org.libspark.betweenas3.core.updaters.ObjectUpdater;
	import org.libspark.betweenas3.tweens.IObjectTween;
	
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class ObjectTweenTest
	{
		/**
		 * time の設定
		 */
		test function time():void
		{
			var t:IIObjectTween = new ObjectTween(null);
			assertEquals(0.0, t.time);
			t.time = 4.0;
			assertEquals(4.0, t.time);
		}
		
		/**
		 * easing の設定
		 */
		test function easing():void
		{
			var t:IIObjectTween = new ObjectTween(null);
			assertNull(t.easing);
			var e:IEasing = new EaseNone();
			t.easing = e;
			assertSame(e, t.easing);
		}
		
		/**
		 * updater の設定
		 */
		test function updater():void
		{
			var t:IIObjectTween = new ObjectTween(null);
			assertNull(t.updater);
			var u:IUpdater = new ObjectUpdater();
			t.updater = u;
			assertSame(u, t.updater);
		}
		
		/**
		 * target の取得
		 */
		test function target():void
		{
			var t:IIObjectTween = new ObjectTween(null);
			assertNull(t.target);
			var obj:Object = new Object();
			var u:IUpdater = new ObjectUpdater();
			u.target = obj;
			t.updater = u;
			assertSame(obj, t.target);
		}
		
		/**
		 * update
		 */
		test function update():void
		{
			var t:IIObjectTween = new ObjectTween(null);
			var u:TestUpdater = new TestUpdater();
			var e:IEasing = new EaseNone();
			
			t.time = 4000;
			t.updater = u;
			t.easing = e;
			
			assertTrue(isNaN(u.f));
			
			t.update(0);
			
			assertEquals(0.0, u.f);
			
			t.update(1000);
			
			assertEquals(0.25, u.f);
			
			t.update(2000);
			
			assertEquals(0.5, u.f);
			
			t.update(4000);
			
			assertEquals(1.0, u.f);
			
			t.update(6000);
			
			assertEquals(1.0, u.f);
		}
	}
}

import org.libspark.betweenas3.core.updaters.ObjectUpdater;

internal class TestUpdater extends ObjectUpdater
{
	public var f:Number = NaN;
	
	override protected function updateObject(factor:Number):void 
	{
		f = factor;
	}
}