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
	public class CompositeUpdaterTest
	{
		test function update():void
		{
			var updater1:TestUpdater = new TestUpdater();
			var updater2:TestUpdater = new TestUpdater();
			var updater3:TestUpdater = new TestUpdater();
			var updater4:TestUpdater = new TestUpdater();
			var updater5:TestUpdater = new TestUpdater();
			var updater6:TestUpdater = new TestUpdater();
			
			var updaters:Vector.<IUpdater> = new Vector.<IUpdater>(6);
			updaters[0] = updater1;
			updaters[1] = updater2;
			updaters[2] = updater3;
			updaters[3] = updater4;
			updaters[4] = updater5;
			updaters[5] = updater6;
			
			var composite:CompositeUpdater = new CompositeUpdater(new Object(), updaters);
			
			assertTrue(isNaN(updater1.f));
			assertTrue(isNaN(updater2.f));
			assertTrue(isNaN(updater3.f));
			assertTrue(isNaN(updater4.f));
			assertTrue(isNaN(updater5.f));
			assertTrue(isNaN(updater6.f));
			
			composite.update(0.5);
			
			assertEquals(0.5, updater1.f);
			assertEquals(0.5, updater2.f);
			assertEquals(0.5, updater3.f);
			assertEquals(0.5, updater4.f);
			assertEquals(0.5, updater5.f);
			assertEquals(0.5, updater6.f);
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