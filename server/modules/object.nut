class Object {	
	function getDistance(object) 
	{
		local p1 = this.getPosition();
		local p2 = object.getPosition();
		
		return getDistanceBetweenPoints3D(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
	}
}