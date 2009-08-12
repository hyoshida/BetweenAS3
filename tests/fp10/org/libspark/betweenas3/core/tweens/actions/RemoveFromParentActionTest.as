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
package org.libspark.betweenas3.core.tweens.actions
{
	import flash.display.Sprite;
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.after;
	import org.libspark.as3unit.test;
	
	use namespace before;
	use namespace after;
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class RemoveFromParentActionTest
	{
		test function action():void
		{
			var parent:Sprite = new Sprite();
			var child:Sprite = new Sprite();
			
			parent.addChild(child);
			
			var tween:RemoveFromParentAction = new RemoveFromParentAction(null, child);
			var tester:ActionTweenTester = new ActionTweenTester(tween);
			
			assertSame(parent, child.parent);
			assertTrue(parent.contains(child));
			
			tester.doAction();
			
			assertNull(child.parent);
			assertFalse(parent.contains(child));
			
			tester.doRollback();
			
			assertSame(parent, child.parent);
			assertTrue(parent.contains(child));
		}
	}
}