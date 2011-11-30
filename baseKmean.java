
import java.io.*;
public class baseKmean{

	public static final double PERCENT_OF_TRAIN = 0.01;
	public static final int NUM_OF_K = 5;//number of activities
	public static final int NUM_OF_FEATURES = 7;
	public static final double SIMILARITY_THRESHOLD = 0.1;
	public static  int NUM_OF_Q  =  0;
	public static double[][] mu = new double[NUM_OF_K][NUM_OF_FEATURES];
	public static double[] init_num = new double[NUM_OF_K]; 
	public static final int STILL = 0;
	public static final int WALKING = 1;
	public static final int BIKING = 2;
	public static final int RUNNING = 3;
	public static final int DRIVING = 4;

	public static double[][] baseSet = new double[100000][NUM_OF_FEATURES+1];
	public static double[][] trainSet = new double[100000][NUM_OF_FEATURES+1];
	public static double[] uncertainty = new double[100000];
	public static double[][] distance = new double[100000][NUM_OF_K];


	public static void calEuclideanDistance(double[] d, double[] distanceOut){
		//feature array in, distance for each cluster out

		for(int j = 0; j < NUM_OF_K; j++){	
			double squareSum = 0.0;
			for(int i = 0 ; i < NUM_OF_FEATURES; i++){
				squareSum += (d[i] - mu[j][i]) * (d[i]-mu[j][i]);	
			}

			distanceOut[j] = Math.sqrt(squareSum);
		}
	}

	public static void dumpAllMean(double[][] m){
		for (int i = 0;  i < NUM_OF_K; i++){
			System.out.print(init_num[i]+":\n");
			for (int j = 0; j < NUM_OF_FEATURES ; j++){
				System.out.println(m[i][j]);
			}

			System.out.println("");
		}

	}
	public static int nearestK(double[] d, double[][] m){
		double min = Double.MAX_VALUE;
		int min_index = -1;
		for(int i = 0; i < NUM_OF_K; i++){

			double dist = 0;
			for(int j = 0 ; j < NUM_OF_FEATURES;j++){
				dist += ((d[j] - m[i][j]) *(d[j]-m[i][j]));

			}
			dist = Math.sqrt(dist);

			if(dist < min){
				min = dist;
				min_index = i;
			}
		}

		return min_index;
	}
	public static double similarityCount(double[] d){
		double closeness = 0;
		double min = Double.MAX_VALUE;

		for(int i = 0; i < NUM_OF_K; i++){
			for (int j = i+1; j < NUM_OF_K; j++){

				closeness = Math.abs(d[i]-d[j]);
				if (closeness  < min ){
					min = closeness;

				}
			}
		}
		return min;
	}
	public static void dumpAllSet(double[][] a, int s){
		for(int i = 0; i < s; i++){
			for(int j= 0 ;j< NUM_OF_FEATURES+1;j++){
				System.out.print(a[i][j]+ " ");
			}
		System.out.println("");
		}
	
	}
	public static void dumOneSample(double[] a){
		
			for(int j= 0 ;j< NUM_OF_FEATURES+1;j++){
				System.out.print(a[j]+ " ");
			}
		System.out.println("");
		
	
	}
	public static void testPerformance(int a, double[][] m, int type)throws Exception{
		FileInputStream tstream = new FileInputStream("test");
		DataInputStream test = new DataInputStream(tstream);
		BufferedReader br = new BufferedReader (new InputStreamReader(test));
		String strLine;
		int counter = 0;
		int correct = 0;
		while((strLine = br.readLine())!= null){
			String featureSeg[] =  strLine.split(",");

			int gt = Integer.parseInt(featureSeg[NUM_OF_FEATURES]);
			double[] oneFeature = new double[NUM_OF_FEATURES];
			for(int i = 0 ; i < NUM_OF_FEATURES;i++){
				oneFeature[i] = Double.parseDouble(featureSeg[i]);
			}
			int prediction = nearestK(oneFeature,m);
			if(prediction == gt) {correct++;}
			counter++;
		}
		if(type == 0){//not random//
			System.out.println("accuracy: "+ a+"  " +(double) correct/counter);		
		}else{
			System.out.println("random accuracy: "+ a+"  " +(double) correct/counter);	
		}
		test.close();
		
	}

	public static void main(String args[])throws Exception{

		

		FileInputStream fstream = new FileInputStream("train");
		DataInputStream in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader (new InputStreamReader(in));
		String strLine;

		int baseSet_counter = 0;
		int trainSet_counter = 0;
		while((strLine = br.readLine())!= null){


			String featureSeg[] =  strLine.split(",");

			double r = Math.random();
			if(r <= PERCENT_OF_TRAIN){
				int gt = Integer.parseInt(featureSeg[NUM_OF_FEATURES]);
				for (int i = 0; i < NUM_OF_FEATURES + 1;i++){
					double seg = Double.parseDouble(featureSeg[i]);
					baseSet[baseSet_counter][i] = seg;
					   if(i < NUM_OF_FEATURES){
						   double n = init_num[gt];
					       mu[gt][i] = ((mu[gt][i] * n) + Double.parseDouble(featureSeg[i]))/(n+1);	
					   }
				}
				++init_num[gt];
				++baseSet_counter;
				
			}else{
				for(int i = 0 ; i < NUM_OF_FEATURES + 1;i++){	
					double seg = Double.parseDouble(featureSeg[i]);
					trainSet[trainSet_counter][i] = seg;
				}
				++trainSet_counter;
			}
		}
		in.close();	
		int NUM_OF_TRAINSET = trainSet_counter;
		
		//dumpAllSet(baseSet,baseSet_counter);
		
		
		double[] r_k_num = new double [NUM_OF_K];
		double[][] r_mu = new double[NUM_OF_K][NUM_OF_FEATURES];
		for(int i = 0; i < NUM_OF_K;i++){
			r_k_num[i] = init_num[i];
			for(int j = 0; j < NUM_OF_FEATURES;j++){
				r_mu[i][j] = mu[i][j];
			}
		}
		
		for(int i = 0 ; i < NUM_OF_TRAINSET; i++){
			for (int j = 0; j < NUM_OF_K;j++){
				double dis = 0;
				for(int l = 0; l < NUM_OF_FEATURES;l++){
					dis += (trainSet[i][l] - mu[j][l])*(trainSet[i][l]- mu[j][l]);
				}
				distance[i][j] = Math.sqrt(dis);
			}
			uncertainty[i] = similarityCount(distance[i]);
		}

					///////**adaptive learning**/////////////
		for(int a = 0; a < NUM_OF_TRAINSET;a++){	

			testPerformance(a,mu,0);
			
			double min = Double.MAX_VALUE;
			int min_index = 0;

			for(int i = 0; i < NUM_OF_TRAINSET; i++){
				if(uncertainty[i] < min){
					min = uncertainty[i];
					min_index = i;
				}
			}
			
			
			int g = (int)(trainSet[min_index][NUM_OF_FEATURES]);
			double n = init_num[g];
			for(int i = 0; i < NUM_OF_FEATURES;i++){
				mu[g][i] = (mu[g][i] * n + trainSet[min_index][i])/(n+1);
			}
			init_num[g]++;
			uncertainty[min_index] = Double.MAX_VALUE;

			
			
			for(int i = 0 ; i < NUM_OF_TRAINSET; i++){
				for (int j = 0; j < NUM_OF_K;j++){
					double dis = 0;
					for(int l = 0; l < NUM_OF_FEATURES;l++){
						dis += (trainSet[i][l] - mu[j][l])*(trainSet[i][l]- mu[j][l]);
					}
					distance[i][j] = Math.sqrt(dis);
				}
				if(uncertainty[i] < 100){
					uncertainty[i] = similarityCount(distance[i]);
				}
			}
			
			
		}
		testPerformance(NUM_OF_TRAINSET,mu,0);
		
				 ///////**end of adaptive learning**/////////////
						///////**random**/////////////
		
		boolean[] chosen = new boolean[NUM_OF_TRAINSET];
		for(int i = 0; i < NUM_OF_TRAINSET;i++) chosen[i] = true;
		
		int tried_num = 0;
		while(tried_num < NUM_OF_TRAINSET){	
			int rand = (int)Math.floor(Math.random() * NUM_OF_TRAINSET);
			if(chosen[rand]){ 
				
				testPerformance(tried_num,r_mu,1);
				int g = (int)trainSet[rand][NUM_OF_FEATURES];
				double n = r_k_num[g];

				for(int i = 0 ; i < NUM_OF_FEATURES;i++){
					r_mu[g][i] = (r_mu[g][i] * n + trainSet[rand][i])/(n+1);

				}
				r_k_num[g]++;
				chosen[rand] = false;
				tried_num++;
			}

		}
		testPerformance(tried_num,r_mu,1);
					///////**end of random**/////////////
		
	}



}


