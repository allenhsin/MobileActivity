import java.io.*;

public class ParseRawData
{
	public static void main(String[] args)
	{
		try
		{
			if(args.length !=2)
			{
				System.err.println("Error usage: java ParseRawData <raw data input> <parsed raw data output>");
				return;
			}
			
			FileInputStream fstream = new FileInputStream(args[0]);
			DataInputStream in = new DataInputStream(fstream);
			
			FileWriter ostream = new FileWriter(args[1]);
			BufferedWriter out = new BufferedWriter(ostream);
			
			String strLine;
			BufferedReader br = new BufferedReader (new InputStreamReader(in));
			
			while((strLine = br.readLine())!= null)
			{
				String payload[] = strLine.split(",");
				String segLine[] = payload[3].split("\\|");
				long timeStamp   = Long.parseLong(payload[1].substring(0,13));
				
				out.write(timeStamp + "," + segLine[0] + "," + segLine[1] + "," + segLine[2] + "," + segLine[3] + "\n");
			}
			
			out.close();
			in.close();
		}
		catch(Exception e)
		{
			System.err.println("ERROR: "+ e.getMessage() + " "+ e);
		}
		
	}
	
	
}