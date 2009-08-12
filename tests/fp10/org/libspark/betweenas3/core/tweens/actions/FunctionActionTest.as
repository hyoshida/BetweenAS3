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
	public class FunctionActionTest
	{
		private static function f1(...params:Array):void
		{
			Static.log += 'f1[' + params + '] ';
		}
		private static function f2(...params:Array):void
		{
			Static.log += 'f2[' + params + '] ';
		}
		
		test function action():void
		{
			var tween:FunctionAction = new FunctionAction(null, f1);
			var tester:ActionTweenTester = new ActionTweenTester(tween);
			
			Static.log = '';
			
			tester.doAction();
			
			assertEquals('f1[] ', Static.log);
			
			tester.doRollback();
			
			assertEquals('f1[] ', Static.log);
		}
		
		test function actionWithParams():void
		{
			var tween:FunctionAction = new FunctionAction(null, f1, ['a', 'b', 'c']);
			var tester:ActionTweenTester = new ActionTweenTester(tween);
			
			Static.log = '';
			
			tester.doAction();
			
			assertEquals('f1[a,b,c] ', Static.log);
			
			tester.doRollback();
			
			assertEquals('f1[a,b,c] ', Static.log);
		}
		
		test function actionRollback():void
		{
			var tween:FunctionAction = new FunctionAction(null, f1, null, true);
			var tester:ActionTweenTester = new ActionTweenTester(tween);
			
			Static.log = '';
			
			tester.doAction();
			
			assertEquals('f1[] ', Static.log);
			
			tester.doRollback();
			
			assertEquals('f1[] f1[] ', Static.log);
		}
		
		test function rollback():void
		{
			var tween:FunctionAction = new FunctionAction(null, f1, null, true, f2);
			var tester:ActionTweenTester = new ActionTweenTester(tween);
			
			Static.log = '';
			
			tester.doAction();
			
			assertEquals('f1[] ', Static.log);
			
			tester.doRollback();
			
			assertEquals('f1[] f2[] ', Static.log);
		}
		
		test function rollbackWithParams():void
		{
			var tween:FunctionAction = new FunctionAction(null, f1, null, true, f2, ['a', 'b', 'c']);
			var tester:ActionTweenTester = new ActionTweenTester(tween);
			
			Static.log = '';
			
			tester.doAction();
			
			assertEquals('f1[] ', Static.log);
			
			tester.doRollback();
			
			assertEquals('f1[] f2[a,b,c] ', Static.log);
		}
	}
}

internal class Static
{
	public static var log:String;
}