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
package org.libspark.betweenas3.tweens
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import org.libspark.betweenas3.events.BetweenEvent;
	import org.libspark.betweenas3.targets.ITweenTarget;
	import org.libspark.betweenas3.tickers.ITicker;
	import org.libspark.betweenas3.tickers.TickerListener;
	
	/**
	 * .
	 * 
	 * @author	yossy:beinteractive
	 */
	public class StandardTween extends TickerListener implements ITween
	{
		public function StandardTween(tweenTarget:ITweenTarget, ticker:ITicker, position:uint)
		{
			_tweenTarget = tweenTarget;
			_ticker = ticker;
			_position = position;
		}
		
		private var _tweenTarget:ITweenTarget;
		private var _ticker:ITicker;
		private var _position:uint;
		private var _startTime:uint;
		private var _isPlaying:Boolean = false;
		private var _dispatcher:IEventDispatcher;
		
		/**
		 * @inheritDoc
		 */
		public function get tweenTarget():ITweenTarget
		{
			return _tweenTarget;
		}
		
		/**
		 * このトゥイーンの継続時間 (ミリ秒) を返します.
		 */
		public function get duration():uint
		{
			return _tweenTarget.duration;
		}
		
		/**
		 * このトゥイーンの現在位置 (ミリ秒) を返します.
		 */
		public function get position():uint
		{
			return _position;
		}
		
		/**
		 * このトゥイーンが現在再生中であれば true, そうでなければ false を返します.
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * このトゥイーンの再生を現在の位置から開始します.
		 */
		public function play():void
		{
			if (!_isPlaying && _position < _tweenTarget.duration) {
				_startTime = _ticker.time;
				_isPlaying = true;
				_ticker.addTickerListener(this);
				if (_dispatcher != null) {
					if (_dispatcher.willTrigger(BetweenEvent.PLAY)) {
						_dispatcher.dispatchEvent(new BetweenEvent(BetweenEvent.PLAY));
					}
				}
			}
		}
		
		/**
		 * このトゥイーンの再生を現在の位置で停止します.
		 */
		public function stop():void
		{
			if (_isPlaying) {
				_isPlaying = false;
				_ticker.removeTickerListener(this);
				if (_dispatcher != null) {
					if (_dispatcher.willTrigger(BetweenEvent.STOP)) {
						_dispatcher.dispatchEvent(new BetweenEvent(BetweenEvent.STOP));
					}
				}
			}
		}
		
		/**
		 * このトゥイーンの再生を指定された位置から開始します.
		 * 
		 * @param	position	再生を開始する位置 (ミリ秒)
		 */
		public function gotoAndPlay(position:uint):void
		{
			// TODO
		}
		
		/**
		 * このトゥイーンの再生を指定された位置で停止します.
		 * 
		 * @param	position	再生を停止する位置 (ミリ秒)
		 */
		public function gotoAndStop(position:uint):void
		{
			// TODO
		}
		
		override public function tick(time:uint):Boolean
		{
			var t:uint = time - _startTime;
			
			_position = t;
			_tweenTarget.update(t);
			
			if (_dispatcher != null) {
				if (_dispatcher.willTrigger(BetweenEvent.UPDATE)) {
					_dispatcher.dispatchEvent(new BetweenEvent(BetweenEvent.UPDATE));
				}
			}
			
			if (t >= _tweenTarget.duration) {
				_position = _tweenTarget.duration;
				_isPlaying = false;
				if (_dispatcher != null) {
					if (_dispatcher.willTrigger(BetweenEvent.COMPLETE)) {
						_dispatcher.dispatchEvent(new BetweenEvent(BetweenEvent.COMPLETE));
					}
				}
				return true;
			}
			
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (_dispatcher == null) {
				_dispatcher = new EventDispatcher(this);
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			if (_dispatcher != null) {
				return _dispatcher.dispatchEvent(event);
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			if (_dispatcher != null) {
				return _dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (_dispatcher != null) {
				_dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			if (_dispatcher != null) {
				return _dispatcher.willTrigger(type);
			}
			return false;
		}
	}
}