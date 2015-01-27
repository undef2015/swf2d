package und.swf2d
{
	//@see Interface IDWriteTextFormat 
	public class TextFormat
	{
		private static const CH_TRIM:Trimming = new Trimming();
		private static const CH_LINESPACE:LineSpcaing = new LineSpcaing();
		
		public static const WRAP:int = 0;
		public static const WRAP_NO:int = 1;
		
		public static const PALIGN_NEAR:int = 0;
		public static const PALIGN_FAR:int = 1;
		public static const PALIGN_CENTER:int = 2;
		
		public static const ALIGN_LEADING:int = 0;
		public static const ALIGN_TRAILING:int = 1;
		public static const ALIGN_CENTER:int = 2;
		
		public static const READING_L2R:int = 0;
		public static const READING_R2L:int = 1;
		
		public static const TRIM_NONE:int = 0;
		public static const TRIM_CHARACTER:int = 1;
		public static const TRIM_WORD:int = 2;
		
		public static const LINE_SPACE_DEFAULT:int = 0;
		public static const LINE_SPACE_UNIFORM:int = 1;
		
		public static const STRETCH_UNDEFINED:int         = 0;
		public static const STRETCH_ULTRA_CONDENSED:int   = 1;
		public static const STRETCH_EXTRA_CONDENSED:int   = 2;
		public static const STRETCH_CONDENSED:int         = 3;
		public static const STRETCH_SEMI_CONDENSED:int   = 4;
		public static const STRETCH_NORMAL:int            = 5;
		public static const STRETCH_MEDIUM:int           = 5;
		public static const STRETCH_SEMI_EXPANDED:int    = 6;
		public static const STRETCH_EXPANDED:int         = 7;
		public static const STRETCH_EXTRA_EXPANDED:int   = 8;
		public static const STRETCH_ULTRA_EXPANDED:int    = 9; 
		
		public static const STYLE_NORMAL:int   = 0;
		public static const STYLE_OBLIQUE:int   = 1;
		public static const STYLE_ITALIC:int   = 2; 
		
		public static const WEIGHT_THIN:int          = 100;
		public static const WEIGHT_EXTRA_LIGHT:int   = 200;
		public static const WEIGHT_ULTRA_LIGHT:int   = 200;
		public static const WEIGHT_LIGHT:int         = 300;
		public static const WEIGHT_NORMAL:int        = 400;
		public static const WEIGHT_REGULAR:int       = 400;
		public static const WEIGHT_MEDIUM :int       = 500;
		public static const WEIGHT_DEMI_BOLD:int     = 600;
		public static const WEIGHT_SEMI_BOLD:int     = 600;
		public static const WEIGHT_BOLD:int          = 700;
		public static const WEIGHT_EXTRA_BOLD:int    = 800;
		public static const WEIGHT_ULTRA_BOLD:int    = 800;
		public static const WEIGHT_BLACK:int         = 900;
		public static const WEIGHT_HEAVY:int         = 900;
		public static const WEIGHT_EXTRA_BLACK:int   = 950;
		public static const WEIGHT_ULTRA_BLACK:int   = 950;
		
		internal var _handle:uint;
		public function TextFormat(h:uint)
		{
			_handle = h;
		}
		/*We're ignored this readonly properties
		fontCollection	
		fontFamilyName	
		fontFamilyNameLength	
		fontSize	
		fontStretch	
		fontStyle	
		fontWeight	
		localeName	
		localeNameLength	
		*/
		/*flowDirection ignored because only value is  DWRITE_FLOW_DIRECTION_TOP_TO_BOTTOM */
		
		public function getIncrementalTabStop():Number				{ return API.tfivk(this, 1) as Number;}
		public function setIncrementalTabStop(value:Number):void	{ API.tfivk(this, 2, value);}
		public function getWordWrapping():int						{ return API.tfivk(this, 3) as int; }
		public function setWordWrapping(value:int):void				{ API.tfivk(this, 4, value); }
		public function getTextAlignment():int 						{ return API.tfivk(this, 5) as int;}
		public function setTextAlignment(value:int):void			{ API.tfivk(this, 6, value); }
		public function getParagraphAlignment():int					{ return API.tfivk(this, 7) as int; }
		public function setParagraphAlignment(value:int):void		{ API.tfivk(this, 8, value);  }
		public function getReadingDirection():int					{ return API.tfivk(this, 9) as int;}
		public function setReadingDirection(value:int):void			{ API.tfivk(this, 10, value); }
		
		public function getTrimming():Trimming
		{
			if(API.tfivk(this, 11))
			{
				CH_TRIM._options = API.IVK_RET[0];
				CH_TRIM._delimiter = API.IVK_RET[1];
				CH_TRIM._numDelimiters = API.IVK_RET[2];
				return CH_TRIM;
			}
			return null;
		}
		public function setTrimming(options:int, delimiter:uint, numDelimiter:uint):void
		{
			API.tfivk(this, 12, options, delimiter, numDelimiter);
		}
		public function getLineSpacing():LineSpcaing
		{
			if(API.tfivk(this, 13))
			{
				CH_LINESPACE._type = API.IVK_RET[0];
				CH_LINESPACE._linespacing = API.IVK_RET[1];
				CH_LINESPACE._baseline = API.IVK_RET[2];
				return CH_LINESPACE;
			}
			return null;
		}
		public function setLineSpacing(type:int, lineSpacing:Number, baseLine:Number):void
		{
			API.tfivk(this, 14, type, lineSpacing, baseLine);
		}
	}
}