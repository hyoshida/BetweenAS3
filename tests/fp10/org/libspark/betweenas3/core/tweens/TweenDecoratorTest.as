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
	import flash.events.Event;
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.after;
	import org.libspark.as3unit.test;
	import org.libspark.betweenas3.events.TweenEvent;
	
	use namespace before;
	use namespace after;
	use namespace test;
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class TweenDecoratorTest
	{
		private var _ticker:TestTicker;
		private var _baseTween:TestTween;
		private var _tween:TweenDecorator;
		
		before function initialize():void
		{
			_ticker = new TestTicker();
			_ticker.t = 1000;
			_baseTween = new TestTween(_ticker, 0);
			_baseTween.d = 3000;
			_baseTween.t = 9999;
			_baseTween.addEventListener(TweenEvent.PLAY, playHandler1);
			_baseTween.addEventListener(TweenEvent.STOP, stopHandler1);
			_baseTween.addEventListener(TweenEvent.UPDATE, updateHandler1);
			_baseTween.addEventListener(TweenEvent.COMPLETE, completeHandler1);
			_tween = new TweenDecorator(_baseTween, 0);
			_tween.addEventListener(TweenEvent.PLAY, playHandler2);
			_tween.addEventListener(TweenEvent.STOP, stopHandler2);
			_tween.addEventListener(TweenEvent.UPDATE, updateHandler2);
			_tween.addEventListener(TweenEvent.COMPLETE, completeHandler2);
			
			Static.log1 = '';
			Static.log2 = '';
		}
		
		private function playHandler1(e:Event):void
		{
			Static.log1 += 'play ';
		}
		
		private function stopHandler1(e:Event):void
		{
			Static.log1 += 'stop ';
		}
		
		private function updateHandler1(e:Event):void
		{
			Static.log1 += 'update ';
		}
		
		private function completeHandler1(e:Event):void
		{
			Static.log1 += 'complete ';
		}
		
		private function playHandler2(e:Event):void
		{
			Static.log2 += 'play ';
		}
		
		private function stopHandler2(e:Event):void
		{
			Static.log2 += 'stop ';
		}
		
		private function updateHandler2(e:Event):void
		{
			Static.log2 += 'update ';
		}
		
		private function completeHandler2(e:Event):void
		{
			Static.log2 += 'complete ';
		}
		
		after function finalize():void
		{
			_tween = null;
			_baseTween = null;
			_ticker = null;
		}
		
		test function duration():void
		{
			assertEquals(3000, _tween.duration);
		}
		
		test function play():void
		{
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals(9999, _baseTween.t);
			
			_tween.play();
			
			assertTrue(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('play update ', Static.log1);
			assertEquals('play update ', Static.log2);
			assertSame(_tween, _ticker.listener);
			assertEquals(0, _baseTween.t);
			
			_ticker.listener.tick(2500);
			
			assertEquals(1500, _baseTween.t);
			assertEquals('play update update ', Static.log1);
			assertEquals('play update update ', Static.log2);
		}
		
		test function playStop():void
		{
			_tween.play();
			_ticker.listener.tick(2500);
			_tween.stop();
			
			var b:Boolean = _ticker.listener.tick(3500);
			
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('play update update stop ', Static.log1);
			assertEquals('play update update stop ', Static.log2);
			assertTrue(b);
		}
		
		test function playComplete():void
		{
			_tween.play();
			var b1:Boolean = _ticker.listener.tick(2500);
			var b2:Boolean = _ticker.listener.tick(4500);
			
			assertFalse(b1);
			assertTrue(b2);
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('play update update update complete ', Static.log1);
			assertEquals('play update update update complete ', Static.log2);
			assertEquals(3500, _baseTween.t);
		}
		
		test function gotoAndPlay():void
		{
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals(9999, _baseTween.t);
			
			_tween.gotoAndPlay(1000);
			
			assertTrue(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('play update ', Static.log1);
			assertEquals('play update ', Static.log2);
			assertSame(_tween, _ticker.listener);
			assertEquals(1000, _baseTween.t);
			
			_ticker.listener.tick(2500);
			
			assertEquals(2500, _baseTween.t);
			assertEquals('play update update ', Static.log1);
			assertEquals('play update update ', Static.log2);
		}
		
		test function gotoAndStop():void
		{
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals(9999, _baseTween.t);
			
			_tween.gotoAndStop(2000);
			
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('update ', Static.log1);
			assertEquals('update ', Static.log2);
			assertNull(_ticker.listener);
			assertEquals(2000, _baseTween.t);
		}
		
		test function playGotoAndStop():void
		{
			_tween.play();
			_ticker.listener.tick(2500);
			_tween.gotoAndStop(2500);
			
			var b:Boolean = _ticker.listener.tick(3500);
			
			assertFalse(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('play update update update stop ', Static.log1);
			assertEquals('play update update update stop ', Static.log2);
			assertTrue(b);
			assertEquals(2500, _baseTween.t);
		}
		
		test function stopOnComplete():void
		{
			_tween.stopOnComplete = false;
			
			_tween.play();
			var b1:Boolean = _ticker.listener.tick(2500);
			var b2:Boolean = _ticker.listener.tick(4500);
			
			assertFalse(b1);
			assertFalse(b2);
			assertTrue(_tween.isPlaying);
			assertFalse(_baseTween.isPlaying);
			assertEquals('play update update update complete update ', Static.log1);
			assertEquals('play update update update complete update ', Static.log2);
			assertEquals(500, _baseTween.t);
		}
		
		test function update():void
		{
			assertEquals(9999, _baseTween.t);
			assertEquals('', Static.log1);
			assertEquals('', Static.log2);
			
			_tween.update(-10);
			
			assertEquals(-10, _baseTween.t);
			assertEquals('update ', Static.log1);
			assertEquals('update ', Static.log2);
			
			_tween.update(0);
			
			assertEquals('update update ', Static.log1);
			assertEquals('update update ', Static.log2);
			assertNull(_ticker.listener);
			assertEquals(0, _baseTween.t);
			
			_tween.update(1000);
			
			assertEquals('update update update ', Static.log1);
			assertEquals('update update update ', Static.log2);
			assertEquals(1000, _baseTween.t);
			
			_tween.update(3000);
			
			assertEquals('update update update update complete ', Static.log1);
			assertEquals('update update update update complete ', Static.log2);
			assertEquals(3000, _baseTween.t);
			
			_tween.update(3500);
			
			assertEquals('update update update update complete update ', Static.log1);
			assertEquals('update update update update complete update ', Static.log2);
			assertEquals(3500, _baseTween.t);
		}
		
		test function updateReverse():void
		{
			assertEquals(9999, _baseTween.t);
			assertEquals('', Static.log1);
			assertEquals('', Static.log2);
			
			_tween.update(3500);
			
			assertEquals(3500, _baseTween.t);
			assertEquals('update complete ', Static.log1);
			assertEquals('update complete ', Static.log2);
			
			_tween.update(3000);
			
			assertEquals('update complete update ', Static.log1);
			assertEquals('update complete update ', Static.log2);
			assertNull(_ticker.listener);
			assertEquals(3000, _baseTween.t);
			
			_tween.update(2000);
			
			assertEquals('update complete update update ', Static.log1);
			assertEquals('update complete update update ', Static.log2);
			assertEquals(2000, _baseTween.t);
			
			_tween.update(0);
			
			assertEquals('update complete update update update complete ', Static.log1);
			assertEquals('update complete update update update complete ', Static.log2);
			assertEquals(0, _baseTween.t);
			
			_tween.update(-10);
			
			assertEquals('update complete update update update complete update ', Static.log1);
			assertEquals('update complete update update update complete update ', Static.log2);
			assertEquals(-10, _baseTween.t);
		}
	}
}

import org.libspark.betweenas3.core.ticker.ITicker;
import org.libspark.betweenas3.core.ticker.TickerListener;
import org.libspark.betweenas3.core.tweens.AbstractTween;

internal class Static
{
	public static var log1:String;
	public static var log2:String;
}

internal class TestTicker implements ITicker
{
	public var t:Number;
	public var listener:TickerListener;
	
	public function get time():Number
	{
		return t;
	}
	
	public function addTickerListener(listener:TickerListener):void
	{
		this.listener = listener;
	}
	
	public function removeTickerListener(listener:TickerListener):void
	{
		if (this.listener == listener) {
			this.listener = null;
		}
	}
	
	public function start():void
	{
		
	}
	
	public function stop():void
	{
		
	}
}

internal class TestTween extends AbstractTween
{
	public function TestTween(ticker:ITicker, pos:Number)
	{
		super(ticker, pos);
	}
	
	public function get d():Number
	{
		return _duration;
	}
	
	public function set d(value:Number):void
	{
		_duration = value;
	}
	
	public var t:Number;
	
	override protected function internalUpdate(time:Number):void 
	{
		t = time;
	}
}