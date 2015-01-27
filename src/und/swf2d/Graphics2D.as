package und.swf2d
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.GraphicsPathCommand;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.SpreadMethod;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Graphics Direct2D/Direct Write API
	 */	
	public class Graphics2D
	{
		public static const ANTITEXT_DEFAULT:int = 0;
		public static const ANTITEXT_CLEARTYPE:int = 1;
		public static const ANTTEXT_GRAYSCALE:int = 2;
		public static const ANTTEXT_ALIASED:int = 3;
		
		public static const ANTI_PER_PRIMIT:int = 0;
		public static const	ANTI_ALIASED:int = 1;
		
		public static const	TEXTOPT_NO_SNAP:int = 0x00000001;
		public static const	TEXTOPT_CLIP:int = 0x00000002;
		public static const	TEXTOPT_NONE:int = 0x00000000;
		
		public static const	MEASURE_NATURAL:int = 0;
		public static const	MEASURE_GDI_CLASSIC:int = 1;
		public static const	MEASURE_GDI_NATURAL:int = 2;
			
		private const TEX_BMP:BitmapData = new BitmapData(1,1);
		public static function load():void
		{
			API.setup();
		}
		public static function unload():void
		{
			API.unsetup();
		}
		public static function createTextFormat(font:String, size:Number, weight:int = TextFormat.WEIGHT_NORMAL, style:int = TextFormat.STYLE_NORMAL, strech:int = TextFormat.STRETCH_NORMAL, local:String = null):TextFormat
		{
			return new TextFormat(API.w2newTextFormat(font, size, weight, style, strech, local));
		}
		public static function createTextLayout(text:String, font:String, size:Number,maxWidth:uint, maxHeight:uint, weight:int = TextFormat.WEIGHT_NORMAL, style:int = TextFormat.STYLE_NORMAL, strech:int = TextFormat.STRETCH_NORMAL,  local:String = null):TextLayout
		{
			return new TextLayout(API.w2newTextLayout(text, font, size, weight, style, strech, local, maxWidth, maxHeight));
		}
		
		internal var _handle:uint;
		private var _tex:RectangleTexture;
		private var _data:_GCData;
		private var _ctx:Context3D;
		private var _w:int, _h:int;
		//TODO: how dispose it, and release all depend for DirectX resource such as Bitmap2D
		public function Graphics2D(ctx:Context3D, w:uint, h:uint)
		{
			this._handle = API.g2newG2D();
			this._data = new _GCData();
			this._ctx  = ctx;
			resize(w, h);
		}
		public function get width():uint{ return _w; }
		public function get height():uint{ return _h; }
		//New API
		public function get texture():TextureBase{ return _tex;}
		public function resize(w:uint, h:uint):void
		{
			if(w == _w && h == _h)return;
			if(_tex)_tex.dispose();
			_tex = null;
			API.g2resize(this, w, h);
			_tex = _ctx.createRectangleTexture(w, h, Context3DTextureFormat.BGRA, true);
			_tex.uploadFromBitmapData(TEX_BMP);
			_w = w;
			_h = h;
		}
		public function createBitmap(filePath:String):Bitmap2D
		{
			var handle:uint = API.g2newBmp(this, filePath);
			return new Bitmap2D(handle);
		}
		public function flush():void
		{
			if(_data.changed)
			{
				var bytes:ByteArray = _data.flush();
				API.g2flush(this, bytes);
				_data.clear();
			}
		}
		public function drawText(text:String,fmt:TextFormat, left:Number, top:Number, right:Number, bottom:Number, options:int = TEXTOPT_NONE, measureMode:int = MEASURE_NATURAL):void
		{
			if(fmt && fmt._handle)
				_data.begin(7,1).b(1).u32(fmt._handle).f32(left).f32(top).f32(right).f32(bottom).b(options).b(measureMode).s(text).end();
		}
		public function drawTextLayout(layout:TextLayout, left:Number, top:Number, options:int = TEXTOPT_NONE):void
		{
			if(layout && layout._handle)
				_data.begin(7,1).b(2).u32(layout._handle).f32(left).f32(top).b(options).end();
		}
		public function setTextAntialias(value:int):void
		{
			_data.begin(6, 1).b(4).b(value).end();
		}
		public function setAntialias(value:int):void
		{
			_data.begin(6, 1).b(5).b(value).end();
		}
		public function setTransform(matrix:Matrix):void
		{
			_data.begin(6, 1).b(3).matrix(matrix).end();
		}
		
		//Old API 
		public function clear():void
		{
			_data.clear();
			_data.begin(6, 1).b(0).color(0).end(); //clear
		}
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			_data.begin(3, 1).f32(alpha).color(color).end();
		}
		public function beginBitmapFill(bitmap:Bitmap2D, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			//D2D1_BITMAP_INTERPOLATION_MODE
			//D2D1_EXTEND_MODE
			var exmode:int = repeat ? 1 : 0;
			_data.begin(1,1).u32(bitmap.handle).b(smooth ? 1 : 0).b(exmode).b(exmode).matrix(matrix).end();
		
		}
		private const SCALE:Number = 1638.4;
		private function gradient(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String,focalPointRatio:Number):void
		{
			var w:Number = 1, h:Number = 1, tx:Number = 0, ty:Number = 0;
			var a:Number = 1, b:Number = 0, c:Number  = 0, d:Number = 1;
			
			if(matrix != null)
			{
				a = matrix.a*SCALE;
				b = matrix.b*SCALE;
				c = matrix.c*SCALE;
				d = matrix.d*SCALE;
				
				w = Math.sqrt(a*a + c*c);// length of Point (a,c)
				h = Math.sqrt(b*b + d*d);// length of Point (b,d)
				
				tx = matrix.tx - w/2;
				ty = matrix.ty - h/2;
			}
			if(type == GradientType.LINEAR) //@see ID2D1LinearGradientBrush
			{
				_data.b(1);
				_data.pt(tx, ty);			//Start Point
				_data.pt(a + tx, b + ty);	//End Point Point(a,b) from by rotate(w,0)
			}
			else //@see ID2D1RadialGradientBrush
			{
				_data.b(2);
				_data.pt(tx + w/2, ty + h/2);//Ellipse's Center
				_data.pt(a * focalPointRatio, b * focalPointRatio);//Offset the Center relative to the Center
				_data.f32(w/2).f32(h/2); //RadiusX, RadiusY
			}
			_data.b(interpolationMethod == InterpolationMethod.LINEAR_RGB ? 1 : 0);//@see D2D1_GAMMA
			switch(spreadMethod)//
			{
				case SpreadMethod.PAD:		 _data.b(0); break;
				case SpreadMethod.REFLECT: 	_data.b(2); break;
				case SpreadMethod.REPEAT: 	_data.b(1); break;
			}
			var len:int = colors.length;
			_data.u32(len);
			for(var i:int = 0; i < len; i ++)
			{
				var color:uint = (uint(colors[i]) & 0xffffff) | ((uint(alphas[i] * 0xff) & 0xff) << 24);
				_data.u32(color);
				_data.f32(ratios[i]/0xff);
			}
			
		}
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void
		{
			_data.begin(2, 1);
			gradient(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			_data.end();
		}
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void
		{
			_data.begin(4, 1).b(3);
			gradient(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			_data.end();
		}
		public function lineBitmapStyle(bitmap:Bitmap2D, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			var exmode:int = repeat ? 1 : 0;
			_data.begin(4, 1).b(2).u32(bitmap.handle).b(smooth ? 1 : 0).b(exmode).b(exmode).matrix(matrix).end();
		}
		//igored scaleMode
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			if(isNaN(thickness))
			{
				_data.begin(4, 1).b(4).end();
				return;
			}
			_data.begin(4, 1).b(1).f32(thickness).f32(alpha).color(color);
			//@see D2D1_CAP_STYLE
			switch(caps)
			{
				case CapsStyle.ROUND: 	_data.b(2);break;
				case CapsStyle.SQUARE: 	_data.b(1); break;
				default: _data.b(0); break;
			}
			//@see D2D1_LINE_JOIN
			switch(joints)
			{
				case JointStyle.BEVEL:_data.b(1); break;
				case JointStyle.ROUND:_data.b(2); break;
				default: _data.b(0); break;
			}
			_data.f32(miterLimit);
			_data.end();
		}
		
		public function endFill():void
		{
			_data.begin(0,1).end();
		}
		public function lineTo(x:Number, y:Number):void
		{
			_data.path(1,1).f32(x).f32(y);
		}
		public function moveTo(x:Number, y:Number):void
		{
			_data.path(0,1).f32(x).f32(y);
		}
		public function cubicCurveTo(controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number):void
		{
			_data.path(2,1).pt(controlX1,controlY1).pt(controlX2,controlY2).pt(anchorX,anchorY);
		}
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_data.path(3,1).pt(controlX,controlY).pt(anchorX, anchorY);
		}
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd"):void
		{
			var fillMode:uint = winding == "evenOdd" ? 1 : 0;
			var i:int = 0;
			var len:uint = commands.length;
			for(var n:uint = 0; n < len; n ++)
			{
				switch(commands[i])
				{
					case GraphicsPathCommand.MOVE_TO: 
						_data.path(0,1, fillMode).pt(data[i++], data[i++]);
						break;
					case GraphicsPathCommand.CURVE_TO: 
						_data.path(3,1, fillMode).pt(data[i++],data[i++]).pt(data[i++],data[i++]);
						break;
					case GraphicsPathCommand.CUBIC_CURVE_TO: 
						_data.path(2,1, fillMode).pt(data[i++],data[i++]).pt(data[i++],data[i++]).pt(data[i++],data[i++]);
						break;
					case GraphicsPathCommand.LINE_TO: 
						_data.path(1,1, fillMode).pt(data[i++],data[i++]);
						break;
					//no impl
					/*case GraphicsPathCommand.WIDE_LINE_TO: 
						break;
					case GraphicsPathCommand.WIDE_MOVE_TO: 
						break;*/
				}
			}
		}
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			_data.begin(5, 1).b(4).f32(x).f32(y).f32(radius).end();
		}
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			_data.begin(5, 1).b(3).f32(x).f32(y).f32(width).f32(height).end();
		}
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			_data.begin(5, 1).b(1).f32(x).f32(y).f32(width).f32(height).end();
		}
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):void
		{
			_data.begin(5, 1).b(2).f32(x).f32(y).f32(width).f32(height).f32(ellipseWidth).f32(ellipseHeight).end();
		}
		//no impl api
		/*public function drawGraphicsData(graphicsData:Vector.<IGraphicsData>):void
		{
		}
		public function drawTriangles(vertices:Vector.<Number>, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = "none"):void
		{
		}
		*/
	}
}