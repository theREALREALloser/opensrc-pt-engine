/// @description Check if player is colliding, extra checks for ladders
function scr_solid(argument0, argument1) {

	// Store old position
	var old_x = x
	var old_y = y
	x = argument0
	y = argument1

	// Check if I'm over a tile
	if place_meeting(x, y, obj_solid) {
		x = old_x
		y = old_y
		return true
	}

	// Check if I crossed a tile boundary and landed on a platform
	if y > old_y && bbox_bottom % 16 == 0 && !place_meeting(x, old_y, obj_platform) 
	&& place_meeting(x, y, obj_platform) {
		x = old_x
		y = old_y
		return true
	}


	// Check if I'm over a slope
	var slope = instance_place(x, y, obj_slope)
	if slope {
		with slope {
			var object_side = 0
			var slope_start = 0
			var slope_end = 0
	
			if image_xscale > 0 {
				// Slope is facing /|
				object_side = other.bbox_right
				slope_start = bbox_bottom
				slope_end = bbox_top
			} else {
				// Slope is facing |\
				object_side = other.bbox_left
				slope_start = bbox_top
				slope_end = bbox_bottom
			}
		
			// Calculate steepness of slope
			var m = sign(image_xscale) * (bbox_bottom - bbox_top) / (bbox_right - bbox_left)
			var slope = slope_start - round(m * (object_side - bbox_left))
		
			if (other.bbox_bottom >= slope) {
				// Object is inside slope
				other.x = old_x
				other.y = old_y
				return true
			}
		}
	}

	x = old_x
	y = old_y
	return false


}
