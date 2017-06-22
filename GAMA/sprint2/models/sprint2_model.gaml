/**
* Name: Sprint-2
* Author: Amith
* Description: Model with an extra target point which acts as entry/exit.
* Tags:
*/

model test_matrix

global{
	int lamda <- 2 min:1 max: 5 step: 1;
	int k <- 4 min:1 max: 10 step: 1;
	float poisson ;//<- lamda^k * exp(-lamda) / fact(k);

	string algorithm <- "A*" among: ["A*", "Dijkstra", "JPS", "BF"] parameter: true;
	int neighborhood_type <- 8 among:[4,8] parameter: true;
	path my_path <- nil;
	map<cell,float> cell_weights;
	int save_at <- 10000;
	list target_point <- [{7.5,40.5,0},{35.5,45.5,0},{5.5,6.5,0},{45.5,8.5,0},{20,0,0}];//,{100,600,0},{850,550,0}]; 
	int i <- 0;
	int row_nbr <- 50;
	int clm_nbr <- 50;
	int a <- 0;
	int b <- 0;
	int c <- 0;
	int d <- 0;
	int e <- 0;
	//list<geometry> trajectories;
	
	//reflex save when: cycle = save_at{
		//write name;
		//save trajectories to:"../results/trajectory_lambda_" + lamda+ "k_"+ k+"_" +name +  ".csv" type:"csv";
		//save [a,b,c,d,e] to:"../results/freq__lambda_" + lamda+ "k_"+ k+ ".csv" type:"csv";
		//save cell to:"../results/grid__lambda_" + lamda+ "k_"+ k+"_" +name + ".asc" type:"asc";
		//save cell to:"../results/grid__lambda.asc" type:"asc";
		//do pause;
	//}
	 
	
	
	init {    
			create goal number: length(target_point){
					
			point loc <- (target_point at i)*2;
			location <- (loc);//.location;
			//write i;
			//write location;
			i<-i+1;
		}
		cell_weights <- cell as_map (each::each.grid_value);
		create people number: 1 {
			target <- (goal) at 1;//rnd(length(target_point)-1);
			location <-  (one_of (cell).location);
		}
	}
	
}

grid cell width: 50 height: 50 neighbors: neighborhood_type optimizer: algorithm {
	//grid_value <- 0;
} 
	 
species goal {
	
	aspect default { 
		draw circle(1) color: #black;
	}
}  
	
	  
species people skills: [moving] {
	bool target_flag <- false;
	goal target ;//<- one_of (goal);
	float speed <- float(2);
	path my_path ;
	list<geometry> trajectories;
	list<float> p_dist;
	//int lamda <- 1 min:1 max: 4 step: 1;
	//int k <- 1 min:1 max: 5 step: 1;
	float poisson <- lamda^k * exp(-lamda) / fact(k);
	
	aspect default {
		draw circle(1) color: #green;
		if (current_path != nil) {
			draw current_path.shape color: #red;
		}
	}
	action prob_var(float pssn, float p1, float p2, float p3){
		float p_var <- (1 - (p1+p2+p3+pssn));
		//write p_var;
		return p_var;
	}
	reflex change_goal when: target_flag{
		if (target.location distance_to (goal at 0)) <= 2 {
			a <- a + 1;
			float p1 <- 0.01; float p2 <- 0.2; float p3 <- 0.15;
			float p4 <- prob_var(poisson,p1,p2,p3);
			p_dist <- [p1,p2,p3,p4,poisson];
			int var0 <- rnd_choice(p_dist);
			target <-  (goal) at var0;
			target_flag <- false;
		
		}
		
		else if (target.location distance_to (goal at 1)) <= 2{
			b <- b+1;
		float p1 <- 0.2; float p2 <- 0.1; float p3 <- 0.02;
			float p4 <- prob_var(poisson,p1,p2,p3);
			p_dist <- [p2,p3,p4,p1,poisson];
			int var0 <- rnd_choice(p_dist);
		target <-  (goal) at var0;
		target_flag <- false;
		
		}
		else if (target.location distance_to (goal at 2)) <= 2{
			c <- c+1;
		float p1 <- 0.02; float p2 <- 0.25; float p3 <- 0.05;
			float p4 <- prob_var(poisson,p1,p2,p3);
			p_dist <- [p4,p2,p1,p3,poisson];
			int var0 <- rnd_choice(p_dist);
		target <-  (goal) at var0;
		target_flag <- false;
		
		}
		else if(target.location distance_to (goal at 3)) <= 2{ //if target.location = goal at 3{
		d<-d+1;
		float p1 <- 0.1; float p2 <- 0.025; float p3 <- 0.2;
			float p4 <- prob_var(poisson,p1,p2,p3);
			p_dist <- [p3,p1,p4,p2,poisson];
			int var0 <- rnd_choice(p_dist);
		target <-  (goal) at var0;
		target_flag <- false;
		
		}
		else {
			e <- e+1;
			float p1 <- 0.1; float p2 <- 0.25; float p3 <- 0.2;
			float psn <- 0.0;
			float p4 <- prob_var(psn,p1,p2,p3);
			p_dist <- [p4,p3,p2,p1,psn];
			int var0 <- rnd_choice(p_dist);
		target <-  (goal) at var0;
		target_flag <- false;
		}
		//write p_dist;
		
	}
	
	reflex update_gridvalues{
		
			cell(location).grid_value <- cell(location).grid_value + 1;
			
	}
	reflex move {//when: location != target{
		
		
		
		path followed_path <- self  goto (on:cell_weights, target:target, speed:speed, return_path: true,recompute_path: false);//on:(cell),
		list<geometry> segments <- followed_path.segments;
		//write followed_path;
		
		loop line over: segments
		{
			trajectories << line;
			//write trajectories;
		}
		//write segments;			
		//write 'lamda= '+ lamda +'  k=' + k + '  poisson=' +poisson ;
		if int(self distance_to target) <= 2 {
			target_flag <- true;
			my_path <- nil;
			}	
	}
}

experiment goto_grid type: gui {
	parameter 'Lamda' var: lamda min:1 max: 4 step: 1;
	parameter 'K' var: k min:1 max:5 step: 1;
	int sumall <- a+b+c+d+e+1;
	output {
		display objects_display {
			grid cell lines: #black;
			species goal aspect: default ;
			species people aspect: default ;
			graphics "exit" refresh: false {
			draw square(4) at: [{41,0,0}] color: #red;
			
			}
		}
		display Simple_chart {
			chart "Simple Chart" type:histogram{
				data "A" value: a*100/(a+b+c+d+e+1);
				data "B" value: b*100/(a+b+c+d+e+1);
				data "C" value: c*100/(a+b+c+d+e+1);
				data "D" value: d*100/(a+b+c+d+e+1);
				data "E" value: e*100/(a+b+c+d+e+1);
			}
		}
	}
}

experiment goto_gridbatch type: batch repeat: 20 keep_seed:true until: cycle > (save_at) {
	
	parameter 'Lamda' var: lamda min:1 max: 5 step: 1;
	parameter 'K' var: k min:1 max:10 step: 1;
	
	reflex end_of_runs{ //save when: cycle = save_at{
	int cnt <- 0;
		ask simulations {
		//write name;
		
		//write 'lamda= '+ lamda +'  k=' + k + '  poisson=' +poisson ;
		ask people{
		cnt <- cnt +1;	
		save trajectories type:"csv" to:"../results/trajectory/trajectory_lambda-" + lamda+ "+k-"+ k+"_simulation" +cnt +  ".csv";// with:trajectories ;
		
		write cnt;
		}
		//save [a,b,c,d,e] to:"../results/freq__lambda_" + lamda+ "k_"+ k+ ".csv" type:"csv";
		save cell to:"../results/grids/grid__lambda_" + lamda+ "k_"+ k+"_simulation" +cnt + ".asc" type:"asc";
		save [a,b,c,d,e] to:"../results/frequency/freq__lambda_" + lamda+ "k_"+ k+"_simulation" +cnt +  ".csv" type:"csv";
		//save cell to:"../results/grid__lambda.asc" type:"asc";
		//do pause;
		}
	}
	
	/*output {
		display objects_display {
			grid cell lines: #black;
			species goal aspect: default ;
			species people aspect: default ;
		}
		
		display Simple_chart {
			chart "Simple Chart" type:histogram{
				data "A" value: a;
				data "B" value: b;
				data "C" value: c;
				data "D" value: d;
				data "E" value: e;
			}
		}
		*/		
	//} 
}
