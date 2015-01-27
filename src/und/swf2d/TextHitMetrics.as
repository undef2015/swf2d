package und.swf2d
{
	public class TextHitMetrics
	{
		private var _data:Array;
		public function TextHitMetrics(sa:Array)
		{
			_data = sa;
		}
		public var isTrailingHit:Boolean;
		public var isInside:Boolean;
		public var pointX:Number;
		public var pointY:Number;
		
		public function get textPosition():uint{ return _data[0];};
		public function get length():uint{ return _data[1];};
		public function get left():Number{ return _data[2];};
		public function get top():Number{ return _data[3];};
		public function get width():Number{ return _data[4];};
		public function get height():Number{ return _data[5];};
		public function get bidiLevel():uint{ return _data[6];};
		public function get isText():Boolean{ return _data[7];};
	}
}