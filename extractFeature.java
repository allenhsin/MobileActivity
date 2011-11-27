
/**
 * extractFeature.java 
 * It retrieves raw data from args[0], and outputs the features to args[1]
*/
import java.io.*;

public class extractFeature {

	private static final int TWL = 5;//time window length in sec
	private static final int timeWindowSize = 100 * TWL; 
	private static final int NUM_OF_ACTIVITY = 5;
	private static final String tmp_feature = new String("tmp_feature");

	private static double calMagnitude(String x,String y, String z){

		double accx = Double.parseDouble(x);
		double accy = Double.parseDouble(y);
		double accz = Double.parseDouble(z);

		return Math.sqrt(accx*accx+ accy*accy + accz*accz);
	}

	private static double calMean(double[] p,int len) {
		double sum = 0;  // sum of all the elements

		for (int i=0; i<len; i++) {
			sum += p[i];
		}
		return sum / len;
	}

	private static double calVar(double[] p, double mu, int len) {

		double sum = 0;  // sum of all the elements
		for (int i=0; i < len; i++) {

			sum += Math.pow(p[i]-mu,2);
		}
		return sum / len;
	}

	private static void computeDFT(double X[], double Y[], int len) {
		int N = len;

		for (int i = 1; i < N/2; ++i) {
			double realPart = 0;
			double imgPart = 0;
			for (int j = 0; j < N; ++j) {
				realPart += (X[j] * Math.cos(-(2.0 * Math.PI * i * j)/N));
				imgPart += (X[j] * Math.sin(-(2.0 * Math.PI * i * j)/N));
			}

			Y[i] = Math.sqrt(realPart * realPart + imgPart * imgPart);

		}
	}
	private static void initarr(int x[],int a){
		for(int i = 0;i < x.length;i++){
		    x[i] = a;
		}
	}
	private static int gtvote(int v[],int len){
		
		int[] tmp = new int[NUM_OF_ACTIVITY];
		initarr(tmp,0);
		
		for(int i = 0 ;i < len;i++){
			//System.out.println(v[i]);
			tmp[v[i]]++;
		
		}
		int max = -1;
		int max_index = -1;
		for(int i = 0 ; i < tmp.length;i++ ){
		//	System.out.println(tmp[i]);
			if(tmp[i] > max){
			   max = tmp[i];
		           max_index = i;
			}
			
		}
	    return max_index;
	}


	public static void main(String[] args){

		try{

			if(args.length !=2){
				System.err.println("Error usage: java extractFeature <raw data input> <feature output>");

				return;
			}
			
			FileInputStream fstream = new FileInputStream(args[0]);
			DataInputStream in = new DataInputStream(fstream);

			FileWriter ostream = new FileWriter(tmp_feature);
			BufferedWriter out = new BufferedWriter(ostream);
			
			double[] tw = new double[timeWindowSize];
			int[] gt = new int[timeWindowSize];//ground truth
			String strLine;
			int samplesSeen = 0;
			boolean firstData = true;
			long startTime = 0;
			BufferedReader br = new BufferedReader (new InputStreamReader(in));
			
			while((strLine = br.readLine())!= null)
			{
				//System.out.printf("sample seen: %d\n", samplesSeen);
				
				//System.out.printf("  extract payload\n");
				String payload[] = strLine.split(",");
				
				//System.out.printf("  extract acce\n");
				String segLine[] = payload[3].split("\\|");
				
				//System.out.printf("  extract timeStamp\n");
				long timeStamp = Long.parseLong(payload[1].substring(0,13));
				
				//System.out.printf("  calculate Magnitude\n");
				tw[samplesSeen] = calMagnitude(segLine[0],segLine[1],segLine[2]);

				//System.out.printf("  extract ground truth\n");
				int curGt = Integer.parseInt(segLine[3]);
				gt[samplesSeen]= curGt;


				
				if(firstData)
				{
					//System.out.printf("  record first data\n");
					startTime = timeStamp;
					firstData = false;
				}
				
				
				if((timeStamp - startTime) > TWL * 1000)
				{
					//System.out.printf("  extract feature\n");
					
				    //System.out.println(samplesSeen);
				    //System.out.printf("     compute mean and var\n");
					double twMean = calMean(tw,samplesSeen);
					double twVariance = calVar(tw,twMean,samplesSeen);
					
					//System.out.printf("     compute DFT\n");
					double[] fftOutBuffer = new double [(samplesSeen/2)];
					computeDFT(tw,fftOutBuffer,samplesSeen);
					
					//System.out.printf("     compute peak power\n");
					double peakPower = -Double.MAX_VALUE;
					int peakDFTBin = -1;
					for (int j = 1; j < (samplesSeen / 2); ++j) 
					{
						if (fftOutBuffer[j] > peakPower) 
						{
							peakPower = fftOutBuffer[j];
							peakDFTBin = j;
						}
					}
					double Fs = samplesSeen / ((timeStamp - startTime)/1000);
					double peakFreq = peakDFTBin / (samplesSeen/Fs);
					
					//System.out.printf("     compute ground truth\n");
					int gtActivity = gtvote(gt,samplesSeen);//the activity label for the time window

				
					//write features 
					//System.out.printf("     write features into file\n");
					/*for (int i = 1; i <= 15  ;++i)
					{
					
					    out.write(fftOutBuffer[i] + ",");
					}*/

					out.write(twVariance + "," + peakFreq+ "," + gtActivity+ "\n");		
				    
				    //System.out.printf("     reset window\n");
					samplesSeen = 0;
				    startTime = timeStamp;
				}
				
				//System.out.printf("  go to next sample\n");
				samplesSeen++;

			}

			out.close();
			in.close();
		}catch(Exception e){

			System.err.println("Error: "+ e.getMessage() + " "+ e);
		
		}
	


	}

}
