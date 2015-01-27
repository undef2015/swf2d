package demo
{
	import flash.display.GradientType;
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import und.swf2d.Bitmap2D;
	import und.swf2d.Graphics2D;
	import und.swf2d.TextFormat;
	import und.swf2d.TextLayout;
	import und.swf2d.TextMetrics;
	import und.swf2d.TextOverhangMetrics;

	public class Scence2D
	{
		private static const TEXT1:String = "Adobe AIR, Great work!";
		private static const TEXT2:String = "Thanks for all the AIR's team are doing!";
		private static const TEXT3:String = "In my work, package the Direct2D and DirectWrite API for Stage3D by ANE.\n" +
"The class Graphics2D is main API.\n" +
"Call the static mothed Graphics2D.load at first on the AIR start.\n" +
"When the context3D was initialized, you can create new Graphics2D instance and set the size, at result get a Texture by use to Stage3D.\n" +
"By default the Graphics2 class implents a usually 2-D graphics API, rendering a 2-D geometry, bitmaps and so on. It's so like with flash.display.Graphics.\n" +
"In addition, some new APIs for draw string, like drawText, and drawTextLayout to rendering a text and use SloidColorBrush, BitmapBrush or Gradient brush.\n" +
"Direct2D and DirectWrite is a hardware-accelerated API, so the swf2d API be based on Direct9Ex and Direct10.";
		
		private var g:Graphics2D;
		private var fmt1:TextFormat;
		private var fmt2:TextFormat;
		private var fmt3:TextFormat;
		private var lay1:TextLayout;
		private var bmp:Bitmap2D;
		private var points:Vector.<Vector3D>;
		
		public function Scence2D()
		{
			fmt1 = Graphics2D.createTextFormat("Copperplate Gothic", 55, TextFormat.WEIGHT_BOLD);
			fmt2 = Graphics2D.createTextFormat("Copperplate Gothic", 20);
			fmt3 = Graphics2D.createTextFormat("Papyrus", 12);
			lay1 = Graphics2D.createTextLayout(TEXT3, "Papyrus", 11, 800, 130);
			points = new Vector.<Vector3D>();
			for(var i:int = 0; i < 50; i ++)
			{
				var p:Vector3D = new Vector3D();
				p.x = 1366 * Math.random();
				p.y = 768 * Math.random();
				p.z = 10 + 50 * Math.random();
				p.w = 0.5 + 2 * Math.random();
				points.push(p);
			}
		}
		
		public function get texture():TextureBase{ return g ? g.texture : null; }
		public function create(context3D:Context3D, w:int, h:int):void
		{
//			if(g)g.dispose();
			g = new Graphics2D(context3D, w, h);
			this.bmp = g.createBitmap("fill.png");//Create bitmap2D must after Graphics created;
		}
		public function reszie(w:int, h:int):void
		{
			if(g)g.resize(w, h);
		}
		public function render():void
		{
			// TODO Auto Generated method stub
			g.clear();
			g.beginBitmapFill(this.bmp);
			g.drawText(TEXT1, fmt1, 20, 20, g.width, 90);
			g.endFill();
			
			var m:Matrix = new Matrix();
			m.createGradientBox(25,25, Math.PI/2, 20, 90);
			g.beginGradientFill(GradientType.LINEAR, [0x070606, 0x5e5e5e], [0.8,0.8], [0,255], m);
			g.drawText(TEXT2, fmt2, 30, 90, g.width, 120);
			g.endFill();
			
			var rc:TextMetrics = lay1.getMetrics();
			var w:int = rc.width + 100;
			var h:int = rc.height + 40;
			g.beginFill(0x7fffffff,1);
			g.drawRect(0, (g.height - h)/2, w, h);
			g.endFill();
			g.setTextAntialias(Graphics2D.ANTITEXT_DEFAULT);
			g.beginFill(0xff000000);
			g.drawTextLayout(lay1, 50, (g.height - h)/2 + 20);
			g.endFill();
			
			g.beginFill(0xff000000, 0.2);
			g.drawEllipse(g.width - 120, g.height - 60, 120, 60);
			g.endFill();
			g.beginFill(0xffffffff, 1);
			g.drawText("UnDef 2015",fmt3, g.width - 110, g.height - 45, g.width, g.height);
			g.endFill();
			m.identity();
			m.createGradientBox(g.width, g.height, points[0].x * 2 - g.width/2, points[0].y * 2 - g.height/2);
			g.beginGradientFill(GradientType.RADIAL, [0xffffff, 0xfeffb2, 0xbbffb2], [0.8, 0.8,0.8], [0,127,255], m);
			for(var i:int = 0; i < points.length; i ++)
			{
				var v:Vector3D = points[i];
				v.x += v.w/2;
				v.y += v.w;
				if((v.x - v.z) > g.width)v.x = -v.z;
				if((v.y - v.z) > g.height)v.y  = -v.z;
			
				g.drawCircle(v.x, v.y, v.z);
			}
			g.endFill();
			g.flush();
			
		}
		
		
		
		
		
		
		
	}
}