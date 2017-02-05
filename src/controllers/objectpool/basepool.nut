class BasePool {
    obj_list = null;
    
    // Create pool with given size. 1000 objects by default
    constructor (size = 1000, objects = null) {
        if (objects == null) {
            obj_list = {};
            for (local i = 0; i < size; i++) {
                obj_list.rawset(i, null);
            }
            return;
        }

        if (objects.len() == size) {
            obj_list = clone(objects);
            return;
        } else {
            throw "Incompatible sizes";
        }        
    }

    function add(array) {
        local length = obj_list.len() + 1;
        obj_list.rawset(length, array);
    }

    function remove() {
        // Code
    }

    /**
     * Return object index in pool if it was found
     * @param  {[type]} obj [description]
     * @return {[type]}     [description]
     */
    function find(obj) {
        return obj_list.find(obj);
    }

    /**
     * Return object stored info of an object, temporary remove object from pool
     * @param  {[type]} obj [description]
     * @return {void}
     */
    function pull(obj) {
        local idx = find(obj);
        if ( idx != null ) {
            obj_list[idx];
        }
    }

    /**
     * Add object back to pool
     * @param  {[type]} obj [description]
     * @return {[type]}     [description]
     */
    function push(obj) {
        // Code
    }
}


class SizeablePool extends BasePool {
    
    

}




// local pool = BasePool(10);
// pool.add(vehicles);
// pool.hide(id);
// pool.show(id);
// pool.remove(id);

// local objectpool = require("objectpool");
// local myPool = objectpool.new({       
//     maxSize = 10,    // Ensures that no more than 10 objects are cached in the pool (optional)  
//     createObject = function() { // Creates the object (required)   
//         local image = display.newImage("test.png")        
//         image:setReferencePoint(display.TopLeftReferencePoint)    
//     },  

//     onBorrow = function(image) // Initializes (or re-initializes) the object (optional)  
//     {        
//         image.x = 0        
//         image.y = 0    
//     }  
// });  
//     // Not used here, but available: destroyObject, onReturn (both optional)})
//     // Borrow an object from the pool. Triggers createObject, if required, and onBorrow, if it exists.

// local image = myPool:borrowObject();
//     // Return the object to the pool. Always triggers onReturn, if it exists. May trigger destroyObject, if the pool's cache is full (maxSize).myPool:returnObject(image)
//     // Fills the pool's cache, up to maxSize. Optional single argument will override maxSize (useful if maxSize isn't set)myPool:populate() 
//     // or myPool.populate(5)
//     // Empties the pool's cache, destroying all objects.myPool:clear()
