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
package org.libspark.betweenas3
{
	import org.libspark.betweenas3.factories.ISingleTweenTargetFactory;
	import org.libspark.betweenas3.factories.StandardSingleTweenTargetFactory;
	import org.libspark.betweenas3.registries.ClassRegistry;
	import org.libspark.betweenas3.targets.single.ObjectTweenTarget;
	import org.libspark.betweenas3.tickers.EnterFrameTicker;
	import org.libspark.betweenas3.tickers.ITicker;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.tweens.StandardTween;
	
	// 新しい ITween, ITweenTarget 実装クラスを作った場合、BetweenAS3 クラスにメソッド追加するのは無理なので、
	// HogeTween.hoge(t).play(); という形でそのクラス自体にファクトリメソッドを用意してもらう感じにする (暫定)。
	// そのとき必要になりそうなユーティリティメソッドは BetweenAS3 側で用意する。
	
	// SmartRotation は smartRotation という特殊プロパティを用意する。
	
	/**
	 * @author	yossy:beinteractive
	 */
	public class BetweenAS3
	{
		public static const VERSION:String = '0.00 (Preview)';
		
		// 超とりあえず
		
		private static var _ticker:ITicker;
		private static var _singleTweenTargetFactory:ISingleTweenTargetFactory;
		private static var _tweenTargetClassRegistry:ClassRegistry;
		
		{
			_ticker = new EnterFrameTicker();
			_ticker.start();
			_tweenTargetClassRegistry = new ClassRegistry();
			_tweenTargetClassRegistry.registerClassWithTargetClassAndProeprtyName(ObjectTweenTarget, Object, '*');
			_singleTweenTargetFactory = new StandardSingleTweenTargetFactory();
			_singleTweenTargetFactory.tweenTargetClassRegistry = _tweenTargetClassRegistry;
		}
		
		/**
		 * 新しいトゥイーンを作成します.
		 * 
		 * @param	target	トゥイーンの対象となるオブジェクト
		 * @param	to	トゥイーンのパラメータ (終了値)
		 * @param	from	トゥイーンのパラメータ (開始値)
		 * @return
		 */
		public static function tween(target:Object, to:Object, from:Object = null):ITween
		{
			return new StandardTween(_singleTweenTargetFactory.create(target, to, from), _ticker, 0);
		}
	}
}