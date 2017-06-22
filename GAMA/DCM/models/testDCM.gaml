/**
* Name: testDCM
* Author: Eoxys-Win10
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model testDCM

global {
	file dem <- file("../includes/vulcano_50.asc");
	geometry shape <- envelope(dem);
	
	string algorithm <- "A*" among: ["A*", "Dijkstra", "JPS", "BF"] parameter: true;
	int neighborhood_type <- 8 among:[4,8] parameter: true;
	path my_path <- nil;
	map<cell,float> cell_weights;
	int save_at <- 1000000;
	list target_point <- [{25.5,5.5,0},{25.5,45.5,0},{10.5,30.5},{35.5,15.5}];//,{5.5,6.5,0},{45.5,8.5,0}];//,{100,600,0},{850,550,0}];
	//list dummy_target <- [{15.5,20.5},{30.5,20.5}]; 
	int i <- 0;
	int j <- 0;
	int row_nbr <- 50;
	int clm_nbr <- 50;
	int a <- 0;
	int b <- 0;
	int c <- 0;
	int d <- 0;
	float b1<- 1.0;
	float b2<- 1.0;
	float atr1 <- 5.0;
	float atr2 <- 4.5;
	float c1 <- b1*atr1;
	float c2 <- b2*atr2;
	
	
	
	init {    
			create goal number: length(target_point){
					
			point loc <- (target_point at i);
			location <- (loc);//.location;
			//write i;
			//write location;
			i<-i+1;
		}
		/*create goalDummy number: length(target_point){
					
			point loc <- (dummy_target at j)*2;
			j<-j+1;
			}*/
		cell_weights <- cell as_map (each::each.grid_value);
		//path var1 <- (target_point at 0)	path_to (target_point at 2);
		//path var2 <- (target_point at 2)	path_to (target_point at 1);
		//write (var1,var2);
		create people number: 1 {
			target <- (goal) at 1;//rnd(length(target_point)-1);
			location <-  (target_point at 2);
		}
	}
	
	reflex save_grid when: cycle = save_at{
		ask people{
		save trajectories to:"../results/trajectory10.csv" type:"csv";
		
		}
		save [a,b,c,d] to:"../results/freq.csv" type:"csv";
		save cell to:"../results/grid10.asc" type:"asc";
		do pause;
	} 
}

grid cell file: dem neighbors: neighborhood_type optimizer: algorithm {
	//grid_value <- 0;
} 
	 
species goal {
	
	aspect default { 
		draw circle(0.5) color: #red;
	}
}  

/*species goalDummy {
	
	aspect default { 
		draw circle(1) color: #red;
	}
}  */
	
	  
species people skills: [moving] {
	bool target_flag <- false;
	int target_flagDummy ;//<- true;
	goal target ;//<- one_of (goal);
	//goalDummy target_dummy;
	float speed <- float(1);
	path my_path ;
	list<geometry> trajectories;
	
	float ch1 <- exp(c1) / (exp(c1)+exp(c2));
	float ch2 <- exp(c2) / (exp(c1)+exp(c2));
	
	aspect default {
		draw circle(0.5) color: #blue;
		if (current_path != nil) {
			draw current_path.shape color: #red;
		}
	}
	
	reflex change_goal when: target_flag{
		if (target.location distance_to (goal at 0)) = 0 {
			a <- a + 1;
			
		int var0 <- rnd_choice([ch1,ch2]);
		target <-  (goal) at (var0 + 2);
		
		target_flagDummy <- 1;
		
		target_flag <- false;
		
		}
		else if (target.location distance_to (goal at 1)) = 0 {
			int var0 <- rnd_choice([ch1,ch2]);
			target <-  (goal) at (var0 + 2);
		
			target_flag <- false;
			
			target_flagDummy <- 0;
		}
		
		else if (target.location distance_to (goal at 2)) = 0{
			target_flag <- false;
			//write target_flagDummy;
			//if (target_flagDummy = 0){
			write target_flagDummy;
		    target <- goal at target_flagDummy;
			//}
			//else{
			//	target <- goal at 0;
			//}
			
		}
		
		
		else if (target.location distance_to (goal at 3)) = 0{
			target_flag <- false;
			//write target_flagDummy;
			//if (target_flagDummy = 0){
			write target_flagDummy;
				target <- goal at target_flagDummy;
			//}
			//else{
			//	target <- goal at 0;
			//}
				
		}
		
		/*else { //if target.location = goal at 3{
		d<-d+1;
		int var0 <- rnd_choice([ch1,ch2]);
		target <-  (goal) at (var0 + 2);
		//dummy_target <- goal at 0;
		target_flag <- false;
		target_flagDummy <- true;
		}*/
		
	}
	
	/*reflex goal_dummy when: target_flagDummy{
		if (target.location distance_to (goal at 2)) <= 2{
			target_flagDummy <- false;
			if (dummy_target = goal at 0){
				target <- goal at 0;
			}
			else{
				target <- goal at 1;
			}
			
		}
		else if (target.location distance_to (goal at 3)) <= 2{
			target_flagDummy <- false;
			if (dummy_target = goal at 0){
				target <- goal at 0;
			}
			else{
				target <- goal at 1;
			}
				
		}
	}*/
	
	reflex update_gridvalues{
		//ask cell{
			//(grid_value at self.location) <- (grid_value at self.location) + 1;
			cell(location).grid_value <- cell(location).grid_value + 1;
			//write cell(location).grid_value;
		//}
	}
	reflex move {//when: location != target{
		
		write ([ch1,ch2]);
		write target;
		path followed_path <- self  goto (on:cell_weights, target:target, speed:speed, recompute_path: false);//on:(cell),
		//write followed_path;
				
		if int(self distance_to target) = 0 {
			target_flag <- true;
			//target_flagDummy <- false;
			my_path <- nil;
			}	
	}
}

experiment goto_grid type: gui {
	output {
		display objects_display {
			grid cell lines: #black;
			species goal aspect: default ;
			species people aspect: default ;
			
			graphics "Simple DCM"{
			draw circle(1) at: (target_point at 0) color: #green;
			draw circle(1) at: (target_point at 1) color: #green;
			}
			
		}
		/*display Simple_chart {
			chart "Simple Chart" type:histogram{
				data "A" value: a;
				data "B" value: b;
				data "C" value: c;
				data "D" value: d;
			}
		}*/
	}
}


