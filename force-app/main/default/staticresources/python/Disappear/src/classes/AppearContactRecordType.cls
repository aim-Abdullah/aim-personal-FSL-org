public class AppearContactRecordType {
	
	public static void UpdateConRecType(List<contact> con, RecordType ac, RecordType ic)
	{			
		for (Contact conloop :con)
		{
			if (conloop.Email != null && conloop.Email.indexof('amgen') == -1 )
			{
				conloop.recordtypeId = ac.Id;
				
			}
			else if (conloop.Email != null && conloop.Email.indexof('amgen') != -1 )
			{
				conloop.recordtypeId = ic.Id;
				
			}
			else
			{
				conloop.recordtypeId = ac.Id;
			}
			
		}
		
		database.update(con, false);
	}

}