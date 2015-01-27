package und.swf2d
{
	public class TextOverhangMetrics
	{
		private var _data:Array;
		public function TextOverhangMetrics(sa:Array)
		{
			_data = sa;
		}
		public function get left():Number{ return _data[0];};
		public function get top():Number{ return _data[1];};
		public function get right():Number{ return _data[2];};
		public function get bottom():Number{ return _data[3];};
	}
}