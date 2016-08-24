class point {
	x = 0.0;
	y = 0.0;
	z = 0.0;

	constructor(x = 0.0, y = 0.0, z = 0.0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	function equals(p) 
	{
		if (this.x == p.x && this.y == p.y && this.z == p.z) {
			return true;
		} 
		return false;
	}

	function isNull()
	{
		return this.equals(point());
	}

	function encode()
	{
		return {x = this.x, y = this.y, z = this.z};
	}
}

class p3 extends point{};

class Area3D {
	a = 0;
	b = 0;
	type = 0;
	
	constructor(p1, p2) 
	{
		if (!(p2 instanceof point)) {this.type = 1;}
		this.a = p1;
		this.b = p2;
	}
	
	function contains(p) 
	{
		if (!(p instanceof point)) {p = p.getPosition();}
		
		if (this.type) {
			return isPointInCircle3D(p.x, p.y, p.z, this.a.x, this.a.y, this.a.z, this.b);
		} else {
			return isPointInArea3D(p.x, p.y, p.z, this.a.x, this.a.y, this.a.z, this.b.x, this.b.y, this.b.z);
		}
	}
}

class Area2D {
	a = 0;
	b = 0;

	constructor(p1, p2)
	{
		this.a = p1;
		this.b = p2;
	}

	function contains(p)
	{
		if (!(p instanceof point)) p = p.getPosition();
		return isPointInArea2D(p.x, p.y, this.a.x, this.b.y, this.b.x, this.a.y); // replaced b & a, Magic
	}
}