package und.swf2d
{
	public class TextLineMetrics
	{
		private var _data:Array;
		public function TextLineMetrics(sa:Array)
		{
			_data = sa;
		}
		public function get  length():uint{ return _data[0];};
		public function get  trailingWhitespaceLength():uint{ return _data[1];};
		public function get  newlineLength():uint{ return _data[2];};
		public function get  height():Number{ return _data[3];};
		public function get  baseline():Number{ return _data[4];};
		public function get  isTrimmed():Boolean{ return _data[5];};
	}
}