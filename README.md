# swf2d
In this work, We used direct2D/directWrite API to rendering text, bitmap, geometry to a texture for Stage3D.
Offer Graphics2D api that draw text or geomtry like this:
      g.clear();
			g.beginBitmapFill(this.bmp);
			g.drawText(TEXT1, fmt1, 20, 20, g.width, 90);
			g.endFill();
			
			var m:Matrix = new Matrix();
			m.createGradientBox(25,25, Math.PI/2, 20, 90);
			g.beginGradientFill(GradientType.LINEAR, [0x070606, 0x5e5e5e], [0.8,0.8], [0,255], m);
			g.drawText(TEXT2, fmt2, 30, 90, g.width, 120);
			g.endFill();
			
			.....
			
			g.beginFill(0xff000000, 0.2);
			g.drawEllipse(g.width - 120, g.height - 60, 120, 60);
			g.endFill();
	
			g.flush();
