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
package org.libspark.betweenas3.targets.single
{
	import org.libspark.betweenas3.easing.IEasing;
	import org.libspark.betweenas3.targets.ITweenTarget;
	
	// target の各プロパティに対する値のセッター、特殊プロパティの処理の提供などが主な役割。
	// 各プロパティといっても、全てのプロパティに対して責任を持つ必要は無く、特殊化したいものだけ処理すればよい。
	// たとえば DisplayObject に対するものであれば、主要な x, y, rotation といったプロパティのみに対する処理だけでも良い。
	// それ以外のプロパティに関しては、全てのプロパティを扱うことができる汎用的な ObjectTweenTarget が責任を持って処理をするので
	// 意識する必要は無い。
	
	/**
	 * ひとつのオブジェクトを対象としたトゥイーンターゲットです.
	 * 
	 * @author	yossy:beinteractive
	 */
	public interface ISingleTweenTarget extends ITweenTarget
	{
		// duration は time + delay
		
		/**
		 * このトゥイーンに掛ける時間 (ミリ秒) を設定します.
		 */
		function get time():uint;
		
		/**
		 * @private
		 */
		function set time(value:uint):void;
		
		/**
		 * このトゥイーンが開始されるまでに掛ける時間 (ミリ秒) を設定します.
		 */
		function get delay():uint;
		
		/**
		 * @private
		 */
		function set delay(value:uint):void;
		
		/**
		 * このトゥイーンで使用するイージングを設定します.
		 */
		function get easing():IEasing;
		
		/**
		 * @private
		 */
		function set easing(value:IEasing):void;
		
		/**
		 * このトゥイーンの対象となるオブジェクトを設定します.
		 */
		function get target():Object;
		
		/**
		 * @private
		 */
		function set target(value:Object):void;
		
		// リファレンス実装
		// if (dest[proeprtyName] == undefined) {
		//     dest[propertyName] = target[proeprtyName];
		// }
		// source[proeprtyName] = isRelative ? target[propertyName] + value : value;
		
		/**
		 * 指定されたプロパティに対するトゥイーンの開始値を設定します.
		 * 
		 * @param	propertyName	設定するプロパティの名前
		 * @param	value	設定する値
		 * @param	isRelative	相対値であれば true, そうでなければ false
		 */
		function setSourceValue(propertyName:String, value:Number, isRelative:Boolean = false):void;
		
		// リファレンス実装
		// if (source[propertyName] == undefined) {
		//     source[propertyName] = target[proeprtyName];
		// }
		// dest[propertyName] = isRelative ? source[propertyName] + value : value;
		
		/**
		 * 指定されたプロパティに対するトゥイーンの終了値を設定します.
		 * 
		 * @param	propertyName	設定するプロパティ名
		 * @param	value	設定する値
		 * @param	isRelative	相対値であれば true, そうでなければ false
		 */
		function setDestinationValue(propertyName:String, value:Number, isRelative:Boolean = false):void;
		
		// トゥイーン値がオブジェクトで指定された場合、そのトゥイーンはさらに別の ISingleTweenTarget によって行われる。
		// そのとき、対象となるオブジェクトの受け渡しを行う必要があるため、この ISingleTweenTarget が対象とする
		// オブジェクト (target) のための特殊化されたゲッター及びセッターを提供する。
		
		// 主に DisplayObject の filters や、SoundChannel の soundTransform で必要になる。
		//
		// getObject('soundTransform'); で SoundChannel の soundTransform が取得でき、
		// setObject('soundTransform', st); で SoundChannel の soundTransform に値を更新後の SoundTransform が
		// 設定できるイメージ。
		
		// 実際のオブジェクトの受け渡し (setObject) は、トゥイーンの更新 (update) を行った後に親に受け渡し (setObject) を行う
		// TweenTargetLadder (ladder=はしご) が子トゥイーンをデコレートして間に入ることにより実現する。
		
		// Bezier2DTweenTarget などは特殊なので専用のファクトリメソッドを登録する方向で。
		// function create(target:Object, to:Object, from:Object, args:Object):ISingleTweenTarget
		// を
		// registerTweenTargetWithFactory(Object, '_bezier', create);
		// で登録する感じ。第二引数は配列ではない。
		// これで target が Object かつ _bezier プロパティがある場合にファクトリメソッドが呼ばれるので
		// パラメータを見てインスタンスを生成する。使用したパラメータは delete で削除しておく。
		// 通常の ISingleTweenTarget は
		// registerTweenTarget(DisplayObject, ['x', 'y', ...], ['_blurFilter', ...], DisplayObjectTweenTarget);
		// で登録。なぜ通常もファクトリメソッド方式にしないかというと、相対指定のプロパティ処理であったりなんだり実装者が書くべき(同じような)コードが増えるため。
		
		/**
		 * 指定されたプロパティのオブジェクトを取得します.
		 * 
		 * @param	propertyName	取得するプロパティ名
		 * @return	対応するオブジェクト
		 */
		function getObject(propertyName:String):Object;
		
		/**
		 * 指定されたプロパティにオブジェクトを代入します.
		 * 
		 * @param	propertyName	設定するプロパティ名
		 * @param	value	設定するオブジェクト
		 */
		function setObject(propertyName:String, value:Object):void;
	}
}