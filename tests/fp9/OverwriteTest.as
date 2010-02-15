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
package
{
	import flash.display.Sprite;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class OverwriteTest extends Sprite
	{
		public function OverwriteTest()
		{
			for (var i:uint = 0; i < 6; ++i) {
				var button:RollOverButton = new RollOverButton();
				button.y = 20 + 30 * i;
				addChild(button);
			}
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.easing.Sine;

internal class RollOverButton extends Sprite
{
	public function RollOverButton()
	{
		_box = new Shape();
		_box.graphics.beginFill(0);
		_box.graphics.drawRect(0, 0, 80, 20);
		_box.graphics.endFill();
		
		addChild(_box);
		
		addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
	}
	
	private var _box:Shape;
	
	private function rollOverHandler(e:MouseEvent):void
	{
		BetweenAS3.to(_box, {x: 20}, 0.4, Sine.easeOut).play();
	}
	
	private function rollOutHandler(e:MouseEvent):void
	{
		BetweenAS3.to(_box, {x: 0}, 0.4, Sine.easeOut).play();
	}
}