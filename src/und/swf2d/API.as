package und.swf2d
{
	import flash.utils.ByteArray;
	

	internal class API
	{
		private static var anecall:Function;
		public static function setup():void
		{
			anecall = ANE.call;
			anecall("Setup");
		}
		public static function unsetup():void
		{
			ANE.dispose();
		}
		public static function g2newG2D():uint
		{
			return uint(anecall("D2D", 1));
		}
		public static function g2resize(g:Graphics2D, w:uint, h:uint):void
		{
			anecall("D2D", 2, g._handle, w, h);
		}
		public static function g2newBmp(g:Graphics2D, filePath:String):uint
		{
			return uint(anecall("D2D", 3,g._handle,  filePath));
		}
		public static function g2flush(g:Graphics2D, bytes:ByteArray):void
		{
			anecall("D2D", 4, g._handle,  bytes, bytes.position);
		}
		
		public static function w2newTextFormat(font:String, size:Number, weight:int, style:int, strech:int, local:String):uint
		{
			return uint(anecall("DW", 1, font, size, weight, style, strech, local));
		}
		public static function w2newTextLayout(text:String, font:String, size:Number, weight:int, style:int, strech:int, local:String, maxwidth:uint,maxheight:uint):uint
		{
			return uint(anecall("DW", 2, font, size, weight, style, strech, local, text, maxwidth,maxheight ));
		}
		public static const IVK_RET:Array = new Array();
		public static function tfivk(tf:TextFormat, m:uint, ... params):*
		{
			return anecall("TF", tf._handle, m, IVK_RET, params);  	
		}
		public static function tlivk(tl:TextLayout, m:uint, ... params):*
		{
			return anecall("TL", tl._handle, m, IVK_RET, params);  	
		}
		
		public function API()
		{
		}
		
	}
}