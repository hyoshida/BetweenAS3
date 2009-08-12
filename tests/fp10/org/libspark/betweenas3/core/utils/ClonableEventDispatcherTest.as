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
package org.libspark.betweenas3.core.utils
{
	import flash.events.Event;
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
	public class ClonableEventDispatcherTest
	{
		test function clone():void
		{
			var d:ClonableEventDispatcher = new ClonableEventDispatcher();
			
			d.addEventListener('e', f1);
			d.addEventListener('e', f2);
			d.addEventListener('e2', f3);
			
			var d2:ClonableEventDispatcher = new ClonableEventDispatcher();
			d2.copyFrom(d);
			
			Static.f1 = false;
			Static.f2 = false;
			Static.f3 = false;
			
			d2.dispatchEvent(new Event('e'));
			
			assertTrue(Static.f1);
			assertTrue(Static.f2);
			assertFalse(Static.f3);
			
			Static.f1 = false;
			Static.f2 = false;
			Static.f3 = false;
			
			d2.dispatchEvent(new Event('e2'));
			
			assertFalse(Static.f1);
			assertFalse(Static.f2);
			assertTrue(Static.f3);
			
			d2.removeEventListener('e', f2);
			
			var d3:ClonableEventDispatcher = new ClonableEventDispatcher();
			d3.copyFrom(d2);
			
			Static.f1 = false;
			Static.f2 = false;
			Static.f3 = false;
			
			d3.dispatchEvent(new Event('e'));
			
			assertTrue(Static.f1);
			assertFalse(Static.f2);
			assertFalse(Static.f3);
		}
		
		private function f1(e:Event):void
		{
			Static.f1 = true;
		}
		
		private function f2(e:Event):void
		{
			Static.f2 = true;
		}
		
		private function f3(e:Event):void
		{
			Static.f3 = true;
		}
	}
}

internal class Static
{
	public static var f1:Boolean;
	public static var f2:Boolean;
	public static var f3:Boolean;
}