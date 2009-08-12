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
	public class UpdaterLadderTest
	{
		test function update():void
		{
			var o1:Object = new Object();
			var o2:Object = new Object();
			var obj:Object = {
				child: o1
			};
			
			var parent:TestUpdater = new TestUpdater();
			parent.target = obj;
			
			var child:TestUpdater = new TestUpdater();
			child.target = o2;
			
			var ladder:UpdaterLadder = new UpdaterLadder(parent, child, 'child');
			
			assertTrue(isNaN(parent.f));
			assertTrue(isNaN(child.f));
			
			ladder.update(0.5);
			
			assertTrue(isNaN(parent.f));
			assertEquals(0.5, child.f);
			assertSame(o2, obj.child);
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