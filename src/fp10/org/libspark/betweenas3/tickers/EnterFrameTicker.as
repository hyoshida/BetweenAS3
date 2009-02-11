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
package org.libspark.betweenas3.tickers
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 毎フレームコールバックを行う ITicker の実装です.
	 * 
	 * @author	yossy:beinteractive
	 */
	public class EnterFrameTicker implements ITicker
	{
		private static var _shape:Shape = new Shape();
		
		public function EnterFrameTicker()
		{
			_tickerHolderPaddings = new Array(10);
			
			var prevHolder:TickerListenerHolder = null;
			
			for (var i:uint = 0; i < 10; ++i) {
				var holder:TickerListenerHolder = new TickerListenerHolder();
				holder.listener = new NullTickerListener();
				if (prevHolder != null) {
					prevHolder.next = holder;
					holder.prev = prevHolder;
				}
				prevHolder = holder;
				_tickerHolderPaddings[i] = holder;
			}
		}
		
		private var _first:TickerListenerHolder = null;
		private var _numListeners:uint = 0;
		private var _tickerHolderPaddings:Array;
		
		/**
		 * @inheritDoc
		 */
		public function addTickerListener(listener:ITickerListener):void
		{
			var holder:TickerListenerHolder = new TickerListenerHolder();
			
			holder.listener = listener;
			
			if (_first != null) {
				holder.next = _first;
				_first.prev = holder;
			}
			
			_first = holder;
			
			++_numListeners;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeTickerListener(listener:ITickerListener):void
		{
			var holder:TickerListenerHolder = _first;
			
			while (holder != null) {
				
				if (holder.listener == listener) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					else {
						_first = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				
				holder = holder.next;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function start():void
		{
			_shape.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			_shape.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		// internal なのはテストのため
		
		/**
		 * @private
		 */
		internal function update(e:Event):void
		{
			// リスナの数を 8 の倍数になるようにパディングして 8 個ずつ一気にループさせる
			
			var t:uint = getTimer();
			var n:uint = 8 - (_numListeners % 8);
			var holder:TickerListenerHolder = _tickerHolderPaddings[0] as TickerListenerHolder;
			var h:TickerListenerHolder = _tickerHolderPaddings[n] as TickerListenerHolder;
			
			// このようにつなぎかえることでパディングの数を変える
			if ((h.next = _first) != null) {
				_first.prev = h;
			}
			
			while (holder.next != null) {
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
				if ((holder = holder.next).listener.tick(t)) {
					if (holder.prev != null) {
						holder.prev.next = holder.next;
					}
					if (holder.next != null) {
						holder.next.prev = holder.prev;
					}
					--_numListeners;
				}
			}
			
			// 元に戻す
			if ((_first = h.next) != null) {
				_first.prev = null;
			}
			h.next = _tickerHolderPaddings[n + 1] as TickerListenerHolder;
		}
	}
}

import org.libspark.betweenas3.tickers.ITickerListener;

internal class TickerListenerHolder
{
	public var listener:ITickerListener;
	public var next:TickerListenerHolder;
	public var prev:TickerListenerHolder;
}