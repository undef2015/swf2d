package und.swf2d
{
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	internal class _GCData
	{
		private var _data:ByteArray;
		private var oppos:uint;
		private var pathpos:uint;
		private var pathnum:int;
		
		public function _GCData()
		{
			this._data = new ByteArray();
			this._data.endian = Endian.LITTLE_ENDIAN;
		}
		public function dispose():void
		{
			this._data.length = 0;
			this._data = null;
		}
		public function get changed():Boolean{ return _data.position > 0;}
		public function clear():void
		{
			this._data.position = 0;
			this.pathpos = 0;
			this.pathnum = 0;
		}
		public function b(i:int):_GCData
		{
			this._data.writeByte(i);
			return this;
		}
		public function i32(i:int):_GCData
		{
			this._data.writeInt(i);
			return this;
		}
		public function u32(i:uint):_GCData
		{
			this._data.writeUnsignedInt(i);
			return this;
		}
		public function f32(f:Number):_GCData
		{
			this._data.writeFloat(f);
			return this;
		}
		public function pt(x:Number, y:Number):_GCData
		{
			return f32(x).f32(y);
		}
		public function s(text:String):_GCData
		{
			this._data.writeUTFBytes(text);
			this._data.writeByte(0);
			return this;
		}
		public function color(c:uint):_GCData {return u32(c);}
		public function matrix(m:Matrix):_GCData
		{
			return   f32(m ? m.a : 1)
					.f32(m ? m.b : 0)
					.f32(m ? m.c : 0)
					.f32(m ? m.d : 1)
					.f32(m ? m.tx : 0)
					.f32(m ? m.ty : 0);
		}
		private function _begin(op:int, version:int):_GCData
		{
			b(op).b(version);
			this.oppos = _data.position;
			u32(0);
			return this;
		}
		public function begin(op:int, version:int):_GCData
		{
			start();
			endPath();
			return _begin(op, version);
		}
		//if pathop equal moveTo that think is new path segment
		// fillmode value equal enum D2D1_FILL_MODE
		//path segment flow at "fillmode->moveto, loop lineto,ArcTo(4), cubicCurveTo,curveTo, endwith endpath(5)";
		public function path(pathop:int, version:int, fillmode:int = 0):_GCData
		{
			if(pathpos == 0)
			{
				begin(5, version).b(0);
				pathpos = _data.position;
				u32(0);//for write num path segment
				pathnum = 0;
				if(pathop != 0)//not equal move to
				{
					b(fillmode).b(0).f32(0).f32(0);
					pathnum = 1;
				}
			}
			if(pathop == 0)
			{
				if(pathnum > 0)
					b(5);//end path
				pathnum ++;
				b(fillmode).b(0);
			}
			else
			{
				b(pathop);	
			}
			return this;
		}
		public function endPath():void
		{
			if(pathpos != 0)
			{
				b(5);
				var pos:uint = _data.position;
				_data.position = pathpos;
				u32(pathnum);
				_data.position = pos;
				pathpos = 0;
				pathnum = 0;
				end();
			}
		}
		public function end():_GCData
		{
			var pos:uint = _data.position;
			_data.position = oppos;
			u32(pos - oppos);
			_data.position = pos;
			return this;
		}
		
		private function start():void
		{
			if(changed)return;
			_begin(6, 1).b(1).end();//beign draw
		}
		public function flush():ByteArray
		{
			if(!changed)return null;
			endPath();
			begin(6, 1).b(2).end();//end draw
			return _data;
		}
	}
}