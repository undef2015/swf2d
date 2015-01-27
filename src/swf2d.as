package
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import demo.Scence2D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import und.swf2d.Graphics2D;
	
	import undef.Log;
	
	[SWF(frameRate="60",backgroundColor="0x000", width="1366", height="768")]
	public class swf2d extends Sprite
	{
		[Embed(source="bg.jpg")]
		private static var Background:Class;
		private var scence2D:Scence2D;
		private var context3D:Context3D;
		
		private var vertex:VertexBuffer3D;
		private var indices:IndexBuffer3D;
		private var program:Program3D;
		private var tex:RectangleTexture;
		
		public function swf2d()
		{
			Graphics2D.load();
			stage.nativeWindow.addEventListener(Event.CLOSE, function(e:*):void
			{
				Graphics2D.unload();
			});
			Log.setup(stage);
			stage.nativeWindow.activate();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var s3d:Stage3D = stage.stage3Ds[0];
			s3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			s3d.requestContext3D("auto", Context3DProfile.BASELINE_EXTENDED);
			
			scence2D = new Scence2D();
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onContext3DCreated(e:Event):void
		{
			this.context3D = stage.stage3Ds[0].context3D;
			Log.print(this.context3D.driverInfo);
			context3D.enableErrorChecking = true;
			
			if(vertex)vertex.dispose();
			if(indices)indices.dispose();
			vertex = context3D.createVertexBuffer(4, 6);
			vertex.uploadFromVector(Vector.<Number>(
				[-1,-1,0, 0,1,1,
					1,-1,0, 1,1,1,
					1,1,0, 1,0,1,
					-1,1,0, 0,0,1]
			), 0, 4);
			indices = context3D.createIndexBuffer(6);
			indices.uploadFromVector(Vector.<uint>(
				[0, 1, 2, 0,2,3]
			), 0, 6);
			
			var avs:AGALMiniAssembler = new AGALMiniAssembler();
			avs.assemble("vertex", "mov op, va0\n mov v1, va1");
			var afs:AGALMiniAssembler = new AGALMiniAssembler();
			afs.assemble("fragment","tex ft0, v1, fs0 <2d,linear,nomip>\n" +
				"div ft0.xyz, ft0.xyz, ft0.w\n" +
				"mov oc, ft0");
			
			if(program)program.dispose();
			program = context3D.createProgram();
			program.upload(avs.agalcode, afs.agalcode);
			
			if(tex)tex.dispose();
			var bmp:BitmapData = (new Background()).bitmapData;
			tex = context3D.createRectangleTexture(bmp.width, bmp.height, Context3DTextureFormat.BGRA, true);
			tex.uploadFromBitmapData(bmp);
			
			scence2D.create(context3D, stage.stageWidth, stage.stageHeight);
			onStageResize();
			
			context3D.setRenderToBackBuffer();
			context3D.setDepthTest(false,Context3DCompareMode.ALWAYS);
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA , Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setVertexBufferAt(0, vertex,0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertex,3, Context3DVertexBufferFormat.FLOAT_3);
		}
		private function onStageResize(e:Event = null):void
		{
			if(!context3D)return;
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			if(w < 100 || h < 100)return;
			context3D.configureBackBuffer(w,h,0,false);
			scence2D.reszie(w, h);
		}
		private function onEnterFrame(e:Event):void
		{
			if(!context3D)return;
			context3D.clear();
			scence2D.render();
			context3D.setProgram(program);
			context3D.setTextureAt(0, tex);
			context3D.drawTriangles(indices, 0, 2);
			if(scence2D.texture)
			{
				context3D.setTextureAt(0, scence2D.texture);
				context3D.drawTriangles(indices, 0, 2);
			}
			context3D.present();
		}
	}
}