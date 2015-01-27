package und.swf2d
{
	public class TextMetrics
	{
		private var _data:Array;
		public function TextMetrics(sa:Array)
		{
			_data = sa;
		}
		public function get left():Number{ return _data[0];};
		public function get top():Number{ return _data[1];};
		public function get width():Number{ return _data[2];};
		public function get widthIncludingTrailingWhitespace():Number{ return _data[3];};
		public function get height():Number{ return _data[4];};
		public function get layoutWidth():Number{ return _data[5];};
		public function get layoutHeight():Number{ return _data[6];};
		public function get maxBidiReorderingDepth():uint{ return _data[7];};
	}
}