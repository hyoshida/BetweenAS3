﻿/*
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
	import flash.events.IEventDispatcher;
	import org.libspark.betweenas3.targets.ITweenTarget;
	
	// EventDispatcher は委譲 & 遅延生成で実装しましょう。
	
	/**
	 * トゥイーン及びその制御.
	 * 
	 * @author	yossy:beinteractive
	 */
	public interface ITween extends IEventDispatcher
	{
		/**
		 * 制御の対象となるトゥイーンターゲットを設定します.
		 */
		function get tweenTarget():ITweenTarget;
		
		/**
		 * @private
		 */
		function set tweenTarget(value:ITweenTarget):void;
		
		/**
		 * このトゥイーンの継続時間 (ミリ秒) を返します.
		 */
		function get duration():uint;
		
		/**
		 * このトゥイーンの現在位置 (ミリ秒) を返します.
		 */
		function get position():uint;
		
		/**
		 * このトゥイーンが現在再生中であれば true, そうでなければ false を返します.
		 */
		function get isPlaying():Boolean;
		
		/**
		 * このトゥイーンの再生を現在の位置から開始します.
		 */
		function play():void;
		
		/**
		 * このトゥイーンの再生を現在の位置で停止します.
		 */
		function stop():void;
		
		/**
		 * このトゥイーンの再生を指定された位置から開始します.
		 * 
		 * @param	position	再生を開始する位置 (ミリ秒)
		 */
		function gotoAndPlay(position:uint):void;
		
		/**
		 * このトゥイーンの再生を指定された位置で停止します.
		 * 
		 * @param	position	再生を停止する位置 (ミリ秒)
		 */
		function gotoAndStop(position:uint):void;
	}
}