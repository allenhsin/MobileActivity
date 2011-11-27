/**
 * calMeanWithAllData.java 
 * It assumes it sees all the training example and it calculates the mean for each cluster.
*/

import java.io.*;
public class calMeanWithAllData{

	public static final int NUM_OF_FEATURES = 2;

	public static final int NUM_OF_ACTIVITY = 5;
	public static final int STILL = 0;
	public static final int WALKING = 1;
	public static final int BIKING  = 3;
	public static final int RUNNING = 2;
	public static final int DRIVING = 4;


 	private	static double[] stillMean = new double[NUM_OF_FEATURES];
	private static double[] walkingMean = new double[NUM_OF_FEATURES];
	private static double[] bikingMean = new double[NUM_OF_FEATURES];
	private static double[] runningMean = new double[NUM_OF_FEATURES];
	private static double[] drivingMean = new double[NUM_OF_FEATURES];
	private static int[] counter = new int[NUM_OF_ACTIVITY];


	public static void addFeature(double a[],String p[]){
		for(int i = 0; i < NUM_OF_FEATURES; ++i){
			a[i] += Double.parseDouble(p[i]);
		}	
	}
	public static void main(String args[]){

		
	 try{	
		if(args.length != 1){
			System.err.println("Wrong usage: <Input feature file>");
			return;
		}
		FileInputStream fstream = new FileInputStream(args[0]);
		DataInputStream in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader (new InputStreamReader(in));
	 	String strLine;
		while((strLine = br.readLine())!=null){
			String payload[] = strLine.split(",");
			//int gt_index = payload.length - 1;
			switch (Integer.parseInt(payload[NUM_OF_FEATURES])){
				case STILL:
					addFeature(stillMean,payload);
					++counter[STILL];
					break;
				case WALKING:
					addFeature(walkingMean,payload);
					++counter[WALKING];
					break;
				case BIKING:
					addFeature(bikingMean,payload);
					++counter[BIKING];
					break;
				case RUNNING:
					addFeature(runningMean,payload);
					++counter[RUNNING];
					break;
				case DRIVING:
					addFeature(drivingMean,payload);
					++counter[DRIVING];
					break;
				default:
					break;

			}
		
		}

		for(int i = 0 ; i < NUM_OF_FEATURES; ++i){
			System.out.println(stillMean[i]/counter[STILL]);
			System.out.println(walkingMean[i]/counter[WALKING]);
			System.out.println(bikingMean[i]/counter[BIKING]);
			System.out.println(runningMean[i]/counter[RUNNING]);
			System.out.println(drivingMean[i]/counter[DRIVING]);
			System.out.println();
		}
	}catch(Exception e){ System.err.println("wrong in open file");}
	}

}




