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
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.after;
	import org.libspark.as3unit.test;
	
	use namespace before;
	use namespace after;
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class AbstractActionTweenTest
	{
		test function action():void
		{
			var tween:TestActionTween= new TestActionTween();
			
			Static.log = '';
			
			tween.update(0);
			
			assertEquals('', Static.log);
			
			tween.update(1);
			
			assertEquals('action ', Static.log);
			
			tween.update(2);
			
			assertEquals('action ', Static.log);
			
			tween.update(1);
			
			assertEquals('action ', Static.log);
			
			tween.update(0);
			
			assertEquals('action rollback ', Static.log);
			
			tween.update(-1);
			
			assertEquals('action rollback ', Static.log);
		}
	}
}

import org.libspark.betweenas3.core.tweens.AbstractActionTween;

internal class Static
{
	public static var log:String;
}

internal class TestActionTween extends AbstractActionTween
{
	public function TestActionTween()
	{
		super(null);
	}
	
	override protected function action():void 
	{
		Static.log += 'action ';
	}
	
	override protected function rollback():void 
	{
		Static.log += 'rollback ';
	}
}