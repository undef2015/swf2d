package und.swf2d
{
	//@see IDWriteTextLayout
	public class TextLayout extends TextFormat
	{
		public function TextLayout(h:uint)
		{
			super(h);
		}
		/*Draw	
		GetDrawingEffect
		GetFontCollection
		GetFontFamilyNameLength
		GetInlineObject
		GetTypography	
		SetDrawingEffect
		SetFontCollection
		SetTypography
		*/
		
//		GetClusterMetrics	
		public function getMaxWidth():Number				{ return API.tlivk(this, 1) as Number;} 
		public function setMaxWidth(value:Number):void 	{ API.tlivk(this, 2, value); }
		public function getMaxHeight():Number				{ return API.tlivk(this, 3) as Number;} 
		public function setMaxHeight(value:Number):void	{ API.tlivk(this, 4, value);}
		private var range:TextRange;
		private function fillRange():void
		{
			if(range == null)range = new TextRange();
			range.start = API.IVK_RET[0];
			range.length = API.IVK_RET[1];
		}
		private function get lastGetRange():TextRange{ return range;}
		public function getFontFamilyName(pos:uint):String //out text range
		{
			var ret:String = API.tlivk(this, 5, pos) as String;
			fillRange();
			return ret;
		}
		public function setFontFamilyName(name:String, start:uint, len:uint):void
		{
			API.tlivk(this, 6, name, start, len);
		}
		public function getFontSize(pos:uint):Number
		{
			var ret:Number = API.tlivk(this, 7, pos) as Number;
			fillRange();
			return ret;
		}
		public function setFontSize(size:Number, start:uint, len:uint):void
		{
			API.tlivk(this, 8, size, start, len);
		}
		public function getFontStretch(pos:uint):int
		{
			var ret:int = API.tlivk(this, 9, pos) as int;
			fillRange();
			return ret;
		}
		public function setFontStretch(stretch:int, start:uint, len:uint):void
		{
			API.tlivk(this, 10, stretch, start, len);
		}
		
		public function getFontStyle(pos:uint):int
		{
			var ret:int = API.tlivk(this, 11, pos) as int;
			fillRange();
			return ret;
		}
		public function setFontStyle(style:int, start:uint, len:uint):void
		{
			API.tlivk(this, 12, style, start, len);
		}
		public function getFontWeight(pos:uint):int
		{
			var ret:int = API.tlivk(this, 13, pos) as int;
			fillRange();
			return ret;
		}
		public function setFontWeight(weight:int, start:uint, len:uint):void
		{
			API.tlivk(this, 14, weight, start, len);
		}
		public function getLocaleName(pos:uint):String
		{
			var ret:String = API.tlivk(this, 15, pos) as String;
			fillRange();
			return ret;
		}
		public function setLocaleName(name:String, start:uint, len:uint):void
		{
			API.tlivk(this, 16, name, start, len);
		}
		public function hasStrikethrough(pos:uint):Boolean
		{
			var ret:Boolean = API.tlivk(this, 17, pos) as Boolean;
			fillRange();
			return ret;
		}
		public function setStrikethrough(has:Boolean, start:uint, len:uint):void
		{
			API.tlivk(this, 18, has, start, len);
		}
		public function hasUnderline(pos:uint, range:TextRange = null):Boolean
		{
			var ret:Boolean = API.tlivk(this, 19, pos) as Boolean;
			fillRange();
			return ret;
		}
		public function setUnderline(has:Boolean, start:uint, len:uint):void
		{
			API.tlivk(this, 20, has, start, len);
		}	
		
		public function determineMinWidth():Number{ return API.tlivk(this, 21) as Number; }
		public function getLineMetrics(numLines:uint = 0):Vector.<TextLineMetrics>
		{
			var sa:Array = API.tlivk(this, 22, numLines) as Array;
			if(sa && sa.length > 0)
			{
				var lms:Vector.<TextLineMetrics> = new Vector.<TextLineMetrics>();
				for each(var item:Array in sa)
				{
					lms.push(new TextLineMetrics(item));
				}
				return lms;
			}
			return null;
		}
		
		public function getMetrics():TextMetrics
		{
			var sa:Array = API.tlivk(this, 23) as Array;
			return sa != null && sa.length > 0 ? new TextMetrics(sa) : null;
		}
		public function getOverhangMetrics():TextOverhangMetrics
		{
			var sa:Array = API.tlivk(this, 24) as Array;
			return sa != null && sa.length > 0 ? new TextOverhangMetrics(sa) : null;
		}
		public function hitPoint(x:Number, y:Number):TextHitMetrics
		{
			var sa:Array = API.tlivk(this, 25, x, y) as Array;
			if(sa && sa.length > 0)
			{
				var th:TextHitMetrics = new TextHitMetrics(sa);
				th.isTrailingHit = API.IVK_RET[0];
				th.isInside = API.IVK_RET[1];
				return th;
			}
			return null;
		}
		public function hitTextPostion(pos:uint, isTrailingHit:Boolean):TextHitMetrics
		{
			var sa:Array = API.tlivk(this, 26, pos, isTrailingHit) as Array;
			if(sa && sa.length > 0)
			{
				var th:TextHitMetrics = new TextHitMetrics(sa);
				th.pointX = API.IVK_RET[0];
				th.pointY = API.IVK_RET[1];
				return th;
			}
			return null;
		}
		public function hitTextRange(pos:uint,length:uint,originX:Number,originY:Number):Vector.<TextHitMetrics>
		{
			var sa:Array = API.tlivk(this, 27, pos, length, originX, originY);
			if(sa && sa.length > 0)
			{
				var vects:Vector.<TextHitMetrics> = new Vector.<TextHitMetrics>();
				for each(var it:Array in sa)
				{
					vects.push(new TextHitMetrics(it));
				}
				return vects;
			}
			return null;
		}
	}
}