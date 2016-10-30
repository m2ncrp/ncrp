class rgb {
	r = 0;
	g = 0;
	b = 0;
	a = 0;
	
	constructor(red = 255, green = 255, blue = 255, alpha = 255) 
	{
		this.r = red;
		this.g = green;
		this.b = blue;
		this.a = alpha;
	}
}

CL_WHITE 	<- rgb( 255, 255, 255 );
CL_GRAY		<- rgb( 92,  92,  112 );
CL_RED 		<- rgb( 255, 0,   0   );
CL_GREEN 	<- rgb( 0,   255, 0   );
CL_BLUE 	<- rgb( 0,   0,   255 );
CL_BLACK 	<- rgb( 0,   0,   0   );
CL_YELLOW 	<- rgb( 255, 255, 0   );