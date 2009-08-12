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
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.*;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.utils.TimeUtil;
	
	/**
	 * @author	yossy:beinteractive
	 */
	[SWF(width = 550, height = 400, frameRate = 30, backgroundColor = 0xffffff)]
	public class FrameTweenTest extends Sprite
	{
		[Embed(source = 'assets/Rocket.swf', symbol = 'RocketAnimation')]
		public static const RocketAnimation:Class;
		
		public function FrameTweenTest()
		{
			setupBackground();
			
			var mc1:MovieClip = new RocketAnimation();
			var mc2:MovieClip = new RocketAnimation();
			var mc3:MovieClip = new RocketAnimation();
			
			mc1.x = 47.5;
			mc2.x = 47.5 + 120 + 47.5;
			mc3.x = 47.5 + 120 + 47.5 + 120 + 47.5;
			
			mc1.stop();
			mc2.stop();
			mc3.stop();
			
			addChild(mc1);
			addChild(mc2);
			addChild(mc3);
			
			_t = BetweenAS3.parallel(
				BetweenAS3.tween(mc1, {_frame: mc1.totalFrames}, {_frame: 0}, TimeUtil.getTotalFramesTime(mc1), Linear.easeNone),
				BetweenAS3.tween(mc2, {_frame: mc2.totalFrames}, {_frame: 0}, TimeUtil.getTotalFramesTime(mc2), Cubic.easeOut),
				BetweenAS3.tween(mc3, {_frame: mc3.totalFrames}, {_frame: 0}, TimeUtil.getTotalFramesTime(mc3), Exponential.easeOut)
			);
			
			_t.play();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler)
		}
		
		private var _t:ITween;
		
		private function setupBackground():void
		{
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			_t.togglePause();
		}
	}
}